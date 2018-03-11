//
//  PageViewController.swift
//  reCap
//
//  Created by Kaleb Cooper on 2/4/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import UIKit
import Pageboy
import Firebase

class PageViewController: PageboyViewController, PageboyViewControllerDataSource {
    
    // MARK: - Properties
    var user: User!
    private var viewControllersArray: [UIViewController]!
    private var mapVC: MapContainerVC!
    private var cameraVC: CameraContainerVC!
    private var leaderboardsVC: LeaderboardsFriendsVC!
    private var ref: DatabaseReference!
    
    /*let viewControllersArray: [UIViewController] = {
        
        let mapStoryboard = UIStoryboard(name: "Map", bundle: Bundle.main)
        let cameraStoryboard = UIStoryboard(name: "Camera", bundle: Bundle.main)
        let leaderboardsStoryboard = UIStoryboard(name: "LeaderboardsFriends", bundle: Bundle.main)
        
        let mapVC = mapStoryboard.instantiateViewController(withIdentifier: "MapContainerVC") as! MapContainerVC
        let cameraVC = cameraStoryboard.instantiateViewController(withIdentifier: "CameraContainerVC") as! CameraContainerVC
        
        let leaderboardsNav = leaderboardsStoryboard.instantiateViewController(withIdentifier: "LeaderboardsFriendsNav") as! UINavigationController
        let leaderboardsVC = leaderboardsNav.topViewController as! LeaderboardsFriendsVC
        leaderboardsVC.mode = LeaderboardsFriendsVC.LEADERBOARD_MODE
        var viewControllers = [UIViewController]()
        viewControllers.append(mapVC)
        viewControllers.append(cameraVC)
        viewControllers.append(leaderboardsVC)
        
        return viewControllers
    }()*/
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if user != nil {
            setupViewControllers()
            setupUserListener()
        }
    }
    
    private func setupViewControllers() {
        let mapStoryboard = UIStoryboard(name: "Map", bundle: Bundle.main)
        let cameraStoryboard = UIStoryboard(name: "Camera", bundle: Bundle.main)
        let leaderboardsStoryboard = UIStoryboard(name: "LeaderboardsFriends", bundle: Bundle.main)
        
        mapVC = mapStoryboard.instantiateViewController(withIdentifier: "MapContainerVC") as! MapContainerVC
        let cameraNav = cameraStoryboard.instantiateViewController(withIdentifier: "CameraNav") as! UINavigationController
        cameraVC = cameraNav.topViewController as! CameraContainerVC
        let leaderboardsNav = leaderboardsStoryboard.instantiateViewController(withIdentifier: "LeaderboardsFriendsNav") as! UINavigationController
        leaderboardsVC = leaderboardsNav.topViewController as! LeaderboardsFriendsVC
        
        mapVC.user = self.user
        cameraVC.user = self.user
        leaderboardsVC.user = self.user
        leaderboardsVC.mode = LeaderboardsFriendsVC.LEADERBOARD_MODE
        self.viewControllersArray = [mapVC, cameraNav, leaderboardsNav]
        self.dataSource = self
    }
    
    private func setupUserListener() {
        ref = Database.database().reference()
        let id = FBDatabase.getSignedInUserID()!
        FBDatabase.getUser(with_id: id, ref: ref, with_completion: {(user) in
            if let activeUser = user {
                print("Got updated user in Page View Controller")
                self.user = user
                self.mapVC.updateViewController(user: activeUser)
                self.cameraVC.updateViewController(user: activeUser)
                self.leaderboardsVC.updateViewController(user: activeUser)
            }
            else {
                print("Did not get update user in Page View Controller")
            }
        })
    }
    
    
    //Pageboy Datasource Functions
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllersArray.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        pageboyViewController.transition = Transition(style: .fade, duration: 1.0)
        return viewControllersArray[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return PageboyViewController.Page.at(index: 1)
    }
    
    

}
