//
//  ISTabBar.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 4/2/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import UIKit

class ISTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        delegate = self
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        SoundHelper.sharedHelper.playSound()
        return true
    }
}
