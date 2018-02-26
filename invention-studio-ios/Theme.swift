//
//  Theme.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 2/25/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import UIKit

enum Theme: Int {

    case light = 0
    case dark = 1

    static let displayNames = ["Light", "Dark"]
    static let names = ["ISLight", "ISDark"]

    static var currentTheme: Theme {
        let storedTheme = UserDefaults.standard.integer(forKey: "Theme")
        return Theme(rawValue: storedTheme) ?? .light
        //Default to light if no theme is stored
    }

    static var accentPrimary: UIColor {
        return UIColor(named: Theme.nameFor(theme: currentTheme) + "_AccentPrimary")!
    }

    static var accentSecondary: UIColor {
        return UIColor(named: Theme.nameFor(theme: currentTheme) + "_AccentSecondary")!
    }

    static var accentTertiary: UIColor {
        return UIColor(named: Theme.nameFor(theme: currentTheme) + "_AccentTertiary")!
    }

    static var background: UIColor {
        return UIColor(named: Theme.nameFor(theme: currentTheme) + "_Background")!
    }

    static var focusBackground: UIColor {
        return UIColor(named: Theme.nameFor(theme: currentTheme) + "_FocusBackground")!
    }

    static var headerFooter: UIColor {
        return UIColor(named: Theme.nameFor(theme: currentTheme) + "_HeaderFooter")!
    }

    static var headerTitle: UIColor {
        return UIColor(named: Theme.nameFor(theme: currentTheme) + "_HeaderTitle")!
    }

    static var text: UIColor {
        return UIColor(named: Theme.nameFor(theme: currentTheme) + "_Text")!
    }

    static var title: UIColor {
        return UIColor(named: Theme.nameFor(theme: currentTheme) + "_Title")!
    }

    static func themeFor(displayName: String) -> Theme {
        return Theme(rawValue: Theme.displayNames.index(of: displayName) ?? 0)!
    }

    static func displayNameFor(theme: Theme) -> String {
        return Theme.displayNames[theme.rawValue]
    }

    static func nameFor(theme: Theme) -> String {
        return Theme.names[theme.rawValue]
    }

    static func set(theme: Theme) {
        UserDefaults.standard.set(theme.rawValue, forKey: "Theme")
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

        /*
         * UITableView
         */
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
