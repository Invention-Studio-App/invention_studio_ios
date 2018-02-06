//
//  ApiManager.swift
//  invention-studio-ios
//
//  Created by Noah Sutter on 2/5/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import UIKit
import WebKit

class ApiManager {
    
    func fetch_user_info() {
        let storage = WKWebsiteDataStore.default()
        let cookieStore = storage.httpCookieStore
        cookieStore.getAllCookies({ (cookie:[HTTPCookie]) in
            print(cookie.description)
        })
        let url = URL(string: "https://sums.gatech.edu/Dashboard.aspx")!
        var request = URLRequest(url: url)
        request.httpShouldHandleCookies = true
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
            print(String(data: data, encoding: .utf8))
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            print(json)
        }
        task.resume()
        
        /*
        //let url = URL(string: "https://sums.gatech.edu/SUMSAPI/rest/API/user_info?userName=nsutter3")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.setValue("ZLJJQOZYZ0JZDP3293HC", forHTTPHeaderField: "authorization")
        //let postString = ""
        //request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
            
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            print(json)
        }
        task.resume()
 */
    }
}
