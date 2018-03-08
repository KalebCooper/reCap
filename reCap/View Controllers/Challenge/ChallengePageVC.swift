//
//  ChallengePageViewContainer.swift
//  reCap
//
//  Created by Jackson Delametter on 3/7/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import UIKit

class ChallengePageVC: UIPageViewController, UIPageViewControllerDelegate {
    
    // MARK: - Properties
    var user: User!
    public static let SHOW_ALL_CHALLENGES = 0
    public static let SHOW_ACCEPTED_CHALLENGE = 1
    private var challengeVCs: [PhotoLibChallengeVC]!

    override func viewDidLoad() {
        super.viewDidLoad()
        if user != nil {
            let allChallengesVC = UIStoryboard(name: "PhotoLibChallenge", bundle: nil).instantiateInitialViewController() as! PhotoLibChallengeVC
            let acceptedVC = UIStoryboard(name: "PhotoLibChallenge", bundle: nil).instantiateInitialViewController() as! PhotoLibChallengeVC
            allChallengesVC.mode = PhotoLibChallengeVC.CHALLENGE_MODE
            acceptedVC.mode = PhotoLibChallengeVC.PHOTO_LIB_MODE
            allChallengesVC.user = self.user
            acceptedVC.user = self.user
            allChallengesVC.tableView.contentInset = UIEdgeInsets.zero
            challengeVCs = [allChallengesVC, acceptedVC]
            self.setViewControllers([challengeVCs[ChallengePageVC.SHOW_ALL_CHALLENGES]], direction: .forward, animated: false, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func switchChallengeView(vcIndex: Int) {
        if vcIndex == ChallengePageVC.SHOW_ALL_CHALLENGES {
            self.setViewControllers([challengeVCs[vcIndex]], direction: .reverse, animated: true, completion: nil)
        }
        else if vcIndex == ChallengePageVC.SHOW_ACCEPTED_CHALLENGE {
            self.setViewControllers([challengeVCs[vcIndex]], direction: .forward, animated: true, completion: nil)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
