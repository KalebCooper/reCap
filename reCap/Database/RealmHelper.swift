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
    
    class func getAllPictureData() -> Results<PictureData> {

        do {
            let realm = try Realm()
            let pictures = realm.objects(PictureData.self)
            return pictures
            
        } catch let error as NSError {
            fatalError(error.localizedDescription)
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


