//
//  LogInViewController.swift
//  invention-studio-ios
//
//  Created by Noah Sutter on 1/22/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//


import UIKit
import WebKit

class LogInViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, WKHTTPCookieStoreObserver {
    var webView: WKWebView!
    var dataStore: WKWebsiteDataStore!
    let storage = WKWebsiteDataStore.default()
    
    var cookieStore:WKHTTPCookieStore!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let myURL = URL(string: "https://login.gatech.edu/cas/login")
        let myRequest = URLRequest(url: myURL!)
        cookieStore = storage.httpCookieStore
        cookieStore.add(self)
        webView.navigationDelegate = self
        webView.load(myRequest)
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }


    func cookiesDidChange(in cookieStore:WKHTTPCookieStore) {
        cookieStore.getAllCookies({ (cookies) in
            for index in 0..<cookies.count {
                if cookies[index].name == "CASTGT" {
                    print("Have CAS cookie")
                }
            }
        })
    }


}


