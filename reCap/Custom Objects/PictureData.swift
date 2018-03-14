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
    static let LONGITUDE_INDEX = 1
    static let LATTITUDE_INDEX = 0
    
    // MARK: - Properties
    var name: String!
    var description: String!
    var id: String!
    var gpsCoordinates: [Double]!
    var orientation: Int!
    var owner: String!
    var time: String!
    var locationName: String!
    var isRootPicture: Bool!
    var groupID: String!
    
    // MARK: - Initializers
    public init(name: String!, description: String, gpsCoordinates: [Double], orientation: Int, owner: String, time: String, locationName: String, id: String, isRootPicture: Bool, groupID: String) {
        self.name = name
        self.description = description
        self.gpsCoordinates = []
        self.gpsCoordinates = gpsCoordinates
        self.orientation = orientation
        self.owner = owner
        self.time = time
        self.locationName = locationName
        self.id = id
        self.isRootPicture = isRootPicture
        self.groupID = groupID
    }
    
    /*
     Returns an id for picture data
     */
    class func createPictureDataID() -> String {
        var id = UUID().uuidString
        id = id.replacingOccurrences(of: "-", with: "")
        return id
    }
}
