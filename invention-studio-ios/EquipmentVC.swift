//
//  EquipmentVC.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 1/26/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import UIKit

class EquipmentVC: UIViewController {

    @IBOutlet weak var segmentContainer: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var informationView: UIView!
    @IBOutlet weak var reportProblemView: UIView!

    var segmentViews = Array<UIView>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.segmentViews.append(informationView)
        self.segmentViews.append(reportProblemView)
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: segmentContainer.frame.minX, y: segmentContainer.frame.maxY))
        linePath.addLine(to: CGPoint(x: segmentContainer.frame.maxX, y: segmentContainer.frame.maxY))
        line.path = linePath.cgPath
        line.strokeColor = UIColor.lightGray.cgColor
        line.lineWidth = 0.5
        segmentContainer.layer.addSublayer(line)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        for (i, view) in segmentViews.enumerated() {
            if i == sender.selectedSegmentIndex {
                view.isHidden = false
            } else {
                view.isHidden = true
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
