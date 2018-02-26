//
//  ColorThemeTVC.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 2/26/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import UIKit

class ColorThemeTVC: ISTableViewController {

    var selectedIndexPath: IndexPath? = nil

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        selectedIndexPath = IndexPath(row: Theme.currentTheme.rawValue, section: 0)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Theme.displayNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "themePrototype", for: indexPath)
        cell.backgroundColor = Theme.focusBackground
        cell.textLabel?.textColor = Theme.title

        cell.textLabel?.text = Theme.displayNames[indexPath.row]
        if indexPath == selectedIndexPath {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        selectedIndexPath = indexPath
        let selectedTheme = cell?.textLabel?.text
        Theme.set(theme: Theme.themeFor(displayName: selectedTheme!))
        Theme.apply()

        self.navigationController?.navigationBar.barTintColor = Theme.headerFooter
        self.navigationController?.navigationBar.tintColor = Theme.accentPrimary
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: Theme.headerTitle]

        self.tabBarController?.tabBar.barTintColor = Theme.headerFooter
        self.tabBarController?.tabBar.unselectedItemTintColor = Theme.accentSecondary
        self.tabBarController?.tabBar.tintColor = Theme.accentPrimary

        self.tableView.separatorColor = Theme.accentTertiary

        tableView.reloadData()
        self.viewWillAppear(true)
    }

}
