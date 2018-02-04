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
    
    private static let LOGGED_IN_ID = "Logged in id"
    /*
     Cant Create an instance of FBDatabase,
     only use class functions
    */
    private init() {
        
    }
    
    // MARK: - Create User and Login User Methods
    
    /*
     Creates a new user into authentication.
     createUser method automatically signs
     new user in. Returns users id and error in
     completion handler
    */
    class func createUserAuth(email: String, password: String, name: String, with_completion completion: @escaping (_ id: String?, _ error: String?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password, completion: {(userData, error) in
            if let activeUserData = userData {
                // Sign in successful
                UserDefaults.standard.set(activeUserData.uid, forKey: LOGGED_IN_ID)
                completion(activeUserData.uid, nil)
            }
            else {
                // Sign in not succsessful
                completion(nil, (error?.localizedDescription)!)
            }
        })
    }
    
    /*
     Signs in a user and returns user
     id in completion handler
    */
    class func signInUser(email: String, password: String, with_completion completion: @escaping (_ id: String?, _ error: String?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password, completion: {(userData, error) in
            if let activeUserData = userData {
                // Sign in succsesful
                completion(activeUserData.uid, nil)
            }
            else {
                // Sign in not succsesful
                completion(nil, error?.localizedDescription)
            }
        })
    }
    
    // MARK: - User Methods
    
    /*
     Adds/updates user in the database
    */
    class func addUpdateUser(user: User, with_completion completion: @escaping (_ error: String?) -> ()) {
        let ref = Database.database().reference()
        let jsonObject: [String : Any] = [USER_USER_ID : user.id, USER_NAME : user.name, USER_PICTURES : user.pictures, USER_EMAIL : user.email]
        ref.child(USER_NODE).child(user.id).setValue(jsonObject, withCompletionBlock: {(error, ref) in
            if let realError = error {
                // Error occured
                completion(realError.localizedDescription)
            }
            else {
                // No error occured
                completion(nil)
            }
        })
    }
    
    /*
     Gets a user from the database
     with the given ID, returns the
     user in the completion handler
    */
    class func getUser(with_id id: String, ref: DatabaseReference, with_completion completion: @escaping (_ user: User?) -> ()) {
        ref.observe(.value, with: {(snapshot) in
            let root = snapshot.value as! NSDictionary
            if let users = root[USER_NODE] as? NSDictionary {
                // There are users in the database
                let userNode = users[id] as! NSDictionary
                let name = userNode[USER_NAME] as! String
                let email = userNode[USER_EMAIL] as! String
                let pictures = userNode[USER_PICTURES]
                let user: User
                if let realPics = pictures as? [String] {
                    // The user has pictures
                    user = User(id: id, name: name, email: email, pictures: realPics)
                }
                else {
                    // The user has no pictures
                    user = User(id: id, name: name, email: email)
                }
                completion(user)
            }
            else {
                // No users in the database
                completion(nil)
            }
        })
    }
    
}
