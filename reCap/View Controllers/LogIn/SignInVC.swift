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
import RealmSwift

class SignInVC: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var logoOutlet: UIImageView!
    @IBOutlet weak var emailUsernameOutlet: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var passwordOutlet: SkyFloatingLabelTextFieldWithIcon!
    
    // MARK: - Properties
    var gradientLayer: CAGradientLayer!
    
    // MARK: - Constants
    private static let PAGE_VIEW_SEGUE = "PageViewSegue"
    
    // MARK: - View Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        print("Sign in loaded")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
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
        if let username = emailUsernameOutlet.text, let password = passwordOutlet.text, username != "", password != "" {
            // If fields are filled out
            let alert = FCAlertView()
            alert.makeAlertTypeProgress()
            alert.dismissOnOutsideTouch = false
            let titleString = "Signing In"
            
            alert.showAlert(inView: self,
                            withTitle: titleString,
                            withSubtitle: nil,
                            withCustomImage: nil,
                            withDoneButtonTitle: nil,
                            andButtons: nil)
            let creds = SyncCredentials.usernamePassword(username: username, password: password)
            SyncUser.logIn(with: creds, server: RealmConstants.AUTH_URL, onCompletion: {(user, err) in
                if let error = err {
                    // Error logging in
                    print(error.localizedDescription)
                    self.displayErrorAlert(message: error.localizedDescription)
                }
                else {
                    print("Logged in user")
                    alert.dismiss()
                    let activeUser = user!
                    let config = SyncConfiguration(user: activeUser, realmURL: RealmConstants.REALM_URL)
                    Realm.Configuration.defaultConfiguration = Realm.Configuration(syncConfiguration: config, objectTypes:[UserData.self, PictureData.self])
                    self.performSegue(withIdentifier: SignInVC.PAGE_VIEW_SEGUE, sender: nil)
                }
            })
        }
        else {
            // Not all fields are filled out
            print("All Fields are not filled out")
            displayErrorAlert(message: "All Fields are not filled out")
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
        
     }
    
    
}


