//
//  SignUpVC.swift
//  reCap
//
//  Created by Jackson Delametter on 2/4/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import UIKit
import Hero
import SkyFloatingLabelTextField
import Firebase

class CreateAccountVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // MARK: - Outlets
    @IBOutlet weak var fullNameOutlet: SkyFloatingLabelTextField!
    @IBOutlet weak var emailOutlet: SkyFloatingLabelTextField!
    @IBOutlet weak var usernameOutlet: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordOutlet: SkyFloatingLabelTextField!
    @IBOutlet weak var verifyPasswordOutlet: SkyFloatingLabelTextField!
    @IBOutlet weak var imageOutlet: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Properties
    var gradientLayer: CAGradientLayer!
    
    // MARK: - View Controller Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        let duration: TimeInterval = TimeInterval(exactly: 0.5)!
        
        setup()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup Methods
    
    private func setup() {
        createGradientLayer()
        setupNavigationController()
        self.hideKeyboard()
        self.title = "Create Account"
        self.tableView.allowsSelection = false
    }
    
    // MARK: - Outlet Actions
    
    @IBAction func addPressed(_ sender: Any) {
        if let name = fullNameOutlet.text, let email = emailOutlet.text, let username = usernameOutlet.text, let password = passwordOutlet.text, let verifyPass = verifyPasswordOutlet.text, let image = imageView.image, password == verifyPass {
            // If all fields are filled out
            print("Creating user")
            FBDatabase.createUserAuth(email: email, password: password, with_completion: {(id, error) in
                if let activeID = id {
                    print("Got id in SignIn VC")
                    let user = User(id: activeID, name: name, email: email, username: username)
                    FBDatabase.addUpdateUser(user: user, with_completion: {(error) in
                        if let realError = error {
                            // Error
                            print("Did not write user to database in SignInVC")
                            print(realError)
                        }
                        else {
                            // No error
                            print("Wrote user to database in SignInVC")
                            FBDatabase.setAutomaticSignIn(with_email: email, with_password: password, with_id: activeID)
                            let usernameObj = Username(username: username, email: email)
                            FBDatabase.addUpdateUsername(with_username: usernameObj, with_completion:{(error) in
                                if let actualError = error {
                                    // Error occured
                                    print("Did not write Username to database")
                                    print(actualError)
                                }
                                else {
                                    // No error
                                    print("Wrote Username in database")
                                    
                                    FBDatabase.addProfilePicture(with_image: image, for_user: user, with_completion: {(error) in
                                        if let actualError = error {
                                            // An error occured
                                            print("Did not write profile picture in database")
                                            print(actualError)
                                        }
                                        else {
                                            // No error occured
                                            print("Added profile picture to database")
                                            self.performSegue(withIdentifier: "PageViewSegue", sender: nil)
                                        }
                                    })
                                    
                                    
                                }
                            })
                            
                        }
                    })
                }
                else {
                    print("Did not get id in SignIn VC")
                    print(error!)
                }
            })
        }
        else {
            print("Fill out all fields")
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
            //imageOutlet.setBackgroundImage(pickedImage, for: .normal)
            
            imageView.image = pickedImage
            imageView.layer.borderWidth = 1
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.layer.cornerRadius = imageView.layer.frame.width / 2
            imageView.layer.masksToBounds = false
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            
            imageOutlet.setTitle("", for: .normal)
            
            let imageData:NSData = UIImagePNGRepresentation(pickedImage)! as NSData
            UserDefaults.standard.set(imageData, forKey: "profileImage")
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
    
    
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.bounds
        
        let bottomColor = UIColor(displayP3Red: 99/255, green: 207/255, blue: 155/255, alpha: 1).cgColor
        let topColor = UIColor(displayP3Red: 9/255, green: 85/255, blue: 95/255, alpha: 1).cgColor
        
        gradientLayer.colors = [topColor, bottomColor]
        
        //self.tableView.layer.insertSublayer(gradientLayer, at: 0)
        //self.tableView.backgroundView?.layer.insertSublayer(gradientLayer, at: 1)
        //self.view.layer.insertSublayer(gradientLayer, at: 0)
        let background: UIView? = UIView(frame: self.view.frame)
        background?.layer.insertSublayer(gradientLayer, at: 0)
        self.tableView.backgroundView = background
    }
    
    func setupNavigationController() {
        let logo = #imageLiteral(resourceName: "Logo Text Wide")
        let imageView = UIImageView(image:logo)
        imageView.hero.id = "logoID"
        let duration: TimeInterval = TimeInterval(exactly: 0.5)!
        imageView.hero.modifiers = [.forceNonFade, .duration(duration)]
        
        
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        let bannerWidth = self.navigationController?.navigationBar.frame.size.width
        let bannerHeight = self.navigationController?.navigationBar.frame.size.height
        let bannerx = bannerWidth! / 2 - logo.size.width / 2
        let bannery = bannerHeight! / 2 - logo.size.height / 2
        imageView.frame = CGRect(x: bannerx, y: bannery, width: bannerWidth!, height: bannerHeight!)
        
        imageView.contentMode = .scaleAspectFit
        
        self.navigationItem.titleView = imageView
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
    }
    

}
