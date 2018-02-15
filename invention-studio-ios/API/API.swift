//
//  API.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 2/9/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//
//  Base class includes subclasses which represent the API modules
//

import Foundation

class API {

    private let baseURL = "https://sums.gatech.edu/SUMSAPI/rest/API/"

    class User {

        static func Info() {
            let userKey = UserDefaults.standard.value(forKey: "UserKey")
            let username = UserDefaults.standard.value(forKey: "Username")
        }

    }

    class EquipmentGroup {

        static func Tools() {

        }

        static func QueueGroups() {

        }

        static func QueueUsers() {

        }

    }

}
