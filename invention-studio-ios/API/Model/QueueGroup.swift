//
//  QueueGroup.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 2/15/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import Foundation

class QueueGroup: NSObject {

    var name: String
    var id: Int
    var isGroup: Bool

    init(with JSONDict: Dictionary<String, String>) {
        name = JSONDict["Name"]!
        id = Int(JSONDict["ID"]!)!
        isGroup = Bool(JSONDict["isGroup"]!)!
    }
}
