//
//  Database.swift
//  reCap
//
//  Created by Jackson Delametter on 2/4/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import Foundation
import Firebase

class FBDatabase {
    
    // MARK: - Constants
    private static let USER_NODE = "User"
    private static let USER_USER_ID = "ID"
    private static let USER_NAME = "Name"
    private static let USER_PICTURES = "Pictures"
    private static let USER_EMAIL = "E-mail"
    private static let EMPTY_VALUE = "Empty"
    
    /*
     Cant Create an instance of FBDatabase,
     only use class functions
    */
    private init() {
        
    }
    
    /*
     Creates a new user into authentication.
     createUser method automatically signs
     new user in.
    */
    class func createUser(ref: DatabaseReference ,email: String, password: String, name: String, with_completion completion: @escaping (_ user: User?, _ error: String?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password, completion: {(user, error) in
            if let userData = user {
                // Sign in successful
                let newUser = User(id: userData.uid, name: name, email: email)
                addUpdateUser(ref: ref, user: newUser)
                completion(newUser, nil)
            }
            else {
                // Sign in not succsessful
                completion(nil, (error?.localizedDescription)!)
            }
        })
    }
    
    /*
     Adds/updates user in the database
    */
    class func addUpdateUser(ref: DatabaseReference ,user: User) {
        let jsonObject: [String : Any] = [USER_USER_ID : user.id, USER_NAME : user.name, USER_PICTURES : user.pictures ?? EMPTY_VALUE, USER_EMAIL : user.email]
        ref.child(USER_NODE).child(user.id).setValue(jsonObject)
    }
    
}
