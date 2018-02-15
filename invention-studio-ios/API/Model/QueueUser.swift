//
//  QueueUser.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 2/15/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import Foundation

class QueueUser: NSObject {

    var queueGroupId: Int
    var memberName: String
    var memberUserName: String
    var name: String
    var hasBeenNotified: Bool
    var memberMinutesRemaining: Int
    var memberQueueLocation: Int

    init(with JSONDict: Dictionary<String, String>) {
        queueGroupId = Int(JSONDict["queueGroupId"]!)!
        memberName = JSONDict["memberName"]!
        memberUserName = JSONDict["memberUserName"]!
        name = JSONDict["name"]!
        hasBeenNotified = Bool(JSONDict["hasBeenNotified"]!)!
        memberMinutesRemaining = Int(JSONDict["memberMinutesRemaining"]!)!
        memberQueueLocation = Int(JSONDict["memberQueueLocation"]!)!
    }
}
