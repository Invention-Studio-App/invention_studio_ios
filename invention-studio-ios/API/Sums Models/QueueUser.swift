//
//  QueueUser.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 2/15/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import Foundation

class QueueUser: Codable {

    var queueGroupId: Int
    var memberName: String
    var memberUserName: String
    var name: String
    var hasBeenNotified: Bool
    var memberMinutesRemaining: Int
    var memberQueueLocation: Int

    //Used when variable name diverges from JSON Key
    private enum CodingKeys: String, CodingKey {
        case queueGroupId
        case memberName
        case memberUserName
        case name
        case hasBeenNotified
        case memberMinutesRemaining
        case memberQueueLocation
    }
}
