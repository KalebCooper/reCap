//
//  Picture.swift
//  reCap
//
//  Created by Jackson Delametter on 4/8/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

//
//  PictureData.swift
//  reCap
//
//  Created by Jackson Delametter on 2/4/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//
import Foundation
import RealmSwift
class Picture: Object {
    
    // MARK: - Constants
    static let ORIENTATION_PORTRAIT = 0
    static let ORIENTATION_LANDSCAPE = 1
    static let LONGITUDE_INDEX = 1
    static let LATTITUDE_INDEX = 0
    
    // MARK: - Properties
    var name: String!
    var info: String!
    var id: String!
    var gpsCoordinates: [Double]!
    var orientation: Int!
    var owner = LinkingObjects(fromType: UserData.self, property: "pictures")
    //var owner: String!
    var time: String!
    var locationName: String!
    var isRootPicture: Bool!
    var isMostRecentPicture: Bool!
    var groupID: String!
    
    // MARK: - Initializers
    convenience required init(name: String!, info: String, gpsCoordinates: [Double], orientation: Int, time: String, locationName: String, id: String, isRootPicture: Bool, groupID: String, isMostRecentPicture: Bool) {
        self.init()
        self.name = name
        self.info = info
        self.gpsCoordinates = []
        self.gpsCoordinates = gpsCoordinates
        self.orientation = orientation
        self.time = time
        self.locationName = locationName
        self.id = id
        self.isRootPicture = isRootPicture
        self.groupID = groupID
        self.isMostRecentPicture = isMostRecentPicture
    }
    
    /*
     Returns an id for picture data
     */
    class func createPictureDataID(userData: UserData) -> String {
        var id = UUID().uuidString
        id = id + userData.id
        id = id.replacingOccurrences(of: "-", with: "")
        return id
    }
}

