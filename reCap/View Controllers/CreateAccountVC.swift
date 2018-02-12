//
//  SignUpVC.swift
//  reCap
//
//  Created by Jackson Delametter on 2/4/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // MARK: - Outlets
    @IBOutlet weak var fullNameOutlet: UITextField!
    @IBOutlet weak var emailOutlet: UITextField!
    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var verifyPasswordOutlet: UITextField!
    @IBOutlet weak var imageOutlet: UIButton!
    
    // MARK: - Properties
    
    // MARK: - View Controller Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup Methods
    
    private func setup() {
        self.title = "Create Account"
        self.tableView.allowsSelection = false
    }
    
    // MARK: - Outlet Actions
    
    @IBAction func addPressed(_ sender: Any) {
        if let name = fullNameOutlet.text, let email = emailOutlet.text, let username = usernameOutlet.text, let password = passwordOutlet.text, let verifyPass = verifyPasswordOutlet.text, let image = imageOutlet.backgroundImage(for: .normal), password == verifyPass {
            // If all fields are filled out
            FBDatabase.createUserAuth(email: email, password: password, with_completion: {(id, error) in
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
    }
    
    
    @IBAction func selectImagePressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - Image Picker Methods
    
    /*
     Called when an image is picked
    */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // A valid image was picked
            imageOutlet.setBackgroundImage(pickedImage, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table View Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
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
