//
//  Username.swift
//  reCap
//
//  Created by Jackson Delametter on 2/17/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import Foundation

class Username {
    
    // MARK: - properties
    var email: String
    var username: String!
    
    init(username: String, email: String) {
        self.username = username
        self.email = email
    }
}