//
//  Tool.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 1/26/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import UIKit

class Tool: Codable {

    //Used externally to easily understand machine status
    enum Status: String {
        case AVAILABLE = "Available"
        case INUSE = "In Use"
        case DOWN = "Down"
        case UNKNOWN = "Unknown"
    }

    var equipmentGroupId: Int = 0
    var locationId: Int = 0
    var toolId: Int = 0
    var currentUserUserName: String = ""
    var equipmentGroupDescription: String = ""
    var equipmentGroupName: String = ""
    var locationAddress: String = ""
    var locationDescription: String = ""
    var locationManager: String = ""
    var locationName: String = ""
    var locationUrl: String = ""
    var toolCurrentUser: String = ""
    var toolDescription: String = ""
    var toolName: String = ""
    var locationPhone: String = ""
    var toolInUseSince: Date = Date()
    var toolIsOperational: Bool = false

    //Automatically calculates machine's status based on given data
    func status() -> Status {
        if !toolIsOperational {
            return Status.DOWN
        } else if currentUserUserName != "" {
            return Status.INUSE
        } else {
            return Status.AVAILABLE
        }
    }
}
