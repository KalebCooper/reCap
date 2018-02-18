//
//  SignInVC.swift
//  reCap
//
//  Created by Jackson Delametter on 2/4/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import UIKit
import Firebase
import SkyFloatingLabelTextField

class SignInVC: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var logoOutlet: UIImageView!
    @IBOutlet weak var emailUsernameOutlet: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var passwordOutlet: SkyFloatingLabelTextFieldWithIcon!
    
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
        textFieldSetup()
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
    
    func textFieldSetup() {
        self.hideKeyboard()
        
        emailUsernameOutlet.delegate = self
        emailUsernameOutlet.tag = 0
        passwordOutlet.delegate = self
        passwordOutlet.tag = 1
        
        
    }
    
    func setupHero() {
        let duration: TimeInterval = TimeInterval(exactly: 0.5)!
        logoOutlet.hero.modifiers = [.forceNonFade, .duration(duration)]
        
        emailUsernameOutlet.hero.modifiers = [.duration(duration), .useScaleBasedSizeChange]
        
        passwordOutlet.hero.modifiers = [.duration(duration), .useScaleBasedSizeChange]
    }
    
    
    
    // MARK: - Outlet Actions
    
    /*
     Called when the normal sign in button
     is pressed
     */
    @IBAction func loginInPressed(_ sender: Any) {
        if let emailUsername = emailUsernameOutlet.text, let password = passwordOutlet.text {
            // If fields are filled out
            FBDatabase.signInUser(email: emailUsername, password: password, with_completion: {(id, error) in
                if id != nil {
                    print("Got user id in sign in VC")
                    FBDatabase.setAutomaticSignIn(with_email: emailUsername, with_password: password, with_id: id!)
                    // Segues to page view
                    self.performSegue(withIdentifier: "LogInSegue", sender: self)
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
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        
        if passwordOutlet.isEditing {
            
            if !(emailUsernameOutlet.text?.contains("@"))! {
                
                print("Test")
                //emailUsernameOutlet.hasErrorMessage = true
                emailUsernameOutlet.errorMessage = "Invalid E-mail"
            }
            
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == passwordOutlet {
            if !(emailUsernameOutlet.text?.contains("@"))! || ((emailUsernameOutlet.text?.count)! < 7) {
                //emailUsernameOutlet.hasErrorMessage = true
                emailUsernameOutlet.errorMessage = "Invalid E-mail"
            }
            else {
                emailUsernameOutlet.errorMessage = ""
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? SkyFloatingLabelTextFieldWithIcon {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
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


