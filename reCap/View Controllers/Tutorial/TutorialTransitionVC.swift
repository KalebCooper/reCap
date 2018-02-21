//
//  TutorialTransitionVC.swift
//  reCap
//
//  Created by Kaleb Cooper on 2/18/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import UIKit

class TutorialTransitionVC: UIPageViewController {
    
    @IBOutlet weak var logoOutlet: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            
            self.performSegue(withIdentifier: "forward", sender: self)
            
        })
        // Do any additional setup after loading the view.
    }
    

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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


