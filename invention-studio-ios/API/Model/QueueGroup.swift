//
//  QueueGroup.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 2/15/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import Foundation

class QueueGroup: Codable {

    var name: String
    var id: Int
    var isGroup: Bool

    //Used when variable name diverges from JSON Key
    private enum CodingKeys: String, CodingKey {
        case name = "Name"
        case id = "ID"
        case isGroup
    }
}
