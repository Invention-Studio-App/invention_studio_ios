//
//  LandingVC.swift
//  invention-studio-ios
//
//  Created by Noah Sutter on 1/21/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import UIKit

class LandingVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.bool(forKey: "LoggedIn") {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
