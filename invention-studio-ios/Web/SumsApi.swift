//
//  SumsApi.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 2/9/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//
//  Base class includes subclasses which represent the API modules
//

import Foundation

class SumsApi {

#if DEBUG
    private static let siteURL = "https://sums-dev.gatech.edu/SUMSAPI/rest/API/" //Development
#else
    private static let siteURL = "https://sums.gatech.edu/SUMSAPI/rest/API/" //Production
#endif

    //User module
    class User {

        //Info request
        //Returns a flattened array of user info and their associated equipment groups
        static func Info(completion: @escaping ([UserInfo]?, String?) -> ()) {
            let username = UserDefaults.standard.string(forKey: "Username")!
            let userKey = UserDefaults.standard.string(forKey: "UserKey")!

            var url = SumsApi.siteURL + "user_info"
            url += "?username=\(username)"

            APIHelper.sendRequest(url: url,
                                  method: .POST,
                                  body: nil,
                                  authHeader: userKey,
                                  xApiKeyHeader: nil,
                                  completion: { data, response, error in
                                    if error != nil {
                                        completion(nil, "Error:An unknown error occurred. Please try again later.")
                                        return
                                    }

                                    //Check for unexpected status codes
                                    if response!.statusCode != 200 {
                                        print("statusCode should be 200, but is \(response!.statusCode)")
                                        print("response: \(response!)")
                                        return
                                    }
                                    //Automatically decode response into a JSON array
                                    let responseArray = try! JSONDecoder().decode([UserInfo].self, from: data!)
                                    //"Return" the data to the caller's completion handler
                                    completion(responseArray, nil)
            })
        }

    }

    //EquipmentGroup module
    class EquipmentGroup {

        //*Unauthenticated* Equipment Group Info request
        //Returns a JSON entry of info for the equipment group
        static func Info(completion: @escaping (EquipmentGroupInfo?, String?) -> ()) {
            let equipmentGroupId = 8

            var url = SumsApi.siteURL + "equipmentGroup_info"
            url += "?equipmentGroupId=\(equipmentGroupId)"

            APIHelper.sendRequest(url: url,
                                  method: .POST,
                                  body: nil,
                                  authHeader: nil,
                                  xApiKeyHeader: nil,
                                  completion: { data, response, error in
                                    if error != nil {
                                        completion(nil, "Error:An unknown error occurred. Please try again later.")
                                        return
                                    }

                                    //Check for unexpected status codes
                                    if response!.statusCode != 200 {
                                        print("statusCode should be 200, but is \(response!.statusCode)")
                                        print("response: \(response!)")
                                        return
                                    }
                                    //Automatically decode response into a JSON array
                                    let decoder = JSONDecoder()
                                    //Use the custom date decoder defined below to decode two possible date formats
                                    decoder.dateDecodingStrategy = .customDateDecoder()
                                    let responseInfo = try! decoder.decode(EquipmentGroupInfo.self, from: data!)
                                    responseInfo.equipmentGroupShortName = responseInfo.equipmentGroupShortName.replacingOccurrences(of: "_", with: " ")

                                    //"Return" the data to the caller's completion handler
                                    completion(responseInfo, nil)
            })
        }

        //Tools request
        //Returns a flattened array of tools and their associated locations
        static func Tools(completion: @escaping ([Tool]?, String?) -> ()) {
            let username = UserDefaults.standard.string(forKey: "Username")!
            let userKey = UserDefaults.standard.string(forKey: "UserKey")!
            let departmentId = UserDefaults.standard.integer(forKey: "DepartmentId")

            var url = SumsApi.siteURL + "equipmentGroup_tools"
            url += "?username=\(username)"
            url += "&DepartmentId=\(departmentId)"

            APIHelper.sendRequest(url: url,
                                  method: .POST,
                                  body: nil,
                                  authHeader: userKey,
                                  xApiKeyHeader: nil,
                                  completion: { data, response, error in
                                    if error != nil {
                                        completion(nil, "Error:An unknown error occurred. Please try again later.")
                                        return
                                    }

                                    //Check for unexpected status codes
                                    if response!.statusCode != 200 {
                                        print("statusCode should be 200, but is \(response!.statusCode)")
                                        print("response: \(response!)")
                                        return
                                    }
                                    //Automatically decode response into a JSON array
                                    let decoder = JSONDecoder()
                                    //Use the custom date decoder defined below to decode two possible date formats
                                    decoder.dateDecodingStrategy = .customDateDecoder()
                                    var responseArray = try! decoder.decode([Tool].self, from: data!)

                                    //Sort the array
                                    responseArray.sort(by: { (toolA, toolB) in
                                        if (toolA.status().hashValue == toolB.status().hashValue) {
                                            return toolA.toolName <= toolB.toolName
                                        }
                                        return toolA.status().hashValue <= toolB.status().hashValue
                                    })

                                    //"Return" the data to the caller's completion handler
                                    completion(responseArray, nil)
            })
        }

