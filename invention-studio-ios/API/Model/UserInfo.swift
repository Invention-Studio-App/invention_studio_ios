//
//  User.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 2/15/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import Foundation

class UserInfo: Codable {

    var equipmentGroupId: Int
    var templateId: Int
    var equipmentGroupName: String
    var templateName: String
    var userName: String
    var userUserName: String

    private enum CodingKeys: String, CodingKey {
        case equipmentGroupId
        case templateId
        case equipmentGroupName
        case templateName
        case userName
        case userUserName
    }

    func isInventionStudio() -> Bool {
        if equipmentGroupName == "Invention Studio at Georgia Tech" || equipmentGroupName == "Georgia Tech Invention Studio" {
            return true
        }
        return false
    }
}
