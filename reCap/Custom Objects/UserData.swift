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
    var pictures = List<Picture>()
    @objc dynamic var email: String!
    var friends = List<UserData>()
    var activeChallengeID: String!
    var activeChallengePoints: Int!
    @objc dynamic var state: String!
    @objc dynamic var country: String!
    
    convenience required init(id: String, name: String, email: String) {
        self.init()
        self.id = id
        self.name = name
        self.email = email
        self.activeChallengeID = ""
        self.activeChallengePoints = 0
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
