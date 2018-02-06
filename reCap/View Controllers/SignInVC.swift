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
    
    var gradientLayer: CAGradientLayer!
    
    // MARK: - View Controller Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createGradientLayer()
        //createUser()
        // Do any additional setup after loading the view.
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
    
    func createUser() {
        
        FBDatabase.createUserAuth(email: "Jackson@gmail.com", password: "password", name: "Jackson", with_completion: {(id, error) in
            if let activeID = id {
                print("Got id in SignIn VC")
                let user = User(id: activeID, name: "Jackson", email: "jackson@gmail.com")
                FBDatabase.addUpdateUser(user: user, with_completion: {(error) in
                    if let realError = error {
                        // Error
                        print("Did not write user to database in SignInVC")
                        print(realError)
                    }
                    else {
                        // No error
                        print("Wrote user to database in SignInVC")
                    }
                })
            }
            else {
                print("Did not get id in SignIn VC")
                print(error!)
            }
        })
    }
    
    // MARK: - Outlet Actions
    
    /*
     Called when the normal sign in button
     is pressed
    */
    func signInPressed() {
        let ref = Database.database().reference()
        FBDatabase.signInUser(email: "Jackson@gmail.com", password: "password", with_completion: {(id, error) in
            if let activeID = id {
                print("Got user id in sign in VC")
                FBDatabase.getUser(with_id: activeID, ref: ref, with_completion: {(user) in
                    if let activeUser = user {
                        print("Got user in SignIn VC")
                    }
                    else {
                        print("Did not get user in SignIn VC")
                    }
                })
            }
            else {
                print("Did not get user id in sign in VC")
                print(error!)
            }
        })

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
