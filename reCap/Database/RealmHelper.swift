//
//  RealmHelper.swift
//  reCap
//
//  Created by Kaleb Cooper on 4/21/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

public class RealmHelper {
    
    
    //-------------------------------------------------------------------------------------------------------------------------
    //MARK:- PictureData Functions
    //-------------------------------------------------------------------------------------------------------------------------
    
    class func getAllPictureData(onlyRecent: Bool) -> Results<PictureData> {

        do {
            let realm = try Realm()
            var pictures: Results<PictureData>!
            
            if onlyRecent == true {
                pictures = realm.objects(PictureData.self).filter("isMostRecentPicture == %@", true)
            }
            else {
                pictures = realm.objects(PictureData.self)
            }
            
            return pictures
            
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
    
    class func getPictureData(withLat lat: Double, withLong long: Double, onlyRecent: Bool = false) -> PictureData? {
        
        let allPictureData = getAllPictureData(onlyRecent: onlyRecent)
        let matchingPictureData = allPictureData.filter("latitude == %@ AND longitude == %@ AND isMostRecentPicture == %@", lat, long, true)

        if matchingPictureData.count == 1 {
            return matchingPictureData.first
        }
        else {
            return nil
        }
    }
    
    
    
    //-------------------------------------------------------------------------------------------------------------------------
    //MARK:- User Functions
    //-------------------------------------------------------------------------------------------------------------------------
    
    class func getUser() -> UserData {
        do {
            let realm = try Realm()
            let user = realm.objects(UserData.self).first!
            return user
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
}


