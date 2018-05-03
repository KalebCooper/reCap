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
    public static let PROFILE_PICTURE_NODE = "Profile Picture"
    public static let EMPTY_VALUE = "Empty"
    public static let PICTURE_NODE = "Pictures"
    private static let imageCache = NSCache<NSString, UIImage>()
    
    /*
     Cant Create an instance of FBDatabase,
     only use class functions
     */
    private init() {
        
    }
    
    // MARK: - Storage Methods
    
    /*
     Puts a profile image in the database
     */
    class func addProfilePicture(with_image image: UIImage, for_user user: UserData, with_completion completion: @escaping (_ error: String?) -> ()) {
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
        if let image = imageCache.object(forKey: pictureData.id! as NSString) {
            completion(image)
        }
        else {
            let storageRef = Storage.storage().reference(forURL: "gs://recap-78bda.appspot.com").child(PICTURE_NODE).child(pictureData.id)
            getPictureFromDatabase(storageRef: storageRef, with_progress: progress, with_completion: completion, key: pictureData.id)
        }
    }
    
    class func getProfilePicture(for_user user: UserData, with_progress progress: @escaping (_ progress: Int64, _ total: Int64) -> (), with_completion completion: @escaping (_ image: UIImage?) -> ()) {
        if let image = imageCache.object(forKey: user.id! as NSString) {
            completion(image)
        }
        else {
            let storageRef = Storage.storage().reference(forURL: "gs://recap-78bda.appspot.com").child(PROFILE_PICTURE_NODE).child(user.id)
            getPictureFromDatabase(storageRef: storageRef, with_progress: progress, with_completion: completion, key: user.id)
        }
    }
    
    class func deletePicture(pictureData: PictureData) {
        let storageRef = Storage.storage().reference(forURL: "gs://recap-78bda.appspot.com").child(PICTURE_NODE).child(pictureData.id)
        storageRef.delete(completion: nil)
    }
    
    /*
     Gets picture from DB
     */
    class func getPictureFromDatabase(storageRef: StorageReference, with_progress progress: @escaping (_ progress: Int64, _ total: Int64) -> (), with_completion completion: @escaping (_ image: UIImage?) -> (), key: String) {
        let downloadTask = storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            if data != nil {
                // Got picture in database
                let pic = UIImage(data: data!)
                imageCache.setObject(pic!, forKey: key as NSString)
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
