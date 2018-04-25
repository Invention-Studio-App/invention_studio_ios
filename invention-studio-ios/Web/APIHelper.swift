//
//  API.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 4/2/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import Foundation

class APIHelper {

    enum HTTPMethod: String {
        case GET = "GET"
        case POST = "POST"
    }

    static func encodeBasicAuth(username: String, password: String) -> String {
        let loginString = username + ":" + password;
        let loginData = loginString.data(using: String.Encoding.utf8)!.base64EncodedString()
        return "Basic \(loginData)"
    }

    static func sendRequest(url: String,
                             method: HTTPMethod,
                             body: Data?,
                             authHeader: String?,
                             xApiKeyHeader: String?,
                             completion: @escaping (Data?, HTTPURLResponse?, Error?) -> ()) {

        //Construct request
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method.rawValue
        request.setValue("application/JSON", forHTTPHeaderField: "Content-Type")

        //Ad optional body
        if body != nil {
            request.httpBody = body!
        }

        //Add optional headers
        if authHeader != nil {
            request.setValue(authHeader!, forHTTPHeaderField: "Authorization")
        }
        if xApiKeyHeader != nil {
            request.setValue(xApiKeyHeader!, forHTTPHeaderField: "x-api-key")
        }

        //Execute the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            //Check for errors
            guard let data = data, error == nil else {
                print("Error: \(error!)")
                completion(nil, response as! HTTPURLResponse?, error)
                return
            }

            //"Return" the data to the caller's completion handler
            completion(data, response as! HTTPURLResponse, nil)

        }.resume()
    }
}
