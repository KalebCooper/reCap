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
    var pictures: [String]?
    var email: String!
    
    // MARK: - Initializers
    public init(id: String, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }
    
}
