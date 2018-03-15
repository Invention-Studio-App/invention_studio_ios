//
//  OtherTVC.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 1/26/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import UIKit

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
        if (tableView.cellForRow(at: indexPath)?.reuseIdentifier == "logoutCell") {
            logout()
        }
    }

    private func logout() {
        UserDefaults.standard.set(false, forKey: "LoggedIn")
        UserDefaults.standard.set(0, forKey: "DepartmentId")
        UserDefaults.standard.set(nil, forKey: "UserName")
        UserDefaults.standard.set(nil, forKey: "UserKey")
        UserDefaults.standard.set(0, forKey:"LoginSession")

        performSegue(withIdentifier: "logoutSegue", sender: self)
    }
}
