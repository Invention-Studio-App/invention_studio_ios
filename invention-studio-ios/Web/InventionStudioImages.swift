//
//  InventionStudioImages.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 4/17/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import UIKit

class InventionStudioImages {

    private static let siteURL = "https://is-apps.me.gatech.edu/resources/images/" //Development

    static func imageForResource(group: String, name: String) -> UIImage? {
        let url = siteURL + "\(formatString(string: group))/\(formatString(string: name)).jpg"
        return requestImage(url: url)
    }

    static func imageForTool(locationName: String, toolName: String) -> UIImage? {
        let url = siteURL + "tools/\(formatString(string: locationName))/\(formatString(string: toolName)).jpg"
        return requestImage(url: url)
    }

    private static func formatString(string: String) -> String {
        let chars = CharacterSet.letters.union(CharacterSet.decimalDigits).union(CharacterSet.whitespaces).inverted

        var newString = string.components(separatedBy: chars).joined()
        newString = newString.replacingOccurrences(of: " ", with: "_").lowercased()
        while newString.contains("__") {
            newString = newString.replacingOccurrences(of: "__", with: "_")
        }
        return newString
    }

    private static func requestImage(url: String) -> UIImage? {
        let data = try? Data(contentsOf: URL(string: url)!)
        if data != nil {
            return UIImage(data: data!)
        } else {
            return UIImage()
        }
    }

}
