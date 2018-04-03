//
//  InventionStudioAPI.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 4/2/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import Foundation

class InventionStudioApi {

    private static let siteURL = "https://is-apps.me.gatech.edu/api/v1-0/"
    private static let apiKey = "88c0a47e-6396-4463-87f5-c726c1da9874"

    //User module
    class User {

        //Info request
        //Records user login. If the user is new, creates a new entry in the database.
        static func login(form: LoginForm, completion: @escaping (String) -> ()) {
            let formData = try! JSONEncoder().encode(form)
            let url = InventionStudioApi.siteURL + "user/login"

            APIHelper.sendRequest(url: url,
                                  method: .POST,
                                  body: formData,
                                  authHeader: nil,
                                  xApiKeyHeader: InventionStudioApi.apiKey,
                                  completion: { data, response in
                                    //Check for unexpected status codes
                                    if response.statusCode != 200 {
                                        print("statusCode should be 200, but is \(response.statusCode)")
                                        print("response: \(response)")
                                        return
                                    }
                                    //Automatically decode response into a JSON array
                                    let response = try! JSONDecoder().decode(String.self, from: data)
                                    //"Return" the data to the caller's completion handler
                                    completion(response)
            })
        }
    }

    //Server module
    class Server {

        //app_status request
        //Status message to be processed on app startup. Useful for conveying important information about app updates.
        static func app_status(completion: @escaping (String) -> ()) {
            let url = InventionStudioApi.siteURL + "server/app_status"

            APIHelper.sendRequest(url: url,
                                  method: .GET,
                                  body: nil,
                                  authHeader: nil,
                                  xApiKeyHeader: InventionStudioApi.apiKey,
                                  completion: { data, response in
                                    //Check for unexpected status codes
                                    if response.statusCode != 200 && response.statusCode != 204 {
                                        print("statusCode should be 200 or 204, but is \(response.statusCode)")
                                        print("response: \(response)")
                                        return
                                    }
                                    //Automatically decode response into a JSON array
                                    let response = try! JSONDecoder().decode(String.self, from: data)
                                    //"Return" the data to the caller's completion handler
                                    completion(response)
            })
        }

        //timestamp request
        //Get the Unix timestamp of the server. Use instead of device time.
        static func timestamp(completion: @escaping (Int) -> ()) {
            let url = InventionStudioApi.siteURL + "server/timestamp"

            APIHelper.sendRequest(url: url,
                                  method: .GET,
                                  body: nil,
                                  authHeader: nil,
                                  xApiKeyHeader: nil,
                                  completion: { data, response in
                                    //Check for unexpected status codes
                                    if response.statusCode != 200 {
                                        print("statusCode should be 200, but is \(response.statusCode)")
                                        print("response: \(response)")
                                        return
                                    }
                                    //Automatically decode response into a JSON array
                                    let response = try! JSONDecoder().decode(Int.self, from: data)
                                    //"Return" the data to the caller's completion handler
                                    completion(response)
            })
        }
    }

    class Feedback {

        //tool_broken request
        //Submit report that a tool is broken
        static func tool_broken(form: ToolBrokenFeedbackForm, completion: @escaping (String) -> ()) {
            let username = UserDefaults.standard.string(forKey: "Username")!
            let userKey = UserDefaults.standard.string(forKey: "UserKey")!
            let auth = APIHelper.encodeBasicAuth(username: username, password: userKey)
            let formData = try! JSONEncoder().encode(form)
            let url = InventionStudioApi.siteURL + "feedback/tool_broken"

            APIHelper.sendRequest(url: url,
                                  method: .POST,
                                  body: formData,
                                  authHeader: auth,
                                  xApiKeyHeader: InventionStudioApi.apiKey,
                                  completion: { data, response in
                                    //Check for unexpected status codes
                                    if response.statusCode != 200 {
                                        print("statusCode should be 200, but is \(response.statusCode)")
                                        print("response: \(response)")
                                        return
                                    }
                                    //Automatically decode response into a JSON array
                                    let response = try! JSONDecoder().decode(String.self, from: data)
                                    //"Return" the data to the caller's completion handler
                                    completion(response)
            })
        }

        //staff request
        //Submit feedback about a staff member
        static func staff(form: StaffFeedbackForm, completion: @escaping (String) -> ()) {
            let username = UserDefaults.standard.string(forKey: "Username")!
            let userKey = UserDefaults.standard.string(forKey: "UserKey")!
            let auth = APIHelper.encodeBasicAuth(username: username, password: userKey)
            let formData = try! JSONEncoder().encode(form)
            let url = InventionStudioApi.siteURL + "feedback/staff"

            APIHelper.sendRequest(url: url,
                                  method: .POST,
                                  body: formData,
                                  authHeader: auth,
                                  xApiKeyHeader: InventionStudioApi.apiKey,
                                  completion: { data, response in
                                    //Check for unexpected status codes
                                    if response.statusCode != 200 {
                                        print("statusCode should be 200, but is \(response.statusCode)")
                                        print("response: \(response)")
                                        return
                                    }
                                    //Automatically decode response into a JSON array
                                    let response = try! JSONDecoder().decode(String.self, from: data)
                                    //"Return" the data to the caller's completion handler
                                    completion(response)
            })
        }

        //general request
        //Submit general feedback
        static func general(form: GeneralFeedbackForm, completion: @escaping (String) -> ()) {
            let username = UserDefaults.standard.string(forKey: "Username")!
            let userKey = UserDefaults.standard.string(forKey: "UserKey")!
            let auth = APIHelper.encodeBasicAuth(username: username, password: userKey)
            let formData = try! JSONEncoder().encode(form)
            let url = InventionStudioApi.siteURL + "feedback/general"

            APIHelper.sendRequest(url: url,
                                  method: .POST,
                                  body: formData,
                                  authHeader: auth,
                                  xApiKeyHeader: InventionStudioApi.apiKey,
                                  completion: { data, response in
                                    //Check for unexpected status codes
                                    if response.statusCode != 200 {
                                        print("statusCode should be 200, but is \(response.statusCode)")
                                        print("response: \(response)")
                                        return
                                    }
                                    //Automatically decode response into a JSON array
                                    let response = try! JSONDecoder().decode(String.self, from: data)
                                    //"Return" the data to the caller's completion handler
                                    completion(response)
            })
        }
    }
}
