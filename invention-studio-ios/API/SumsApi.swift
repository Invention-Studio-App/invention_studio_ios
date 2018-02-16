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

//    private static let siteURL = "https://sums.gatech.edu/SUMSAPI/rest/API/" //Production
    private static let siteURL = "https://sums-dev.gatech.edu/SUMSAPI/rest/API/" //Development

    //User module
    class User {

        //Info request
        //Returns a flattened array of user info and their associated equipment groups
        static func Info(completion: @escaping ([UserInfo]) -> ()) {
            SumsApi.submitRequest(module: "user_info", parameters: nil, completion: { data in
                //Automatically decode response into a JSON array
                let responseArray = try! JSONDecoder().decode([UserInfo].self, from: data)
                //"Return" the data to the caller's completion handler
                completion(responseArray)
            })
        }

    }

    //EquipmentGroup module
    class EquipmentGroup {

        //Tools request
        //Returns a flattened array of tools and their associated locations
        static func Tools(completion: @escaping ([Tool]) -> ()) {
            let departmentId = UserDefaults.standard.integer(forKey: "DepartmentId")
            let parameters = ["DepartmentId": "\(departmentId)"]
            SumsApi.submitRequest(module: "equipmentGroup_tools", parameters: parameters, completion: { data in
                //Automatically decode response into a JSON array
                let decoder = JSONDecoder()
                //Use the custom date decoder defined below to decode two possible date formats
                decoder.dateDecodingStrategy = .customDateDecoder()
                let responseArray = try! decoder.decode([Tool].self, from: data)
                //"Return" the data to the caller's completion handler
                completion(responseArray)
            })
        }

        //QueueGroups request
        //Returns an array of available queue groups and tools
        static func QueueGroups(completion: @escaping ([QueueGroup]) -> ()) {
            let departmentId = UserDefaults.standard.integer(forKey: "DepartmentId")
            let parameters = ["DepartmentId": "\(departmentId)"]
            SumsApi.submitRequest(module: "equipmentGroup_queueGroups", parameters: parameters, completion: { data in
                //Automatically decode response into a JSON array
                let responseArray = try! JSONDecoder().decode([QueueGroup].self, from: data)
                //"Return" the data to the caller's completion handler
                completion(responseArray)
            })
        }

        //QueueUsers request
        //Returns a flattened array of currently queued users and their associated queue group
        static func QueueUsers(completion: @escaping ([QueueUser]) -> ()) {
            let departmentId = UserDefaults.standard.integer(forKey: "DepartmentId")
            let parameters = ["DepartmentId": "\(departmentId)"]
            SumsApi.submitRequest(module: "equipmentGroup_queueUsers", parameters: parameters, completion: { data in
                //Automatically decode response into a JSON array
                let decoder = JSONDecoder()
                //Use the custom date decoder defined below to decode two possible date formats
                decoder.dateDecodingStrategy = .customDateDecoder()
                let responseArray = try! decoder.decode([QueueUser].self, from: data)
                //"Return" the data to the caller's completion handler
                completion(responseArray)
            })
        }
    }

    //Generic API request - handles all of the "nasty" code to minimize each individual method above
    fileprivate static func submitRequest(module: String,
                                          parameters: Dictionary<String, String>?,
                                          completion: @escaping (Data) -> ()) {
        //Retrieve user key and username, which will be required every time
        let userKey = UserDefaults.standard.string(forKey: "UserKey")!
        let username = UserDefaults.standard.string(forKey: "Username")!

        //Build the URL, siteurl + the request module
        let baseURL = siteURL + module
        //Add the username parameter
        var requestURL = baseURL + "?username=" + username
        //Add other parameters if provided
        if let unwrappedParameters = parameters {
            for parameter in unwrappedParameters {
                requestURL = requestURL + "&" + parameter.key + "=" + parameter.value
            }
        }
        //Create a URL request from the url string
        var request = URLRequest(url: URL(string: requestURL)!)

        //Set request type and headers
        request.httpMethod = "POST"
        request.setValue("application/JSON", forHTTPHeaderField: "Content-Type")
        request.setValue(userKey, forHTTPHeaderField: "Authorization")

        //Make the request using completion handler
        URLSession.shared.dataTask(with: request) { data, response, error in
            //Check for errors
            guard let data = data, error == nil else {
                print("error: \(error!)")
                return
            }

            //Check for unexpected status codes
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response: \(response!)")
            }

            //"Return" the data to the caller's completion handler
            completion(data)

            }.resume()
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
            print(dateStr)
            return Date(timeIntervalSince1970: 0)
        })
    }
}
