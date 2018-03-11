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
    private static let USER_FRIENDS_ID = "Friends ID"
    private static let USER_ACTIVE_CHALLENGE_ID = "Active Challenge ID"
    private static let USER_ACTIVE_CHALLENGE_POINTS = "Active Challenge Points"
    private static let PROFILE_PICTURE_NODE = "Profile Picture"
    
    private static let EMPTY_VALUE = "Empty"
    
    private static let PICTURE_DATA_NAME = "Name"
    private static let PICTURE_DESCRIPTION = "Description"
    private static let PICTURE_DATA_GPS = "Coordinates"
    private static let PICTURE_DATA_ORIENTATION = "Orientation"
    private static let PICTURE_DATA_OWNER = "Owner"
    private static let PICTURE_DATA_TIME = "Time"
    private static let PICTURE_DATA_LOCATION_NAME = "Location"
    private static let PICTURE_DATA_NODE = "Picture Data"
    private static let PICTURE_DATA_ID = "id"
    private static let PICTURE_NODE = "Pictures"
    
    private static let LOGGED_IN_ID = "Logged in ID"
    private static let LOGGED_IN_EMAIL = "Logged in email"
    private static let LOGGED_IN_PASSWORD = "Logged in password"
    
    private static let USERNAME_NODE = "Username"
    private static let USERNAME_EMAIL = "E-mail"
    private static let USERNAME_ID = "ID"
    
    public static let USER_SIGNED_INTO_FIR = 0
    public static let USER_SIGNED_IN_LOCALLY = 1
    public static let USER_NOT_SIGNED_IN = 2
    
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
     Logs out signed in user
     */
    class func signOutUser(with_completion completion: (_ error: String?) -> ()) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        }
        catch {
            completion("Could not sign user out")
        }
    }
    
    /*
     Used to automatically sign user
     into app if previously signed in
     */
    class func setAutomaticSignIn(with_email email: String, with_password password: String, with_id id: String) {
        UserDefaults.standard.set(email, forKey: LOGGED_IN_EMAIL)
        UserDefaults.standard.set(password, forKey: LOGGED_IN_PASSWORD)
        UserDefaults.standard.set(id, forKey: LOGGED_IN_ID)
    }
    
    /*
     Removes the automatic sign in
     for user in app
     */
    class func removeAutomaticSignIn() {
        UserDefaults.standard.removeObject(forKey: LOGGED_IN_EMAIL)
        UserDefaults.standard.removeObject(forKey: LOGGED_IN_PASSWORD)
        UserDefaults.standard.removeObject(forKey: LOGGED_IN_ID)
    }
    
    /*
     Signs in the user set for
     automatic sign in
     */
    class func signInAutomaticUser(with_completion completion: @escaping (_ id: String?, _ error: String?) -> ()) {
        if let email = getAutomaticUserEmail(), let password = getAutomaticUserPassword() {
            // There is a user set to sign in automatically
            signInUser(email: email, password: password, with_completion: completion)
        }
        else {
            // No one is signed in
            completion(nil, "No users are set for automatic login")
        }
    }
    
    /*
     Gets email for automatic
     sign in user
     */
    private class func getAutomaticUserEmail() -> String? {
        return UserDefaults.standard.value(forKey: LOGGED_IN_EMAIL) as? String
    }
    
    /*
     Gets the password for the
     automatic sign in user
     */
    private class func getAutomaticUserPassword() -> String? {
        return UserDefaults.standard.value(forKey: LOGGED_IN_PASSWORD) as? String
    }
    
    /*
     Get signed in users ID
     */
    class func getSignedInUserID() -> String? {
        if let id = UserDefaults.standard.value(forKey: LOGGED_IN_ID) as? String {
            return id
        }
        else {
            return nil
        }
    }
    
    // MARK: - Username Methods
    
    /*
     Add/updates username in database
     */
    class func addUpdateUsername(with_username username: Username, with_completion completion: @escaping (_ error: String?) -> ()) {
        let ref = Database.database().reference()
        let json = [USERNAME_ID : username.id, USERNAME_EMAIL : username.email]
        ref.child(USERNAME_NODE).child(username.username).setValue(json, withCompletionBlock: {(error, ref) in
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
     Gets username from database
     */
    class func getUsername(with_ref ref: DatabaseReference,with_username username: String, with_completion completion : @escaping (_ username: Username?) -> ()) {
        ref.child(USERNAME_NODE).child(username).observe(.value, with: {(snapshot) in
            if let usernameData = snapshot.value as? NSDictionary {
                let id = usernameData[USERNAME_ID] as! String
                let email = usernameData[USERNAME_EMAIL] as! String
                let usernameObj = Username(username: username, email: email, id: id)
                completion(usernameObj)
            }
            else {
                // Could not get root element
                completion(nil)
            }
        })
    }
    
    /*class func getUsername(with_ref ref: DatabaseReference,with_username username: String, with_completion completion : @escaping (_ username: Username?) -> ()) {
        ref.observe(.value, with: {(snapshot) in
            if let root = snapshot.value as? NSDictionary {
                let usernamesNode = root[USERNAME_NODE] as! NSDictionary
                if let usernameData = usernamesNode[username] as? NSDictionary {
                    let id = usernameData[USERNAME_ID] as! String
                    let email = usernameData[USERNAME_EMAIL] as! String
                    let usernameObj = Username(username: username, email: email, id: id)
                    completion(usernameObj)
                }
                else {
                    completion(nil)
                }
            }
            else {
                // Could not get root element
                completion(nil)
            }
        })
    }*/
    
    // MARK: - User Methods
    
    /*
     Adds/updates user in the database
     */
    class func addUpdateUser(user: User, with_completion completion: @escaping (_ error: String?) -> ()) {
        let ref = Database.database().reference()
        let jsonObject: [String : Any] = [USER_USER_ID : user.id, USER_NAME : user.name, USER_PICTURES : user.pictures, USER_EMAIL : user.email, USER_POINTS : user.points, USER_USERNAME : user.username, USER_FRIENDS_ID : user.friendsID, USER_ACTIVE_CHALLENGE_ID : user.activeChallengeID, USER_ACTIVE_CHALLENGE_POINTS : user.activeChallengePoints]
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
        ref.child(USER_NODE).child(id).observe(.value, with: {(snapshot) in
            if let userNode = snapshot.value as? NSDictionary {
                let name = userNode[USER_NAME] as! String
                let email = userNode[USER_EMAIL] as! String
                var pictures = userNode[USER_PICTURES] as? [String]
                var friendsID = userNode[USER_FRIENDS_ID] as? [String]
                let username = userNode[USER_USERNAME] as! String
                var activeChallengeID = userNode[USER_ACTIVE_CHALLENGE_ID] as? String
                var activeChallengePoints = userNode[USER_ACTIVE_CHALLENGE_POINTS] as? String
                let user: User
                if pictures == nil {
                    pictures = []
                }
                if friendsID == nil {
                    friendsID = []
                }
                if activeChallengeID == nil {
                    activeChallengeID = ""
                }
                if activeChallengePoints == nil {
                    activeChallengePoints = ""
                }
                user = User(id: id, name: name, email: email, username: username, pictures: pictures!, friendsID: friendsID!, activeChallengeID: activeChallengeID!, activeChallengePoints: activeChallengePoints!)
                completion(user)
            }
            else {
                // No users in the database
                completion(nil)
            }
        })
    }
    
    /*class func getUser(with_id id: String, ref: DatabaseReference, with_completion completion: @escaping (_ user: User?) -> ()) {
        ref.observe(.value, with: {(snapshot) in
            let root = snapshot.value as! NSDictionary
            if let users = root[USER_NODE] as? NSDictionary {
                // There are users in the database
                let userNode = users[id] as! NSDictionary
                let name = userNode[USER_NAME] as! String
                let email = userNode[USER_EMAIL] as! String
                var pictures = userNode[USER_PICTURES] as? [String]
                var friendsID = userNode[USER_FRIENDS_ID] as? [String]
                let username = userNode[USER_USERNAME] as! String
                var activeChallengeID = userNode[USER_ACTIVE_CHALLENGE_ID] as? String
                var activeChallengePoints = userNode[USER_ACTIVE_CHALLENGE_POINTS] as? String
                let user: User
                if pictures == nil {
                    pictures = []
                }
                if friendsID == nil {
                    friendsID = []
                }
                if activeChallengeID == nil {
                    activeChallengeID = ""
                }
                if activeChallengePoints == nil {
                    activeChallengePoints = ""
                }
                user = User(id: id, name: name, email: email, username: username, pictures: pictures!, friendsID: friendsID!, activeChallengeID: activeChallengeID!, activeChallengePoints: activeChallengePoints!)
                completion(user)
            }
            else {
                // No users in the database
                completion(nil)
            }
        })
    }*/
    
    // MARK: - Picture Data Methods
    
    /*
     Adds/updates picture data to the database
     */
    
    class func addUpdatePictureData(pictureData: PictureData, with_completion completion: @escaping (_ error: String?) -> ()) {
        let jsonObject: [String : Any] = [PICTURE_DATA_NAME : pictureData.name, PICTURE_DESCRIPTION : pictureData.description, PICTURE_DATA_GPS : pictureData.gpsCoordinates, PICTURE_DATA_ORIENTATION : pictureData.orientation, PICTURE_DATA_OWNER : pictureData.owner, PICTURE_DATA_TIME : pictureData.time, PICTURE_DATA_LOCATION_NAME : pictureData.locationName, PICTURE_DATA_ID : pictureData.id]
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
        ref.child(PICTURE_NODE).child(id).observe(.value, with: {(snapshot) in
            if let pictureDataNode = snapshot.value as? NSDictionary {
                let name = pictureDataNode[PICTURE_DATA_NAME] as! String
                let description = pictureDataNode[PICTURE_DESCRIPTION] as! String
                let coordinates = pictureDataNode[PICTURE_DATA_GPS] as! [Double]
                let orientation = pictureDataNode[PICTURE_DATA_ORIENTATION] as! Int
                let owner = pictureDataNode[PICTURE_DATA_OWNER] as! String
                let time = pictureDataNode[PICTURE_DATA_TIME] as! String
                let locationName = pictureDataNode[PICTURE_DATA_LOCATION_NAME] as! String
                let id = pictureDataNode[PICTURE_DATA_ID] as! String
                let pictureData = PictureData(name: name, description: description, gpsCoordinates: coordinates, orientation: orientation, owner: owner, time: time, locationName: locationName, id: id)
                completion(pictureData)
            }
            
            else {
                // Database does not have picture data in it
                completion(nil)
            }
        })
    }
    
    /*class func getPictureData(id: String, ref: DatabaseReference, with_completion completion: @escaping (_ pictureData: PictureData?) -> ()) {
        ref.observe(.value, with: {(snapshot) in
            let root = snapshot.value as! NSDictionary
            if let pictureDataNode = root[PICTURE_DATA_NODE] as? NSDictionary {
                // Database has picture data in it
                if let pictureDataData = pictureDataNode[id] as? NSDictionary {
                    let name = pictureDataData[PICTURE_DATA_NAME] as! String
                    let description = pictureDataData[PICTURE_DESCRIPTION] as! String
                    let coordinates = pictureDataData[PICTURE_DATA_GPS] as! [Double]
                    let orientation = pictureDataData[PICTURE_DATA_ORIENTATION] as! Int
                    let owner = pictureDataData[PICTURE_DATA_OWNER] as! String
                    let time = pictureDataData[PICTURE_DATA_TIME] as! String
                    let locationName = pictureDataData[PICTURE_DATA_LOCATION_NAME] as! String
                    let id = pictureDataData[PICTURE_DATA_ID] as! String
                    let pictureData = PictureData(name: name, description: description, gpsCoordinates: coordinates, orientation: orientation, owner: owner, time: time, locationName: locationName, id: id)
                    completion(pictureData)
                }
                else {
                    completion(nil)
                }
            }
            else {
                // Database does not have picture data in it
                completion(nil)
            }
        })
    }*/
    
    /*
     Gets all picture data for a user
     */
    class func getPictureData(for_user user: User, ref: DatabaseReference, with_completion completion: @escaping (_ pictureData: [PictureData]) -> ()) {
        ref.observe(.value, with: {(snapshot) in
            let root = snapshot.value as! NSDictionary
            var pictureDataList: [PictureData] = []
            if let pictureDataNode = root[PICTURE_DATA_NODE] as? NSDictionary {
                // Database has picture data in it
                let pictureIDs = user.pictures
                for id in pictureIDs {
                    // Gets each picture id
                    let pictureDataData = pictureDataNode[id] as! NSDictionary
                    let name = pictureDataData[PICTURE_DATA_NAME] as! String
                    let description = pictureDataData[PICTURE_DESCRIPTION] as! String
                    let coordinates = pictureDataData[PICTURE_DATA_GPS] as! [Double]
                    let orientation = pictureDataData[PICTURE_DATA_ORIENTATION] as! Int
                    let owner = pictureDataData[PICTURE_DATA_OWNER] as! String
                    let time = pictureDataData[PICTURE_DATA_TIME] as! String
                    let locationName = pictureDataData[PICTURE_DATA_LOCATION_NAME] as! String
                    let id = pictureDataData[PICTURE_DATA_ID] as! String
                    let pictureData = PictureData(name: name, description: description, gpsCoordinates: coordinates, orientation: orientation, owner: owner, time: time, locationName: locationName, id: id)
                    pictureDataList.append(pictureData)
                }
            }
            completion(pictureDataList)
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
        getPictureFromDatabase(storageRef: storageRef, with_progress: progress, with_completion: completion)
    }
    
    /*
     Gets profile picture
     */
    class func getProfilePicture(for_user user: User, with_progress progress: @escaping (_ progress: Int64, _ total: Int64) -> (), with_completion completion: @escaping (_ image: UIImage?) -> ()) {
        let storageRef = Storage.storage().reference(forURL: "gs://recap-78bda.appspot.com").child(PROFILE_PICTURE_NODE).child(user.id)
        getPictureFromDatabase(storageRef: storageRef, with_progress: progress, with_completion: completion)
    }
    
    /*
     Gets picture from DB
     */
    class func getPictureFromDatabase(storageRef: StorageReference, with_progress progress: @escaping (_ progress: Int64, _ total: Int64) -> (), with_completion completion: @escaping (_ image: UIImage?) -> ()) {
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

