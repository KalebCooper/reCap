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
    private static let USER_POINTS = "Points"
    private static let USER_USERNAME = "Username"
    private static let PROFILE_PICTURE_NODE = "Profile Picture"
    
    private static let EMPTY_VALUE = "Empty"
    
    private static let PICTURE_DATA_NAME = "Name"
    private static let PICTURE_DATA_GPS = "Coordinates"
    private static let PICTURE_DATA_ORIENTATION = "Orientation"
    private static let PICTURE_DATA_OWNER = "Owner"
    private static let PICTURE_DATA_TIME = "Time"
    private static let PICTURE_DATA_LOCATION_NAME = "Location"
    private static let PICTURE_DATA_NODE = "Picture Data"
    private static let PICTURE_DATA_ID = "id"
    private static let PICTURE_NODE = "Pictures"
    
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
    class func createUserAuth(email: String, password: String, with_completion completion: @escaping (_ id: String?, _ error: String?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password, completion: {(userData, error) in
            if let activeUserData = userData {
                // Sign in successful
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
    
    /*
     Used to automatically sign user
     into app if previously signed in
    */
    class func setAutomaticSignIn(with_id id: String) {
        UserDefaults.standard.set(id, forKey: LOGGED_IN_ID)
    }
    
    /*
     Removes the automatic sign in
     for user in app
    */
    class func removeAutomaticSignIn() {
        UserDefaults.standard.removeObject(forKey: LOGGED_IN_ID)
    }
    
    // MARK: - User Methods
    
    /*
     Adds/updates user in the database
    */
    class func addUpdateUser(user: User, with_completion completion: @escaping (_ error: String?) -> ()) {
        let ref = Database.database().reference()
        let jsonObject: [String : Any] = [USER_USER_ID : user.id, USER_NAME : user.name, USER_PICTURES : user.pictures, USER_EMAIL : user.email, USER_POINTS : user.points, USER_USERNAME : user.username]
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
                let username = userNode[USER_USERNAME] as! String
                let user: User
                if let realPics = pictures as? [String] {
                    // The user has pictures
                    user = User(id: id, name: name, email: email, username: username, pictures: realPics)
                }
                else {
                    // The user has no pictures
                    user = User(id: id, name: name, email: email, username: username)
                }
                completion(user)
            }
            else {
                // No users in the database
                completion(nil)
            }
        })
    }
    
    // MARK: - Picture Data Methods
    
    /*
     Adds/updates picture data to the database
    */
    
    class func addUpdatePictureData(pictureData: PictureData, with_completion completion: @escaping (_ error: String?) -> ()) {
        let jsonObject: [String : Any] = [PICTURE_DATA_NAME : pictureData.name, PICTURE_DATA_GPS : pictureData.gpsCoordinates, PICTURE_DATA_ORIENTATION : pictureData.orientation, PICTURE_DATA_OWNER : pictureData.owner, PICTURE_DATA_TIME : pictureData.time, PICTURE_DATA_LOCATION_NAME : pictureData.locationName]
        let ref = Database.database().reference()
        ref.child(PICTURE_DATA_NODE).child(pictureData.id).setValue(jsonObject, withCompletionBlock: {(error, ref) in
            if let actualError = error {
                // Has error
                completion(actualError.localizedDescription)
            }
            else {
                // No error
                completion(nil)
            }
        })
    }
    
    /*
     Gets picture data from database
    */
    class func getPictureData(id: String, ref: DatabaseReference, with_completion completion: @escaping (_ pictureData: PictureData?) -> ()) {
        ref.observe(.value, with: {(snapshot) in
            let root = snapshot.value as! NSDictionary
            if let pictureDataNode = root[PICTURE_DATA_NODE] as? NSDictionary {
                // Database has picture data in it
                let pictureDataData = pictureDataNode[id] as! NSDictionary
                let name = pictureDataData[PICTURE_DATA_NAME] as! String
                let coordinates = pictureDataData[PICTURE_DATA_GPS] as! [Double]
                let orientation = pictureDataData[PICTURE_DATA_ORIENTATION] as! Int
                let owner = pictureDataData[PICTURE_DATA_OWNER] as! String
                let time = pictureDataData[PICTURE_DATA_TIME] as! String
                let locationName = pictureDataData[PICTURE_DATA_LOCATION_NAME] as! String
                let id = pictureDataData[PICTURE_DATA_ID] as! String
                let pictureData = PictureData(name: name, gpsCoordinates: coordinates, orientation: orientation, owner: owner, time: time, locationName: locationName, id: id)
                completion(pictureData)
            }
            else {
                // Database does not have picture data in it
                completion(nil)
            }
        })
    }
    
    // MARK: - Storage Methods
    
    /*
     Puts a profile image in the database
    */
    class func addProfilePicture(with_image image: UIImage, for_user user: User, with_completion completion: @escaping (_ error: String?) -> ()) {
        let storageRef = Storage.storage().reference(forURL: "gs://recap-78bda.appspot.com").child(PROFILE_PICTURE_NODE).child(user.id)
        savePicture(storageRef: storageRef, image: image, completion: completion)
    }
    
    /*
     Puts a picture in the database
    */
    class func addPicture(image: UIImage, pictureData: PictureData, with_completion completion: @escaping (_ error: String?) -> ()) {
        let storageRef = Storage.storage().reference(forURL: "gs://recap-78bda.appspot.com").child(PICTURE_NODE).child(pictureData.id)
        savePicture(storageRef: storageRef, image: image, completion: completion)
    }
    
    /*
     Saves the given image in the database
    */
    private class func savePicture(storageRef: StorageReference, image: UIImage, completion: @escaping (_ error: String?) -> ()) {
        if let imageData = UIImageJPEGRepresentation(image, 0.2) {
            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    // Image was not written to database
                    completion(error?.localizedDescription)
                }
                else {
                    // Image was written to database
                    completion(nil)
                }
            })
        }
    }
    
    /*
     Get picture from database
    */
    class func getPicture(pictureData: PictureData, with_progress progress: @escaping (_ progress: Int64, _ total: Int64) -> (), with_completion completion: @escaping (_ image: UIImage?) -> ()) {
        let storageRef = Storage.storage().reference(forURL: "gs://recap-78bda.appspot.com").child(PICTURE_NODE).child(pictureData.id)
        
        let downloadTask = storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            if data != nil {
                // Got picture in database
                let pic = UIImage(data: data!)
                completion(pic)
            }
            else {
                // Could not get image in database
                completion(nil)
            }
        }
        downloadTask.observe(.progress, handler: {(snapshot) in
            let currentProgress = snapshot.progress?.completedUnitCount
            let totalCount = snapshot.progress?.totalUnitCount
            if totalCount != 0 {
                progress(currentProgress!, totalCount!)
            }
        })
    }
    
}
