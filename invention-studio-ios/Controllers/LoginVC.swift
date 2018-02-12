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
        if self.cookieReceived {
            //Navigation has finished and we have the cookie:
            //Static ID names for username and calendar fields
            let usernameDisplayId = "LiverpoolTheme_wt1_block_wtMainContent_SilkUIFramework_wt8_block_wtColumn2_wt14_SilkUIFramework_wt14_block_wtContent1_wt15_SilkUIFramework_wt382_block_wtPanelContent_SilkUIFramework_wt109_block_wtColumn2_SilkUIFramework_wt289_block_wtPanelContent_SilkUIFramework_wtBrief_block_wtContent_wtUsernameDisplay"
            let calendarDisplayId = "LiverpoolTheme_wt1_block_wtMainContent_SilkUIFramework_wt8_block_wtColumn2_wt14_SilkUIFramework_wt14_block_wtContent1_wt15_SilkUIFramework_wt382_block_wtPanelContent_SilkUIFramework_wt109_block_wtColumn2_SilkUIFramework_wt289_block_wtPanelContent_SilkUIFramework_wtBrief_block_wtContent_wtCalendarLink"

            let jsEvalGroup = DispatchGroup() //Create an asynchronus dispatch group

            jsEvalGroup.enter() //Enter the dispatch group to block until completed
            webView.evaluateJavaScript("document.getElementById(\"\(usernameDisplayId)\").innerText", completionHandler: { (result, err) in
                let username = result as! String //Get the results
                UserDefaults.standard.set(username, forKey: "Username") //Save to user defaults
                jsEvalGroup.leave() //Mark action as completed in dispatch group
            });

            jsEvalGroup.enter() //Enter the dispatch group to block until completed
            webView.evaluateJavaScript("document.getElementById(\"\(calendarDisplayId)\").innerText",
            completionHandler: { (result, err) in
                let calendarDisplay = result as! String //Get the results
                let calendarLink = "https://sums.gatech.edu/SUMS/rest/iCalendar/ReturnData?Key=" //Static calendar link to be stripped
                let userKey = calendarDisplay.replacingOccurrences(of: calendarLink, with: "") //Strip the calendar link
                UserDefaults.standard.set(userKey, forKey: "UserKey") //Save to user defaults
                jsEvalGroup.leave() //Mark action as completed in dispatch group
            });

            //When both evaluateJavaScript calls complete, segue out
            jsEvalGroup.notify(queue: .main, execute: {
                self.performSegue(withIdentifier: "cookieReceivedSegue", sender: self)
            })

                //TODO: Implement a check to see if the person is part of the Invention Studio group
                //      before performing the segue. If they have not, perform a different segue
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
