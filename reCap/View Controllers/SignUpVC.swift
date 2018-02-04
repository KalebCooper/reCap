//
//  SignUpVC.swift
//  reCap
//
//  Created by Jackson Delametter on 2/4/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {
    
    // MARK: - View Controller Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Outlet Actions
    
    /*
     Called when the add user
     is pressed
    */
    func addUserPressed() {
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
