//
//  Theme.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 2/25/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import UIKit

enum Theme: String {

    case light = "ISLight"
    case dark = "ISDark"

    private static var currentTheme: Theme {
        let storedTheme = UserDefaults.standard.string(forKey: "Theme") ?? ""
        return Theme(rawValue: storedTheme) ?? .light
        //Default to light if no theme is stored
    }

    static var accentPrimary: UIColor {
        return UIColor(named: currentTheme.rawValue + "_AccentPrimary")!
    }

    static var accentSecondary: UIColor {
        return UIColor(named: currentTheme.rawValue + "_AccentSecondary")!
    }

    static var accentTertiary: UIColor {
        return UIColor(named: currentTheme.rawValue + "_AccentTertiary")!
    }

    static var background: UIColor {
        return UIColor(named: currentTheme.rawValue + "_Background")!
    }

    static var focusBackground: UIColor {
        return UIColor(named: currentTheme.rawValue + "_FocusBackground")!
    }

    static var headerFooter: UIColor {
        return UIColor(named: currentTheme.rawValue + "_HeaderFooter")!
    }

    static var headerTitle: UIColor {
        return UIColor(named: currentTheme.rawValue + "_HeaderTitle")!
    }

    static var text: UIColor {
        return UIColor(named: currentTheme.rawValue + "_Text")!
    }

    static var title: UIColor {
        return UIColor(named: currentTheme.rawValue + "_Title")!
    }

    static func apply() {

        /*
         * UINavigationBar
         */
        UINavigationBar.appearance().barTintColor = Theme.headerFooter
        UINavigationBar.appearance().tintColor = Theme.accentPrimary
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: Theme.headerTitle]

        /*
         * UITabBar
         */
        UITabBar.appearance().barTintColor = Theme.headerFooter
        UITabBar.appearance().unselectedItemTintColor = Theme.accentSecondary
        UITabBar.appearance().tintColor = Theme.accentPrimary

        UITableView.appearance().separatorColor = Theme.accentTertiary
        /*
         * UITableViewCell
         */
        UITableViewCell.appearance().backgroundColor = Theme.focusBackground

        /*
         * UISegmentedControl
         */
        UISegmentedControl.appearance().tintColor = Theme.accentPrimary

        /*
         * UISwitch
         */
        UISwitch.appearance().onTintColor = Theme.accentPrimary

        /*
         * UILabel
         */
        UILabel.appearance().textColor = Theme.title

        /*
         * UITextView
         */
        UITextView.appearance().textColor = Theme.text
        UITextView.appearance().tintColor = Theme.accentTertiary

    }
}
