//
//  SignInVC.swift
//  reCap
//
//  Created by Jackson Delametter on 2/4/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import UIKit
import Firebase

class SignInVC: UIViewController {
    
    // MARK: - Outlets
   
    
    @IBOutlet weak var emailUsernameOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    
    // MARK: - Properties
    var gradientLayer: CAGradientLayer!
    
    // MARK: - View Controller Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        //createUser()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Setup Methods
    
    private func setup() {
        createGradientLayer()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.bounds
        
        let bottomColor = UIColor(displayP3Red: 99/255, green: 207/255, blue: 155/255, alpha: 1).cgColor
        let topColor = UIColor(displayP3Red: 9/255, green: 85/255, blue: 95/255, alpha: 1).cgColor
        
        gradientLayer.colors = [topColor, bottomColor]
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - Outlet Actions
    
    /*
     Called when the user taps the screen
    */
    @IBAction func screenTapped(_ sender: UITapGestureRecognizer) {
        // Removes keyboard
        self.view.endEditing(true)
    }
    
    /*
     Called when the normal sign in button
     is pressed
    */
    @IBAction func loginInPressed(_ sender: Any) {
        if let emailUsername = emailUsernameOutlet.text, let password = passwordOutlet.text {
            // If fields are filled out
            FBDatabase.signInUser(email: emailUsername, password: password, with_completion: {(id, error) in
                if let activeId = id {
                    print("Got user id in sign in VC")
                    FBDatabase.setAutomaticSignIn(with_id: activeId)
                    // Segues to page view
                }
                else {
                    print("Did not get user id in sign in VC")
                    print(error!)
                }
            })
        }
        else {
            // Not all fields are filled out
            print("All Fields are not filled out")
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
