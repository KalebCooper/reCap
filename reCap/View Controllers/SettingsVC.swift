//
//  SettingsVC.swift
//  reCap
//
//  Created by Jackson Delametter on 2/17/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import UIKit
import Firebase

class SettingsVC: UITableViewController, UITextFieldDelegate {
    
    var user: User!
    var userData: [String]? = []
    let limitLength = 18

    override func viewDidLoad() {
        super.viewDidLoad()
        applyBlurEffect(image: #imageLiteral(resourceName: "Gradient"))
        self.title = "Settings"
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        setupUser()

    }

    func setupUser() {
        
        let id = FBDatabase.getSignedInUserID()!
        let ref = Database.database().reference()
        FBDatabase.getUser(with_id: id, ref: ref, with_completion: {(user) in
            ref.removeAllObservers()
            if let activeUser = user {
                self.user = activeUser
                self.userData?.append(activeUser.name)
                self.userData?.append(activeUser.username)
                self.userData?.append(activeUser.email)
                self.tableView.reloadData()
            }
            else {
                print("Did not get user in app delegate")
            }
        })
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        let cellName = cell.textLabel?.text!
        
        
        
        if self.userData?.count == 3 {
            print("cellForRowAt")
            if cellName == "Full Name" {
                print("Full Name tapped")
                cell.detailTextLabel?.text = userData?[0]
            }
            else if cellName == "Username" {
                print("Username tapped")
                cell.detailTextLabel?.text = userData?[1]
            }
            else if cellName == "Email" {
                print("Email tapped")
                cell.detailTextLabel?.text = userData?[2]
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
            print("Full Name tapped")
            
            let alertController = UIAlertController(title: "Update Full Name", message: "", preferredStyle: .alert)
            alertController.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "Enter Full Name"
                textField.keyboardAppearance = .dark
                textField.delegate = self
                
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action : UIAlertAction!) -> Void in })
            let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
                let firstTextField = alertController.textFields![0] as UITextField
                
                
                self.user.name = firstTextField.text
                
                FBDatabase.addUpdateUser(user: self.user, with_completion: { (error) in
                    if let actualError = error {
                        // An error occured
                        print("Did not write profile picture in database")
                        print(actualError)
                    }
                    else {
                        // No error occured
                    }
                })
                
            })
            
            alertController.addAction(cancelAction)
            alertController.addAction(saveAction)
            
            self.present(alertController, animated: true, completion: nil)
            
            
        }
        else if cellName == "Username" {
            print("Username tapped")
            
            let alertController = UIAlertController(title: "Update Username", message: "", preferredStyle: .alert)
            alertController.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "Enter Username"
                textField.keyboardAppearance = .dark
                textField.delegate = self
                
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action : UIAlertAction!) -> Void in })
            let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
                let firstTextField = alertController.textFields![0] as UITextField
                
                
                //Update Username through Firebase Authentication AND Database
                
            })
            
            alertController.addAction(cancelAction)
            alertController.addAction(saveAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        else if cellName == "Email" {
            print("Email tapped")

            let alertController = UIAlertController(title: "Update Email", message: "", preferredStyle: .alert)
            alertController.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "Enter Email"
                textField.keyboardAppearance = .dark
                textField.delegate = self
                
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action : UIAlertAction!) -> Void in })
            let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
                let firstTextField = alertController.textFields![0] as UITextField
                
                
                //Update Email through Firebase Authentication AND Database
                
            })
            
            alertController.addAction(cancelAction)
            alertController.addAction(saveAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        else if cellName == "Notifications" {
            print("Notifications tapped")
        }
        else if cellName == "About" {
            print("About tapped")
        }
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
        let ok = UIAlertAction(title: "ok", style: .destructive, handler: {(okAction) in
            FBDatabase.signOutUser(with_completion: {(error) in
                if let realError = error {
                    print(realError)
                }
                else {
                    // No error
                    print("Logged user out")
                    FBDatabase.removeAutomaticSignIn()
                    let signInVC = UIStoryboard(name: "SignIn", bundle: nil).instantiateInitialViewController()
                    let appDelege = UIApplication.shared.delegate as! AppDelegate
                    appDelege.window?.rootViewController = signInVC
                    appDelege.window?.rootViewController?.dismiss(animated: true, completion: nil)
                }
            })
        })
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
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
