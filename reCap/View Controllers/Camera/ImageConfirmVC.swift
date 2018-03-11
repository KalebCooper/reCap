//
//  ImageConfirmVC.swift
//  reCap
//
//  Created by Kaleb Cooper on 2/12/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import UIKit
import Hero

class ImageConfirmVC: UIViewController {
    
    var image: UIImage?
    var latToPass:  Double?
    var longToPass: Double?
    var locationToPass: String?
    var isAtChallengeLocation: Bool!
    var user: User!

    @IBOutlet weak var imageView: UIImageView!
    @IBAction func cancelButton(_ sender: Any) {
        self.navigationController?.setToolbarHidden(true, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let duration: TimeInterval = TimeInterval(exactly: 1.0)!
        imageView.hero.modifiers = [.forceNonFade, .duration(duration)]
        self.navigationController?.toolbar.barStyle = .blackTranslucent
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        imageView.image = image
        self.navigationController?.setToolbarHidden(false, animated: true)

    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        let when = DispatchTime.now() + 0.15 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            if UIDevice.current.orientation == .portrait {
            }
            else if UIDevice.current.orientation == .landscapeLeft {
            }
            else if UIDevice.current.orientation == .landscapeRight {
            }
            
            
        }
        
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller. createPictureSegue
        
        if segue.identifier == "createPictureSegue" {
            let vc = segue.destination as! ImageCreateVC
            vc.isAtChallengeLocation = self.isAtChallengeLocation
            vc.image = self.image
            vc.lat = self.latToPass
            vc.long = self.longToPass
            vc.location = self.locationToPass
            vc.user = self.user
        }
    }
 

}
