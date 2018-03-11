//
//  MapContainerVC.swift
//  reCap
//
//  Created by Kaleb Cooper on 2/4/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import UIKit
import Firebase

class MapContainerVC: UIViewController {
    
    // MARK: - Properties
    var portraitShadow: EdgeShadowLayer? = nil
    var landscapeShadow: EdgeShadowLayer? = nil
    var user: User!
    private static let CHALLENGE_SEGUE = "ChallengeSegue"

    override func viewDidLoad() {
        super.viewDidLoad()
        if user != nil {
            initializeShadow()
        }
        // Do any additional setup after loading the view.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func initializeShadow() {
        if UIDevice.current.orientation.isLandscape {
            landscapeShadow = EdgeShadowLayer(forView: view, edge: .Top)
            self.view.layer.insertSublayer(landscapeShadow!, at: 1)
        }
        else {
            portraitShadow = EdgeShadowLayer(forView: view, edge: .Top)
            self.view.layer.insertSublayer(portraitShadow!, at: 1)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let when = DispatchTime.now() + 0.15 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            if UIDevice.current.orientation.isLandscape {
                if (self.view.layer.sublayers?.contains(self.portraitShadow!))! {
                    self.portraitShadow?.removeFromSuperlayer()
                }
                self.landscapeShadow = EdgeShadowLayer(forView: self.view, edge: .Top)
                self.view.layer.insertSublayer(self.landscapeShadow!, at: 1)
            }
            else {
                if (self.view.layer.sublayers?.contains(self.landscapeShadow!))! {
                    self.landscapeShadow?.removeFromSuperlayer()
                }
                self.portraitShadow = EdgeShadowLayer(forView: self.view, edge: .Top)
                self.view.layer.insertSublayer(self.portraitShadow!, at: 1)
            }
        }
        
        
    }
    
    // MARK: - Outlet Actions
    
    @IBAction func challengesFixed(_ sender: Any) {
        self.performSegue(withIdentifier: "ChallengeSegue", sender: nil)
    }
    
    // MARK: - Misc.
    public func updateViewController(user: User) {
        self.user = user
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let id = segue.identifier
        if id == MapContainerVC.CHALLENGE_SEGUE {
            let desination = segue.destination as! UINavigationController
            let challengeVC = desination.topViewController as! PhotoLibChallengeVC
            challengeVC.mode = PhotoLibChallengeVC.CHALLENGE_MODE
            challengeVC.user = self.user
        }
        else if id == "MapSegue" {
            let desination = segue.destination as! MapVC
            desination.user = self.user
        }
    }

}
