//
//  OtherTVC.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 1/26/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import UIKit
import WebKit
import FirebaseMessaging

class OtherTVC: ISTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        
        if (tableView.cellForRow(at: indexPath)?.reuseIdentifier == "logoutCell") {
            logout()
        }
    }

    private func logout() {
        let username = UserDefaults.standard.string(forKey: "Username")!
        Messaging.messaging().unsubscribe(fromTopic: "\(username)_ios")
        UserDefaults.standard.set(false, forKey: "LoggedIn")
        UserDefaults.standard.set(0, forKey: "DepartmentId")
        UserDefaults.standard.set(nil, forKey: "Name")
        UserDefaults.standard.set(nil, forKey: "Username")
        UserDefaults.standard.set(nil, forKey: "UserKey")
        UserDefaults.standard.set(0, forKey: "LoginSession")

        performSegue(withIdentifier: "logoutSegue", sender: self)
    }
}
