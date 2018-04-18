//
//  SettingsVC.swift
//  reCap
//
//  Created by Jackson Delametter on 2/17/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import UIKit
import Firebase
import FCAlertView
import RealmSwift

class SettingsVC: UITableViewController, UITextFieldDelegate, FCAlertViewDelegate {
    
    var userData: UserData!
    var userDataValues: [String]!
    let limitLength = 18
    private var realm: Realm!

    override func viewDidLoad() {
        super.viewDidLoad()
        applyBlurEffect(image: #imageLiteral(resourceName: "Gradient"))
        self.title = "Settings"
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        self.realm = try! Realm()
        setup()
    }

    func setup() {
        self.userDataValues = []
        self.userDataValues?.append(self.userData.name)
        self.userDataValues?.append(self.userData.email)
        self.userDataValues?.append(userData.email)
        self.tableView.reloadData()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let cellName = cell.textLabel?.text!
        if self.userDataValues?.count == 3 {
            print("cellForRowAt")
            if cellName == "Full Name" {
                print("Full Name tapped")
                cell.detailTextLabel?.text = userDataValues?[0]
            }
            else if cellName == "Username" {
                print("Username tapped")
                cell.detailTextLabel?.text = userDataValues?[1]
            }
            else if cellName == "Email" {
                print("Email tapped")
                cell.detailTextLabel?.text = userDataValues?[2]
            }
        }
        return cell
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= limitLength
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let cellName = cell?.textLabel?.text!
        if cellName == "Full Name" {
            let alert = FCAlertView()
            alert.makeAlertTypeCaution()
            alert.dismissOnOutsideTouch = false
            alert.darkTheme = true
            alert.bounceAnimations = true
            alert.addTextField(withPlaceholder: "Enter Name") { (name) in
                if name != "" {
                    FCAlertView.displayAlert(title: "Changing...", message: "Your name is being changed...", buttonTitle: "Dismiss", type: "progress", view: self)
                    try! self.realm.write {
                        self.userData.name = name
                    }
                }
                else {
                    FCAlertView.displayAlert(title: "Oops!", message: "Please make sure to type a name", buttonTitle: "Got It!", type: "warning", view: self)
                }
            }
            
            alert.addButton("Cancel") {

            }
            alert.showAlert(withTitle: "Update Name", withSubtitle: "Please enter a new name.", withCustomImage: nil, withDoneButtonTitle: "Update", andButtons: nil)

        }
        /*else if cellName == "Username" {
            print("Username tapped")
            
            let alert = FCAlertView()
            alert.makeAlertTypeCaution()
            alert.dismissOnOutsideTouch = false
            alert.darkTheme = true
            alert.bounceAnimations = true
            alert.addTextField(withPlaceholder: "Enter Username") { (username) in

                
                if username != "" {
                    
                    FCAlertView.displayAlert(title: "Changing...", message: "Your username is being changed...", buttonTitle: "Dismiss", type: "progress", view: self)
                    
                    let newUsername = username
                    let ref = Database.database().reference()
                    FBDatabase.getUsername(with_ref: ref, with_username: newUsername!, with_completion: {(username) in
                        if username == nil {
                            // The username is not taken
                            let oldUsernameObj = Username(username: self.user.username, email: self.user.email, id: self.user.id)
                            let newUsernameObj = Username(username: newUsername!, email: self.user.email, id: self.user.id)
                            FBDatabase.addUpdateUsername(with_username: newUsernameObj, with_completion: {(error) in
                                
                            })
                            FBDatabase.deleteUsername(username: oldUsernameObj, with_completion: {(error) in
                                
                            })
                            self.user.username = newUsername
                            FBDatabase.addUpdateUser(user: self.user, with_completion: {(error) in
                                if error == nil {
                                    FCAlertView.displayAlert(title: "Success!", message: "Your username has been changed.", buttonTitle: "Dismiss", type: "success", view: self)
                                    self.tableView.reloadData()
                                }
                                else {
                                    FCAlertView.displayAlert(title: "Uh Oh!", message: error!, buttonTitle: "Dismiss", type: "warning", view: self)
                                }
                            })
                        }
                        else {
                            
                        }
                    })
                    
                    
                }
                else {
                    FCAlertView.displayAlert(title: "Oops!", message: "Please make sure to type a username", buttonTitle: "Got It!", type: "warning", view: self)
                }
                
                
            }
            
            alert.addButton("Cancel") {
                alert.dismiss()
            }
            alert.showAlert(withTitle: "Update Username", withSubtitle: "Please enter a new username.", withCustomImage: nil, withDoneButtonTitle: "Update", andButtons: nil)

            
            
            
        }*/
        else if cellName == "Logout" {
            // Logout pressed
            logoutPressed()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Misc.
    
    /*
     Called when logout cell it pressed
    */
    private func logoutPressed() {
        print("Logout pressed")
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Logout", style: .destructive, handler: {(okAction) in
            SyncUser.current?.logOut()
            let signInVC = UIStoryboard(name: "SignIn", bundle: nil).instantiateInitialViewController()
            let appDelege = UIApplication.shared.delegate as! AppDelegate
            appDelege.window?.rootViewController = signInVC
            appDelege.window?.rootViewController?.dismiss(animated: true, completion: nil)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func applyBlurEffect(image: UIImage){
        let imageToBlur = CIImage(image: image)
        let blurfilter = CIFilter(name: "CIGaussianBlur")
        blurfilter?.setValue(imageToBlur, forKey: "inputImage")
        let resultImage = blurfilter?.value(forKey: "outputImage") as! CIImage
        let blurredImage = UIImage(ciImage: resultImage)
        
        let blurredView = UIImageView(image: blurredImage)
        blurredView.contentMode = .center
        self.tableView.backgroundView = blurredView
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
