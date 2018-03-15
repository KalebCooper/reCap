//
//  SortUsers.swift
//  reCap
//
//  Created by Jackson Delametter on 3/14/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import Foundation

class Sort {
    
    class func SortUsersByDescendingOrder(users: [User]) -> [User] {
        print("Before sort")
        for user in users {
            print("\(user.points), ")
        }
        var usersArray = users
        var currentIndex = 0
        while(true) {
            if (currentIndex + 1) > users.count-1 {
                break
            }
            let currentUser = usersArray[currentIndex]
            let nextUser = usersArray[currentIndex + 1]
            if currentUser.points < nextUser.points {
                // Current index needs to be sorted, loop back through
                usersArray[currentIndex] = nextUser
                usersArray[currentIndex + 1] = currentUser
                currentIndex = 0
            }
            else {
                // The current index is sorted, go to the next
                currentIndex = currentIndex + 1
            }
        }
        print("After Sort")
        for user in usersArray {
            print("\(user.points), ")
        }
        return usersArray
    }
}
