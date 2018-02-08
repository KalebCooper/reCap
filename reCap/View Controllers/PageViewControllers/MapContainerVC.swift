//
//  MapContainerVC.swift
//  reCap
//
//  Created by Kaleb Cooper on 2/4/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import UIKit

class MapContainerVC: UIViewController {
    
    var portraitShadow: EdgeShadowLayer? = nil
    var landscapeShadow: EdgeShadowLayer? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        portraitShadow = EdgeShadowLayer(forView: view, edge: .Top)
        self.view.layer.insertSublayer(portraitShadow!, at: 1)
        // Do any additional setup after loading the view.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
