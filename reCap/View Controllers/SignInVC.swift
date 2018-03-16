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
import FCAlertView

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
            if emailUsername.contains("@") {
                // User has entered an email
                loginWithEmail(email: emailUsername, password: password)
            }
            else {
                // User has entered a username
                loginWithUsername(username: emailUsername, password: password)
            }
        }
        else {
            // Not all fields are filled out
            print("All Fields are not filled out")
            displayErrorAlert(message: "All Fields are not filled out")
        }
    }
    
    /*
     Used when user enters username
    */
    private func loginWithUsername(username: String, password: String) {
        let ref = Database.database().reference()
        FBDatabase.getUsername(with_ref: ref, with_username: username, with_completion: {(username) in
            if let usernameObj = username {
                print("Got username in Sign In VC")
                let email = usernameObj.email
                self.loginWithEmail(email: email, password: password)
            }
            else {
                print("Didnt get username in Sign In VC")
                self.displayErrorAlert(message: "Username or Password is not recognized.")
            }
        })
    }
    
    /*
     Used when user enters email
    */
    private func loginWithEmail(email: String, password: String) {
        FBDatabase.signInUser(email: email, password: password, with_completion: {(id, error) in
            if let activeID = id {
                print("Got user id in sign in VC")
                FBDatabase.setAutomaticSignIn(with_email: email, with_password: password, with_id: activeID)
                let ref = Database.database().reference()
                FBDatabase.getUser(with_id: activeID, ref: ref, with_completion: {(user) in
                    ref.removeAllObservers()
                    if let activeUser = user {
                        print("Got user in Sign in VC")
                        self.performSegue(withIdentifier: "PageViewSegue", sender: activeUser)
                    }
                    else {
                        print("Did not get user in Sign in VC")
                        // TODO: - Handle error
                    }
                })
            }
            else {
                print("Did not get user id in sign in VC")
                print(error!)
                self.displayErrorAlert(message: error!)
            }
        })
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
    
    
    
    private func displayErrorAlert(message: String) {
        let alert = FCAlertView()
        alert.makeAlertTypeWarning()
        alert.dismissOnOutsideTouch = true
        
        
        let titleString = "Oops!"
        let subtitleString = message
        
        alert.showAlert(inView: self,
                        withTitle: titleString,
                        withSubtitle: subtitleString,
                        withCustomImage: nil,
                        withDoneButtonTitle: "Try Again",
                        andButtons: nil)
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        let segueID = segue.identifier
        if segueID == "PageViewSegue" {
            let user = sender as! User
            //let pageViewNav = segue.destination as! UINavigationController
            //let pageViewVC = pageViewNav.topViewController as! PageViewController
            let pageViewVC = segue.destination as! PageViewController
            pageViewVC.user = user
        }
     }
    
    
}


