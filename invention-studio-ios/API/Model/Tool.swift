//
//  Tool.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 1/26/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import Foundation
import UIKit

class Tool: NSObject {

    enum Status: String {
        case AVAILABLE = "Available"
        case INUSE = "In Use"
        case DOWN = "Down"
        case UNKNOWN = "Unknown"
    }

    var equipmentGroupId: Int
    var locationId: Int
    var toolId: Int
    var currentUserUserName: String
    var equipmentGroupDescription: String
    var equipmentGroupName: String
    var locationAddress: String
    var locationManager: String
    var locationName: String
    var locationUrl: String
    var toolCurrentUser: String
    var toolDescription: String
    var toolName: String
    var locationPhone: String
    var toolInUseSince: Date
    var toolIsOperational: Bool

    init(with JSONDict: Dictionary<String, String>) {
        equipmentGroupId = Int(JSONDict["equipmentGroupId"]!)!
        locationId = Int(JSONDict["locationId"]!)!
        toolId = Int(JSONDict["toolId"]!)!
        currentUserUserName = JSONDict["CurrentUserUserName"]!
        equipmentGroupDescription = JSONDict["equipmentGroupdescription"]!
        equipmentGroupName = JSONDict["equipmentGroupName"]!
        locationAddress = JSONDict["locationAddress"]!
        locationManager = JSONDict["locationManager"]!
        locationName = JSONDict["locationName"]!
        locationUrl = JSONDict["locationUrl"]!
        toolCurrentUser = JSONDict["toolCurrentUser"]!
        toolDescription = JSONDict["toolDescription"]!
        toolName = JSONDict["toolName"]!
        locationPhone = JSONDict["locationPhone"]!

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        toolInUseSince = dateFormatter.date(from: JSONDict["toolInUseSince"]!)!

        toolIsOperational = Bool(JSONDict["toolIsOperational"]!)!
    }
}
