//
//  PageViewController.swift
//  reCap
//
//  Created by Kaleb Cooper on 2/4/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import UIKit
import Pageboy

class PageViewController: PageboyViewController, PageboyViewControllerDataSource {
    
    
    
    let viewControllersArray: [UIViewController] = {
        
        let mapStoryboard = UIStoryboard(name: "Map", bundle: Bundle.main)
        let cameraStoryboard = UIStoryboard(name: "Camera", bundle: Bundle.main)
        let leaderboardsStoryboard = UIStoryboard(name: "Leaderboards", bundle: Bundle.main)
        
        let mapVC = mapStoryboard.instantiateViewController(withIdentifier: "MapContainerVC") as! MapContainerVC
        let cameraVC = cameraStoryboard.instantiateViewController(withIdentifier: "CameraContainerVC") as! CameraContainerVC
        let leaderboardsVC = leaderboardsStoryboard.instantiateViewController(withIdentifier: "LeaderboardContainerVC") as! LeaderboardContainerVC
        
        var viewControllers = [UIViewController]()
        viewControllers.append(mapVC)
        viewControllers.append(cameraVC)
        viewControllers.append(leaderboardsVC)
        
        
        
        return viewControllers
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        // Do any additional setup after loading the view.
    }

    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllersArray.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllersArray[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return PageboyViewController.Page.at(index: 1)
    }

}
