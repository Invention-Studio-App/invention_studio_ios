//
//  Cookie.swift
//  invention-studio-ios
//
//  Created by Noah Sutter on 2/5/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import Foundation
import WebKit

class SUMSCookie {
    let storage = WKWebsiteDataStore.default()
    var cookieStore:WKHTTPCookieStore!
    var hasCookie = false
}
