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
import FCAlertView
import RealmSwift

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
    var pickedImageUrl: URL!
    
    // MARK: - Contansts
    private static let PAGE_VIEW_SEGUE = "PageViewSegue"
    
    // MARK: - View Controller Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        let duration: TimeInterval = TimeInterval(exactly: 0.5)!
        setup()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
        if let name = fullNameOutlet.text, let email = emailOutlet.text, let password = passwordOutlet.text, let verifyPass = verifyPasswordOutlet.text, let image = imageView.image, password == verifyPass {
            // If all fields are filled out
            print("Creating user")
            let alert = FCAlertView()
            alert.makeAlertTypeProgress()
            alert.dismissOnOutsideTouch = false
            let titleString = "Creating account"
            alert.showAlert(inView: self,
                            withTitle: titleString,
                            withSubtitle: nil,
                            withCustomImage: nil,
                            withDoneButtonTitle: nil,
                            andButtons: nil)
            let creds = SyncCredentials.usernamePassword(username: email, password: password, register: true)
            SyncUser.logIn(with: creds, server: RealmConstants.AUTH_URL, onCompletion: {(user, err) in
                if let error = err {
                    print(error.localizedDescription)
                    alert.dismiss()
                    self.displayErrorAlert(message: error.localizedDescription)
                }
                else {
                    print("Created user and logged in")
                    alert.dismiss()
                    let activeUser = user!
                    let adminCreds = SyncCredentials.nickname("reCapp-admin", isAdmin: true)
                    SyncUser.logIn(with: adminCreds, server: RealmConstants.AUTH_URL, onCompletion: {(user, err) in
                        if let error = err {
                            print(error.localizedDescription)
                        }
                        else {
                            let admin = user!
                            let permissions = SyncPermission(realmPath: "/reCapp", identity: activeUser.identity!, accessLevel: .write)
                            admin.apply(permissions, callback: {(err) in
                                if let error = err {
                                    print(error.localizedDescription)
                                }
                                else {
                                    print("Create Account: Wrote permissions")
                                    admin.logOut()
                                    let config = SyncConfiguration(user: activeUser, realmURL: RealmConstants.REALM_URL)
                                    Realm.Configuration.defaultConfiguration = Realm.Configuration(syncConfiguration: config, objectTypes:[UserData.self, PictureData.self])
                                    let realm = try! Realm()
                                    let userData = UserData(id: activeUser.identity!, name: name, email: email)
                                    print("user id is \(userData.id)")
                                    try! realm.write {
                                        realm.add(userData)
                                        print("Create Account: Wrote user to realm")
                                    }
                                    FBDatabase.addProfilePicture(with_image: image, for_user: userData, with_completion: {(err) in
                                        if let error = err {
                                            print(error)
                                        }
                                        else {
                                            print("Create Account: Added profile picture")
                                        }
                                    })
                                    self.performSegue(withIdentifier: CreateAccountVC.PAGE_VIEW_SEGUE, sender: image)
                                }
                            })
                        }
                    })
                }
            })
        }
        else {
            print("Fill out all fields")
            displayErrorAlert(message: "Please fill out all fields.")
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
        if segue.identifier == CreateAccountVC.PAGE_VIEW_SEGUE {
            let image = sender as! UIImage
            let destination = segue.destination as! PageViewController
            destination.profileImage = image
        }
    }
}
