//
//  LeaderboardsFriendsVC.swift
//  reCap
//
//  Created by Jackson Delametter on 2/11/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import UIKit
import Firebase
import SwiftLocation
import CoreLocation
import FCAlertView
import RealmSwift

class LeaderboardsFriendsVC: UITableViewController, FCAlertViewDelegate {
    
    @IBOutlet weak var backButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var locationControl: UISegmentedControl!
    
    @IBAction func locationFilterChanged(_ sender: Any) {
        let currentLocationIndex = self.locationControl.selectedSegmentIndex
        if currentLocationIndex == LeaderboardsFriendsVC.STATE_FILTER {
            self.leaderboardsList = self.stateLeaderboards
        }
        else if currentLocationIndex == LeaderboardsFriendsVC.COUNTRY_FILTER {
            self.leaderboardsList = self.countryLeaderboards
        }
        else if currentLocationIndex == LeaderboardsFriendsVC.GLOBAL_FILTER {
            self.leaderboardsList = self.globalLeaderboards
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Properties
    static var LEADERBOARD_MODE = 0
    static var FRIENDS_LIST_MODE = 1
    var mode: Int!
    var user: User!
    var userData: UserData!
    private var friendsList: [UserData]!
    private var leaderboardsList: [UserData]!
    private var stateLeaderboards: [UserData]!
    private var countryLeaderboards: [UserData]!
    private var globalLeaderboards: [UserData]!
    private var realm: Realm!
    
    private static let STATE_FILTER = 0
    private static let COUNTRY_FILTER = 1
    private static let GLOBAL_FILTER = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyBlurEffect(image: #imageLiteral(resourceName: "Gradient"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.realm = try! Realm()
        self.userData = realm.object(ofType: UserData.self, forPrimaryKey: SyncUser.current?.identity)
        friendsList = []
        leaderboardsList = []
        stateLeaderboards = []
        countryLeaderboards = []
        globalLeaderboards = []
        if mode != nil {
            // If the mode has been selected
            if mode == LeaderboardsFriendsVC.FRIENDS_LIST_MODE, userData != nil {
                // Friends list mode has been picked
                setupFriendsList()
            }
            else if mode == LeaderboardsFriendsVC.LEADERBOARD_MODE {
                setupLeaderboards()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if mode == LeaderboardsFriendsVC.FRIENDS_LIST_MODE {
            return friendsList.count
        }
        else if mode == LeaderboardsFriendsVC.LEADERBOARD_MODE {
            return leaderboardsList.count
        }
        else {
            return 0
        }
    }
    
    // MARK: - Setup Methods
    private func setupLeaderboards() {
        self.title = "Leaderboards"
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        let stateResults = realm.objects(UserData.self).filter("state = '\(userData.state!)'").sorted(byKeyPath: "points", ascending: false)
        let countryResults = realm.objects(UserData.self).filter("country = '\(userData.country!)'").sorted(byKeyPath: "points", ascending: false)
        let globalResults = realm.objects(UserData.self).sorted(byKeyPath: "points", ascending: false)
        var count = 0
        let maximum = 50
        for userData in stateResults {
            if count < maximum {
                // Can still take users in leaderboards
                self.stateLeaderboards.append(userData)
                count = count + 1
            }
            else {
                // Not 50 users
                break
            }
        }
        count = 0
        for userData in countryResults {
            if count < 50 {
                // Can still take users in leaderboards
                self.countryLeaderboards.append(userData)
                count = count + 1
            }
            else {
                // Not 50 users
                break
            }
        }
        count = 0
        for userData in globalResults {
            if count < 50 {
                // Can still take users in leaderboards
                self.globalLeaderboards.append(userData)
                count = count + 1
            }
            else {
                // Not 50 users
                break
            }
        }
        self.leaderboardsList = self.stateLeaderboards
        self.tableView.reloadData()
    }
    
    private func setupFriendsList() {
        self.title = "Friends List"
        self.locationControl.isHidden = true
        for friends in self.userData.friends {
            self.friendsList.append(friends)
        }
        self.tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! LeaderboardFriendsTableCell
        let user: UserData!
        if mode == LeaderboardsFriendsVC.FRIENDS_LIST_MODE {
            user = friendsList[indexPath.row]
            cell.pointsOutlet.text = "\(user.points) points"
        }
        else if mode == LeaderboardsFriendsVC.LEADERBOARD_MODE {
            user = leaderboardsList[indexPath.row]
            cell.pointsOutlet.text = "\(user.points) points"
        }
        else {
            return cell
        }
        cell.fullNameOutlet.text = user.name
        cell.usernameOutlet.text = user.email
        FBDatabase.getProfilePicture(for_user: user, with_progress: {(progress, total) in
            
        }, with_completion: {(image) in
            if let profilePic = image {
                cell.imageOutlet.image = profilePic
                
            }
            else {
                print("Did not get profile pic")
            }
        })
        // Configure the cell...
        return cell
    }
    
    // MARK: - Outlet Action Methods
    @IBAction func addFriendPressed(_ sender: Any) {
        
        let alert = FCAlertView()
        alert.makeAlertTypeCaution()
        alert.dismissOnOutsideTouch = false
        alert.darkTheme = true
        alert.bounceAnimations = true
        alert.addTextField(withPlaceholder: "Enter Friends Username") { (email) in
            if email != "", email != self.userData.email {
                FCAlertView.displayAlert(title: "Adding...", message: "Adding friend to your friends list...", buttonTitle: "Dismiss", type: "progress", view: self)
                if let friend = self.realm.objects(UserData.self).filter("email = '\(email!.description)'").first {
                    // The user exists
                    self.friendsList.append(friend)
                    self.tableView.beginUpdates()
                    let index = IndexPath(row: self.friendsList.count-1, section: 0)
                    self.tableView.insertRows(at: [index], with: .automatic)
                    self.tableView.endUpdates()
                    try! self.realm.write {
                        self.userData.friends.append(friend)
                    }
                }
                else {
                    FCAlertView.displayAlert(title: "Oops!", message: "Please make sure to type a email", buttonTitle: "Got It!", type: "warning", view: self)
                }
            }
        }
        alert.addButton("Cancel") {
            
        }
        alert.showAlert(withTitle: "Add Friend", withSubtitle: "Please enter your friends username.", withCustomImage: nil, withDoneButtonTitle: "Add", andButtons: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if mode == LeaderboardsFriendsVC.FRIENDS_LIST_MODE {
            self.performSegue(withIdentifier: "PhotoLibSegue", sender: friendsList[indexPath.row])
        }
        else if mode == LeaderboardsFriendsVC.LEADERBOARD_MODE {
            self.performSegue(withIdentifier: "PhotoLibSegue", sender: leaderboardsList[indexPath.row])

        }
    }
    
    // MARK: - Outlet Actions
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let segueID = segue.identifier
        if segueID == "PhotoLibSegue" {
            let friend = sender as! UserData
            let destination = segue.destination as! UINavigationController
            let photoLibVC = destination.topViewController as! PhotoLibChallengeVC
            photoLibVC.userData = friend
            photoLibVC.mode = PhotoLibChallengeVC.FRIENDS_PHOTO_LIB_MODE
        }
    }
    
    
}
