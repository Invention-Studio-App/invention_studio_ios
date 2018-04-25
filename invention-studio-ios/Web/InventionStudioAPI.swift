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
                                  completion: { data, response, error in
                                    if error != nil {
                                        completion("Error:An unknown error occurred. Please try again later.")
                                        return
                                    }

                                    //Check for unexpected status codes
                                    var message = ""
                                    if response!.statusCode != 200 {
                                        print("statusCode should be 200, but is \(response!.statusCode)")
                                        print("response: \(response!)")
                                        if response!.statusCode == 400 {
                                            message = "Login Error:There was an error logging in. Please try again later."
                                        } else if response!.statusCode == 500 {
                                            message = "Login Error:Internal Server Error. Please try again later."
                                        } else {
                                            message = "Error:An unknown error occurred"
                                        }
                                    } else {
                                        //Automatically decode response into a JSON array
                                        let body = String(data: data!, encoding: .utf8)!
                                        message = "Success:\(body)"
                                    }
                                    //"Return" the data to the caller's completion handler
                                    completion(message)
            })
        }
    }

    //Server module
    class Server {

        //app_status request
        //Status message to be processed on app startup. Useful for conveying important information about app updates.
        static func app_status(completion: @escaping (StatusMessage?) -> ()) {
            let url = InventionStudioApi.siteURL + "server/app_status"

            APIHelper.sendRequest(url: url,
                                  method: .GET,
                                  body: nil,
                                  authHeader: nil,
                                  xApiKeyHeader: InventionStudioApi.apiKey,
                                  completion: { data, response, error in
                                    if error != nil {
                                        completion(nil)
                                        return
                                    }

                                    //Check for unexpected status codes
                                    if response!.statusCode != 200 && response!.statusCode != 204 {
                                        print("statusCode should be 200 or 204, but is \(response!.statusCode)")
                                        print("response: \(response!)")
                                        return
                                    }
                                    var responseBody: StatusMessage?
                                    if response!.statusCode == 200 {
                                        //Automatically decode response into a JSON array
                                        responseBody = try? JSONDecoder().decode(StatusMessage.self, from: data!)
                                    } else {
                                        responseBody = nil
                                    }
                                    //"Return" the data to the caller's completion handler
                                    completion(responseBody)
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
                                  completion: { data, response, error in
                                    if error != nil {
                                        completion(0)
                                        return
                                    }

                                    //Check for unexpected status codes
                                    if response!.statusCode != 200 {
                                        print("statusCode should be 200, but is \(response!.statusCode)")
                                        print("response: \(response!)")
                                        return
                                    }
                                    //Automatically decode response into a JSON array
                                    let body = Int(String(data: data!, encoding: .utf8)!)!
                                    //"Return" the data to the caller's completion handler
                                    completion(body)
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
                                  completion: { data, response, error in
                                    if error != nil {
                                        completion("Error:An unknown error occurred. Please try again later.")
                                        return
                                    }

                                    //Check for unexpected status codes
                                    var message = ""
                                    if response!.statusCode != 200 {
                                        print("statusCode should be 200, but is \(response!.statusCode)")
                                        print("response: \(response!)")
                                        if response!.statusCode == 400 {
                                            message = "Error:There was an error submitting  your feedback. Please try again later."
                                        } else if response!.statusCode == 500 {
                                            message = "Error:Internal Server Error. Please try again later."
                                        } else {
                                            message = "Error:An unknown error occurred. Please try again later."
                                        }
                                    } else {
                                        //Automatically decode response into a JSON array
                                        let body = String(data: data!, encoding: .utf8)!
                                        message = "Success:\(body)"
                                    }
                                    //"Return" the data to the caller's completion handler
                                    completion(message)
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
                                  completion: { data, response, error in
                                    if error != nil {
                                        completion("Error:An unknown error occurred. Please try again later.")
                                        return
                                    }

                                    //Check for unexpected status codes
                                    var message = ""
                                    if response!.statusCode != 200 {
                                        print("statusCode should be 200, but is \(response!.statusCode)")
                                        print("response: \(response!)")
                                        if response!.statusCode == 400 {
                                            message = "Error:There was an error submitting your feedback. Please try again later."
                                        } else if response!.statusCode == 500 {
                                            message = "Error:Internal Server Error. Please try again later."
                                        } else {
                                            message = "Error:An unknown error occurred. Please try again later."
                                        }
                                    } else {
                                        //Automatically decode response into a JSON array
                                        let body = String(data: data!, encoding: .utf8)!
                                        message = "Success:\(body)"
                                    }
                                    //"Return" the data to the caller's completion handler
                                    completion(message)
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
                                  completion: { data, response, error in
                                    if error != nil {
                                        completion("Error:An unknown error occurred. Please try again later.")
                                        return
                                    }

                                    //Check for unexpected status codes
                                    var message = ""
                                    if response!.statusCode != 200 {
                                        print("statusCode should be 200, but is \(response!.statusCode)")
                                        print("response: \(response!)")
                                        if response!.statusCode == 400 {
                                            message = "Error:There was an error submitting your feedback. Please try again later."
                                        } else if response!.statusCode == 500 {
                                            message = "Error:Internal Server Error. Please try again later."
                                        } else {
                                            message = "Error:An unknown error occurred. Please try again later."
                                        }
                                    } else {
                                        //Automatically decode response into a JSON array
                                        let body = String(data: data!, encoding: .utf8)!
                                        message = "Success:\(body)"
                                    }
                                    //"Return" the data to the caller's completion handler
                                    completion(message)
            })
        }
    }
}
