//
//  LoginVC.swift
//  invention-studio-ios
//
//  Created by Noah Sutter on 1/22/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import UIKit
import WebKit

class LoginVC: UIViewController, WKUIDelegate, WKNavigationDelegate, WKHTTPCookieStoreObserver {
    
    
    // VARIABLE DECLARATIONS
    //The Web View
    var webView: WKWebView!
    //The cookie we will receive once authenticated
    var CAScookie: HTTPCookie!
    //The flag used to know if the cookie has been received (used to know when to segue)
    var cookieReceived = false
    //The storage that will containt the cookies
    let storage = WKWebsiteDataStore.default()
    var cookieStore:WKHTTPCookieStore!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Preparing the request for the login page
        let myURL = URL(string: "https://login.gatech.edu/cas/login?service=https://sums-dev.gatech.edu/EditResearcherProfile.aspx")
        let myRequest = URLRequest(url: myURL!)
        
        //Setting up the cookie store
        cookieStore = storage.httpCookieStore
        cookieStore.add(self)
        
        //Making this class the navigation delegate
        webView.navigationDelegate = self
        
        //Requesting the login page
        webView.load(myRequest)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        //Setting up the webview
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }


    //This function is called when navigation is finished
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Navigation Finished")
        if self.cookieReceived {
            //Navigation has finished and we have the cookie:
            print("Authenticated")
            var userKey = ""
            webView.evaluateJavaScript("document.body.innerHTML", completionHandler: { (result, err) in
                let userInfoPage = result as! String
                let calendarLink = "https://sums.gatech.edu/SUMS/rest/iCalendar/ReturnData?Key="
                print(userInfoPage)
                if let linkRange = userInfoPage.range(of: calendarLink) {
                    let keyLowerBound = String.Index(encodedOffset: linkRange.upperBound.encodedOffset)
                    let keyUpperBound = String.Index(encodedOffset: keyLowerBound.encodedOffset + 20)
                    userKey = String(userInfoPage[keyLowerBound..<keyUpperBound])

                    print("User Key: \(userKey)")
                }
            })
            
            //TODO: Implement a check to see if the person is part of the Invention Studio group
            //      before performing the segue. If they have not, perform a different segue
            self.performSegue(withIdentifier: "cookieReceivedSegue", sender: self)
        }
    }
    
    //This function is called whenever there are changes to the cookie store
    func cookiesDidChange(in cookieStore:WKHTTPCookieStore) {
        cookieStore.getAllCookies({ (cookies) in
            for index in 0..<cookies.count {
                //Checking for the CAS cookie
                if cookies[index].name == "CASTGT" {
                    //Checking if the CAS cookie has changed
                    if cookies[index] != self.CAScookie {
                        print("CAS cookie  obtained")
                        //Updating our stored cookie and setting the cookie flag to true
                        self.CAScookie = cookies[index]
                        self.cookieReceived = true
                    }
                }
            }
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cookieReceivedSegue" {
            UserDefaults.standard.set(true, forKey: "LoggedIn")
            let weekInterval: TimeInterval = 60 * 60 * 24 * 7
            //TODO: Use server time
            UserDefaults.standard.set(NSDate().addingTimeInterval(weekInterval).timeIntervalSince1970, forKey:"LoginSession")
        }
    }

}


