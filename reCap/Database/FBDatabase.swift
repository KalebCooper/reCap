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
    public static let USER_NODE = "User"
    public static let USER_USER_ID = "ID"
    public static let USER_NAME = "Name"
    public static let USER_PICTURES = "Pictures"
    public static let USER_EMAIL = "E-mail"
    public static let USER_POINTS = "Points"
    public static let USER_USERNAME = "Username"
    public static let USER_FRIENDS_ID = "Friends ID"
    public static let USER_ACTIVE_CHALLENGE_ID = "Active Challenge ID"
    public static let USER_ACTIVE_CHALLENGE_POINTS = "Active Challenge Points"
    public static let PROFILE_PICTURE_NODE = "Profile Picture"
    
    public static let EMPTY_VALUE = "Empty"
    
    public static let PICTURE_DATA_NAME = "Name"
    public static let PICTURE_DESCRIPTION = "Description"
    public static let PICTURE_DATA_GPS = "Coordinates"
    public static let PICTURE_DATA_ORIENTATION = "Orientation"
    public static let PICTURE_DATA_OWNER = "Owner"
    public static let PICTURE_DATA_TIME = "Time"
    public static let PICTURE_DATA_LOCATION_NAME = "Location"
    public static let PICTURE_DATA_NODE = "Picture Data"
    public static let PICTURE_DATA_ID = "id"
    public static let PICTURE_DATA_IS_MOST_RECENT_PIC = "Is Most Recent Picture"
    
    public static let PICTURE_NODE = "Pictures"
    public static let PICTURE_IS_ROOT = "Root Picture"
    public static let PICTURE_GROUP_ID = "Group ID"
    
    public static let LOGGED_IN_ID = "Logged in ID"
    public static let LOGGED_IN_EMAIL = "Logged in email"
    public static let LOGGED_IN_PASSWORD = "Logged in password"
    
    public static let USERNAME_NODE = "Username"
    public static let USERNAME_EMAIL = "E-mail"
    public static let USERNAME_ID = "ID"
    
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
    
    class func deleteUsername(username: Username, with_completion completion: @escaping (_ error: String?) -> ()) {
        let ref = Database.database().reference()
        ref.child(USERNAME_NODE).child(username.username).setValue(nil, withCompletionBlock: {(error, ref) in
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
                completion(parseUsernameData(with_dictionary: usernameData, username: username))
            }
            else {
                // Could not get root element
                completion(nil)
            }
        })
    }
    
    private class func parseUsernameData(with_dictionary usernameNode: NSDictionary, username: String) -> Username {
        let id = usernameNode[USERNAME_ID] as! String
        let email = usernameNode[USERNAME_EMAIL] as! String
        let usernameObj = Username(username: username, email: email, id: id)
        return usernameObj
    }
    
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
                completion(parseUserData(with_dictionary: userNode))
            }
            else {
                // No users in the database
                completion(nil)
            }
        })
    }
    
    /*
     Gets a user once
    */
    class func getUserOnce(with_id id: String, ref: DatabaseReference, with_completion completion: @escaping (_ user: User?) -> ()) {
        ref.child(USER_NODE).child(id).observeSingleEvent(of: .value, with: {(snapshot) in
            if let userNode = snapshot.value as? NSDictionary {
                completion(parseUserData(with_dictionary: userNode))
            }
            else {
                // No users in the database
                completion(nil)
            }
        })
    }
    
    /*
     Gets all users ordered by given
     child and the maximum number
     of users to fetch
     */
    class func getAllUsers(query_by child: String, with_max_query number: Int, with_ref ref: DatabaseReference, with_completion completion: @escaping (_ users: [User]) -> ()) {
        ref.child(USER_NODE).observe(.value, with: {(snapshot) in
            var userList: [User] = []
            if let usersNode = snapshot.value as? NSDictionary {
                for node in usersNode {
                    let userNode = node.value as! NSDictionary
                    userList.append(parseUserData(with_dictionary: userNode))
                }
            }
            completion(userList)
        })
    }
    
    private class func parseUserData(with_dictionary userNode: NSDictionary) -> User {
        let id = userNode[USER_USER_ID] as! String
        let name = userNode[USER_NAME] as! String
        let email = userNode[USER_EMAIL] as! String
        var pictures = userNode[USER_PICTURES] as? [String]
        var friendsID = userNode[USER_FRIENDS_ID] as? [String]
        let username = userNode[USER_USERNAME] as! String
        let points = userNode[USER_POINTS] as! Int
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
        user = User(id: id, name: name, email: email, username: username, pictures: pictures!, friendsID: friendsID!, activeChallengeID: activeChallengeID!, activeChallengePoints: activeChallengePoints!, points: points)
        return user
    }
    
    // MARK: - Picture Data Methods
    
    /*
     Adds/updates picture data to the database
     */
    

    class func addUpdatePictureData(pictureData: PictureData, with_completion completion: @escaping (_ error: String?) -> ()) {
        let jsonObject: [String : Any] = [PICTURE_DATA_NAME : pictureData.name, PICTURE_DESCRIPTION : pictureData.description, PICTURE_DATA_GPS : pictureData.gpsCoordinates, PICTURE_DATA_ORIENTATION : pictureData.orientation, PICTURE_DATA_OWNER : pictureData.owner, PICTURE_DATA_TIME : pictureData.time, PICTURE_DATA_LOCATION_NAME : pictureData.locationName, PICTURE_DATA_ID : pictureData.id, PICTURE_GROUP_ID : pictureData.groupID, PICTURE_IS_ROOT : pictureData.isRootPicture, PICTURE_DATA_IS_MOST_RECENT_PIC : pictureData.isMostRecentPicture]
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
     
    */
    private class func parsePictureData(from_dictionary pictureDataNode: NSDictionary) ->PictureData {
        let name = pictureDataNode[PICTURE_DATA_NAME] as! String
        let description = pictureDataNode[PICTURE_DESCRIPTION] as! String
        let coordinates = pictureDataNode[PICTURE_DATA_GPS] as! [Double]
        let orientation = pictureDataNode[PICTURE_DATA_ORIENTATION] as! Int
        let owner = pictureDataNode[PICTURE_DATA_OWNER] as! String
        let time = pictureDataNode[PICTURE_DATA_TIME] as! String
        let locationName = pictureDataNode[PICTURE_DATA_LOCATION_NAME] as! String
        let id = pictureDataNode[PICTURE_DATA_ID] as! String
        let groupID = pictureDataNode[PICTURE_GROUP_ID] as! String
        let isRoot = pictureDataNode[PICTURE_IS_ROOT] as! Bool
        let isMostRecentPicture = pictureDataNode[PICTURE_DATA_IS_MOST_RECENT_PIC] as! Bool
        let pictureData = PictureData(name: name, description: description, gpsCoordinates: coordinates, orientation: orientation, owner: owner, time: time, locationName: locationName, id: id, isRootPicture: isRoot, groupID: groupID, isMostRecentPicture: isMostRecentPicture)
        return pictureData
    }
    
    /*
     Gets picture data from database
     */
    class func getPictureData(id: String, ref: DatabaseReference, with_completion completion: @escaping (_ pictureData: PictureData?) -> ()) {
        ref.child(PICTURE_DATA_NODE).child(id).observe(.value, with: {(snapshot) in
            if let pictureDataNode = snapshot.value as? NSDictionary {
                completion(parsePictureData(from_dictionary: pictureDataNode))
            }
            else {
                // Database does not have picture data in it
                completion(nil)
            }
        })
    }
    
    /*
     Gets all picture data with
     the given group id
    */
    class func getPictureData(in_group group: String, ref: DatabaseReference, with_completion completion: @escaping (_ pictureData: [PictureData]) -> ()) {
        var pictureDataList: [PictureData] = []
        ref.child(PICTURE_DATA_NODE).queryOrdered(byChild: PICTURE_GROUP_ID).queryEqual(toValue: group).observe(.value, with: {(snapshot) in
            if let pictureDataNodes = snapshot.value as? NSDictionary {
                for node in pictureDataNodes {
                    let pictureDataNode = node.value as! NSDictionary
                    pictureDataList.append(parsePictureData(from_dictionary: pictureDataNode))
                }
            }
            completion(pictureDataList)
        })
    }
    
    /*
     Gets root picture data
    */
    class func getRootPictureData(ref: DatabaseReference, with_completion completion: @escaping (_ pictureData: [PictureData]) -> ()) {
        var pictureDataList: [PictureData] = []
        ref.child(PICTURE_DATA_NODE).queryOrdered(byChild: PICTURE_IS_ROOT).queryEqual(toValue: true).observe(.value, with: {(snapshot) in
            if let pictureDataNodes = snapshot.value as? NSDictionary {
                for node in pictureDataNodes {
                    let pictureDataNode = node.value as! NSDictionary
                    pictureDataList.append(parsePictureData(from_dictionary: pictureDataNode))
                }
            }
            completion(pictureDataList)
        })
    }
    
    class func getAllPictureData(count: Int? = -1, ref: DatabaseReference, with_completion completion: @escaping (_ pictureDataArray: [PictureData]?) -> ()) {
        ref.child(PICTURE_DATA_NODE).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                var dataArray: [PictureData] = []
                for child in snapshot.children {
                    let realSnapshot = child as! DataSnapshot
                    let key = realSnapshot.key
                    FBDatabase.getPictureData(id: key, ref: ref, with_completion: { (pictureData) in
                        dataArray.append(pictureData!)
                        if dataArray.count == snapshot.childrenCount {
                            completion(dataArray)
                        }
                        else if dataArray.count == count {
                            completion(dataArray)
                        }
                    })
                }
            }
            else {
                completion(nil)
            }
        }
    }
    
    class func getAllMostRecentPictureData(ref: DatabaseReference, with_completion completion: @escaping (_ pictureData: [PictureData]) -> ()) {
        var pictureDataList: [PictureData] = []
        ref.child(PICTURE_DATA_NODE).queryOrdered(byChild: PICTURE_DATA_IS_MOST_RECENT_PIC).queryEqual(toValue: true).observe(.value, with: {(snapshot) in
            if let pictureDataNodes = snapshot.value as? NSDictionary {
                for node in pictureDataNodes {
                    let pictureDataNode = node.value as! NSDictionary
                    pictureDataList.append(parsePictureData(from_dictionary: pictureDataNode))
                }
            }
            completion(pictureDataList)
        })
    }
    
    /*
     Gets all picture data for a user
     */
    class func getPictureData(for_user user: User, ref: DatabaseReference, with_completion completion: @escaping (_ pictureData: [PictureData]) -> ()) {
        ref.child(PICTURE_DATA_NODE).queryOrdered(byChild: PICTURE_DATA_OWNER).queryEqual(toValue: user.id).observe(.value, with: {(snapshot) in
            var pictureDataList: [PictureData] = []
            if let pictureDataNodes = snapshot.value as? NSDictionary {
                // Database has picture data in it
                for node in pictureDataNodes {
                    let pictureDataNode = node.value as! NSDictionary
                    pictureDataList.append(parsePictureData(from_dictionary: pictureDataNode))
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
