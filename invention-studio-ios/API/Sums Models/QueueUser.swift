//
//  QueueUser.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 2/15/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

class QueueUser: Codable {

    var queueGroupId: Int = 0
    var memberName: String = ""
    var memberUserName: String = ""
    var queueName: String = ""
    var hasBeenNotified: Bool = false
    var isGroup: Bool = false
    var memberMinutesRemaining: Int = 0
    var memberQueueLocation: Int = 0

}
