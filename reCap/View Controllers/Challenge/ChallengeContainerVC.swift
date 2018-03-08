//
//  ChallengeContainer.swift
//  reCap
//
//  Created by Jackson Delametter on 3/7/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import UIKit

class ChallengeContainerVC: UIViewController {
    
    // MARK: - Properties
    var user: User!
    private var pageVC: ChallengePageVC!
    private static let ALL_CHALLENGES_SEGMENT = 0
    private static let ACTIVE_CHALLENGES_SEGMENT = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Outlet Actions
    
    @IBAction func selectorChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case ChallengeContainerVC.ALL_CHALLENGES_SEGMENT:
            pageVC.switchChallengeView(vcIndex: ChallengePageVC.SHOW_ALL_CHALLENGES)
            break
        case ChallengeContainerVC.ACTIVE_CHALLENGES_SEGMENT:
            pageVC.switchChallengeView(vcIndex: ChallengePageVC.SHOW_ACCEPTED_CHALLENGE)
            break
        default:
            break
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let segueID = segue.identifier
        if segueID == "ChallengePageVCSegue" {
            self.pageVC = segue.destination as! ChallengePageVC
            pageVC.user = self.user
        }
    }
    

}
