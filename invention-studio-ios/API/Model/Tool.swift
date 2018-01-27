//
//  Tool.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 1/26/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import Foundation
import UIKit

class Tool: NSObject {

    enum Status: String {
        case AVAILABLE = "Available"
        case INUSE = "In Use"
        case DOWN = "Down"
        case UNKNOWN = "Unknown"
    }
}
