//
//  User.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 2/15/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import Foundation

class User: NSObject {

    var equipmentGroupId: Int
    var templateId: Int
    var equipmentGroupName: String
    var templateName: String
    var userName: String
    var userUserName: String

    init(with JSONDict: Dictionary<String, String>) {
        equipmentGroupId = Int(JSONDict["equipmentGroupId"]!)!
        templateId = Int(JSONDict["templateId"]!)!
        equipmentGroupName = JSONDict["equipmentGroupName"]!
        templateName = JSONDict["templateName"]!
        userName = JSONDict["userName"]!
        userUserName = JSONDict["userUserName"]!
    }
}
