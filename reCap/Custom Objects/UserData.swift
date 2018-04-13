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
    @objc dynamic var username: String!
    @objc dynamic var points = 0
    //var pictures: [String]
    //var pictures = List<Picture>()
    //var email: String!
    //var friendsID: [String]!
    //var friends = List<UserData>()
    //var activeChallengeID: String!
    //var activeChallengePoints: String!
    //var state: String!
    //var country: String!
    
    convenience required init(id: String, name: String, username: String) {
        self.init()
        self.id = id
        self.name = name
        self.username = username
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
