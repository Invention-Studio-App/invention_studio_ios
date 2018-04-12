//
//  ISTableViewController.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 2/25/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import UIKit

class ISTableViewController: UITableViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        view.backgroundColor = Theme.background
        view.tintColor = Theme.accentPrimary

        self.view.setNeedsDisplay()
        self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SoundHelper.sharedHelper.playSound()
    }
}
