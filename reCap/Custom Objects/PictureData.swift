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
class PictureData: Object {
    
    // MARK: - Constants
    static let ORIENTATION_PORTRAIT = 0
    static let ORIENTATION_LANDSCAPE = 1
    static let LONGITUDE_INDEX = 1
    static let LATTITUDE_INDEX = 0
    
    // MARK: - Properties
    @objc dynamic var name: String!
    @objc dynamic var info: String!
    @objc dynamic var id: String!
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    @objc dynamic var bearing = 0.0
    @objc dynamic var orientation = PictureData.ORIENTATION_PORTRAIT
    @objc dynamic var owner: UserData!
    @objc dynamic var time = 0
    @objc dynamic var locationName: String!
    @objc dynamic var isRootPicture = true
    @objc dynamic var isMostRecentPicture = true
    @objc dynamic var groupID: String!
    
    // MARK: - Initializers
    convenience required init(name: String!, info: String, owner: UserData, latitude: Double, longitude: Double, orientation: Int, time: Int, locationName: String, id: String, isRootPicture: Bool, groupID: String, isMostRecentPicture: Bool) {
        self.init()
        self.name = name
        self.info = info
        self.orientation = orientation
        self.latitude = latitude
        self.longitude = longitude
        self.time = time
        self.owner = owner
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
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["groupID", "isRootPicture", "isMostRecentPicture"]
    }
}