        //QueueGroups request
        //Returns an array of available queue groups and tools
        static func QueueGroups(completion: @escaping ([QueueGroup]?, String?) -> ()) {
            let username = UserDefaults.standard.string(forKey: "Username")!
            let userKey = UserDefaults.standard.string(forKey: "UserKey")!
            let departmentId = UserDefaults.standard.integer(forKey: "DepartmentId")

            var url = SumsApi.siteURL + "equipmentGroup_queueGroups"
            url += "?username=\(username)"
            url += "&DepartmentId=\(departmentId)"

            APIHelper.sendRequest(url: url,
                                  method: .POST,
                                  body: nil,
                                  authHeader: userKey,
                                  xApiKeyHeader: nil,
                                  completion: { data, response, error in
                                    if error != nil {
                                        completion(nil, "Error:An unknown error occurred. Please try again later.")
                                        return
                                    }

                                    //Check for unexpected status codes
                                    if response!.statusCode != 200 {
                                        print("statusCode should be 200, but is \(response!.statusCode)")
                                        print("response: \(response!)")
                                        return
                                    }
                                    //Automatically decode response into a JSON array
                                    let responseArray = try! JSONDecoder().decode([QueueGroup].self, from: data!)
                                    //"Return" the data to the caller's completion handler
                                    completion(responseArray, nil)
            })
        }

        //QueueUsers request
        //Returns a flattened array of currently queued users and their associated queue group
        static func QueueUsers(completion: @escaping ([QueueUser]?, String?) -> ()) {
            let username = UserDefaults.standard.string(forKey: "Username")!
            let userKey = UserDefaults.standard.string(forKey: "UserKey")!
            let departmentId = UserDefaults.standard.integer(forKey: "DepartmentId")

            var url = SumsApi.siteURL + "equipmentGroup_queueUsers"
            url += "?username=\(username)"
            url += "&DepartmentId=\(departmentId)"

            APIHelper.sendRequest(url: url,
                                  method: .POST,
                                  body: nil,
                                  authHeader: userKey,
                                  xApiKeyHeader: nil,
                                  completion: { data, response, error in
                                    if error != nil {
                                        completion(nil, "Error:An unknown error occurred. Please try again later.")
                                        return
                                    }

                                    //Check for unexpected status codes
                                    if response!.statusCode != 200 {
                                        print("statusCode should be 200, but is \(response!.statusCode)")
                                        print("response: \(response!)")
                                        return
                                    }
                                    //Automatically decode response into a JSON array
                                    let decoder = JSONDecoder()
                                    //Use the custom date decoder defined below to decode two possible date formats
                                    decoder.dateDecodingStrategy = .customDateDecoder()
                                    let responseArray = try! decoder.decode([QueueUser].self, from: data!)
                                    //"Return" the data to the caller's completion handler

                                    completion(responseArray, nil)
            })
        }
    }
}

//Used to decode both iso8601 dates and rfc3339
fileprivate extension JSONDecoder.DateDecodingStrategy {
    static func customDateDecoder() -> JSONDecoder.DateDecodingStrategy {
        return .custom({ (decoder) -> Date in
            //Get the date string from the parameters
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)

            let formatter = DateFormatter()
            //First, try iso8601
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            if let date = formatter.date(from: dateStr) {
                return date
            }
            //If that fails, try rfc3339 (used for 1900-01-01T00:00:00)
            formatter.dateFormat = "yyyy-MM-ddTHH:mm:ss"
            if let date = formatter.date(from: dateStr) {
                return date
            }
            //If that fails, return minimum date
            return Date(timeIntervalSince1970: 0)
        })
    }
}
