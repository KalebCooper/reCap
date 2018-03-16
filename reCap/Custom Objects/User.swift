//
//  User.swift
//  reCap
//
//  Created by Jackson Delametter on 2/4/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import Foundation

class User {
    
    // MARK: - Properties
    var id: String!
    var name: String!
    var username: String!
    var pictures: [String]
    var email: String!
    var points: Int!
    var friendsID: [String]!
    var activeChallengeID: String!
    var activeChallengePoints: String!
    var state: String!
    var country: String!
    
    // MARK: - Initializers
    public init(id: String, name: String, email: String, username: String, pictures: [String] = [], friendsID: [String] = [], activeChallengeID: String = "", activeChallengePoints: String = "", points: Int = 0, state: String, country: String) {
        self.id = id
        self.name = name
        self.email = email
        self.username = username
        self.pictures = pictures
        self.points = points
        self.friendsID = friendsID
        self.activeChallengeID = activeChallengeID
        self.activeChallengePoints = activeChallengePoints
        self.state = state
        self.country = country
    }
}

