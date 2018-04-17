//
//  User.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 2/15/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

class UserInfo: Codable {

    var equipmentGroupId: Int = 0
    var templateId: Int = 0
    var equipmentGroupName: String = ""
    var templateName: String = ""
    var userName: String = ""
    var userUserName: String = ""

    func isInventionStudio() -> Bool {
        if equipmentGroupName == "Invention Studio at Georgia Tech" || equipmentGroupName == "Georgia Tech Invention Studio" {
            return true
        }
        return false
    }
}
