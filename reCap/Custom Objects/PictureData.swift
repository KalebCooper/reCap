//
//  PictureData.swift
//  reCap
//
//  Created by Jackson Delametter on 2/4/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import Foundation

class PictureData {
    
    // MARK: - Constants
    static let ORIENTATION_PORTRAIT = 0
    static let ORIENTATION_LANDSCAPE = 1
    static let LONGITUDE_INDEX = 0
    static let LATTITUDE_INDEX = 1
    
    // MARK: - Properties
    var name: String!
    var id: String!
    var gpsCoordinates: [Double]!
    var orientation: Int!
    var owner: String!
    var time: String!
    var locationName: String!
    
    // MARK: - Initializers
    public init(name: String!, gpsCoordinates: [Double], orientation: Int, owner: String, time: String, locationName: String, id: String) {
        self.name = name
        self.gpsCoordinates = []
        self.gpsCoordinates = gpsCoordinates
        self.orientation = orientation
        self.owner = owner
        self.time = time
        self.locationName = locationName
        self.id = id
    }
    
}
