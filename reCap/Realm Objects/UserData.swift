//
//  UserData.swift
//  reCap
//
//  Created by Jackson Delametter on 4/8/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import Foundation
import RealmSwift
import Realm
class UserData: Object {
    // MARK: - Properties
    @objc dynamic var id: String!
    @objc dynamic var name: String!
    @objc dynamic var points = 0
    var pictures = List<PictureData>()
    @objc dynamic var email: String!
    var friends = List<UserData>()
    @objc dynamic var activeChallenge: PictureData?
    @objc dynamic var activeChallengePoints = 0
    @objc dynamic var state: String!
    @objc dynamic var country: String!
    @objc dynamic var longitude = 0.0
    @objc dynamic var latitude = 0.0
    
    convenience required init(id: String, name: String, email: String) {
        self.init()
        self.id = id
        self.name = name
        self.email = email
        self.activeChallengePoints = 0
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["email"]
    }
}
