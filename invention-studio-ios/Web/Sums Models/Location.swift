//
//  Location.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 2/26/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

struct Location: Hashable {

    var locationId: Int
    var locationAddress: String
    var locationDescription: String
    var locationManager: String
    var locationName: String
    var locationUrl: String

    init(fromTool tool: Tool) {
        locationId = tool.locationId
        locationAddress = tool.locationAddress
        locationDescription = tool.locationDescription
        locationManager = tool.locationManager
        locationName = tool.locationName
        locationUrl = tool.locationUrl
    }

    var hashValue: Int {
        return locationId
    }

    static func ==(lhs: Location, rhs: Location) -> Bool {
        return lhs.locationId == rhs.locationId
    }
}
