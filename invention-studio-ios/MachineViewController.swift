//
//  IndividualMachineViewController.swift
//  invention-studio-ios
//
//  Created by Noah Sutter on 1/25/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import UIKit

class MachineViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    
    var orderedViewControllers: [UIViewController]!
    var pageControl = UIPageControl()
    var machine = "Machine"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = self.machine
        
        orderedViewControllers = {
            return [newVc(viewController: "MachineInfoViewController"),
                    newVc(viewController: "MachineReportProblemViewController")]
        }()
        
        self.dataSource = self
        self.delegate = self
        configurePageControl()
    
        
        // This sets up the first view that will show up on our page control
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
            direction: .forward,
            animated: true,
            completion: nil)
        }
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.height - 200 , width: UIScreen.main.bounds.width, height: 0))
        self.pageControl.numberOfPages = orderedViewControllers.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
    }
    
    
    
    
    
    func newVc(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    
    
    
    
    
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewController)!
    }
    
    
    
    // MARK: Data source functions.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
    return nil
    }
    
    let previousIndex = viewControllerIndex - 1
    
    // User is on the first view controller and swiped left to loop to
    // the last view controller.
    guard previousIndex >= 0 else {
        return orderedViewControllers.last
    }
    
    guard orderedViewControllers.count > previousIndex else {
        return nil
    }
    
    return orderedViewControllers[previousIndex]
    }
    
     func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
    return nil
    }
    
    let nextIndex = viewControllerIndex + 1
    let orderedViewControllersCount = orderedViewControllers.count
    
    // User is on the last view controller and swiped right to loop to
    // the first view controller.
    guard orderedViewControllersCount != nextIndex else {
        return orderedViewControllers.first
    }
    
    guard orderedViewControllersCount > nextIndex else {
        return nil
    }
    
    return orderedViewControllers[nextIndex]
    }

}