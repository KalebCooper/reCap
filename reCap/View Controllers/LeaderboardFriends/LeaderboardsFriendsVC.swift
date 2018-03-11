//
//  LeaderboardsFriendsVC.swift
//  reCap
//
//  Created by Jackson Delametter on 2/11/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import UIKit
import Firebase

class LeaderboardsFriendsVC: UITableViewController {
    
    // MARK: - Properties
    static var LEADERBOARD_MODE = 0
    static var FRIENDS_LIST_MODE = 1
    var mode: Int!
    var user: User!
    private var friendsList: [User]!
    private var leaderboardsList: [User]!

    override func viewDidLoad() {
        super.viewDidLoad()
        if mode != nil {
            // If the mode has been selected
            if mode == LeaderboardsFriendsVC.FRIENDS_LIST_MODE {
                // Friends list mode has been picked
                setupFriendsList()
                print("Setting up friends list")
            }
        }
        else {
            // Leaderboard mode has been picked
            setupLeaderboards()
            print("Setting up leaderboards")
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        /*let settingsButton = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsPressed))
        let navController = self.navigationController
        let navBar = navController?.navigationBar
        let navItem = navBar?.topItem
        navItem?.setRightBarButton(settingsButton, animated: true)
        navItem?.title = "Leaderboards"
        navBar?.setItems([navItem!], animated: true)*/
    }
    
    private func setupFriendsList() {
        friendsList = []
        let friendsIDList = user.friendsID
        let ref = Database.database().reference()
        for id in friendsIDList! {
            // Searches through the logged in users friends list
            FBDatabase.getUser(with_id: id, ref: ref, with_completion: {(user) in
                if let activeUser = user {
                    self.friendsList.append(activeUser)
                }
                else {
                    // Did not get a user in the friends list
                    print("Did not get a user on the friends list in leaderboardsFriendsVC")
                }
            })
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! LeaderboardFriendsTableCell
        let user: User!
        if mode == LeaderboardsFriendsVC.FRIENDS_LIST_MODE {
            user = friendsList[indexPath.row]
            cell.pointsOutlet.text = ""
        }
        else if mode == LeaderboardsFriendsVC.LEADERBOARD_MODE {
            user = leaderboardsList[indexPath.row]
            cell.pointsOutlet.text = String(user.points)
        }
        else {
            return cell
        }
        cell.fullNameOutlet.text = user.name
        cell.usernameOutlet.text = user.username
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
        let alert = UIAlertController(title: "Add Friend", message: "Enter friends username", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {(textField) in
            textField.placeholder = "username"
        })
        let okAction = UIAlertAction(title: "ok", style: .default, handler: {(action) in
            let usernameTextField = alert.textFields![0]
            let username = usernameTextField.text
            let ref = Database.database().reference()
            FBDatabase.getUsername(with_ref: ref, with_username: username!, with_completion: {(username) in
                ref.removeAllObservers()
                if let usernameObj = username {
                    print("Got username in LeaderboardsFriends VC")
                    self.user.friendsID.append(usernameObj.id)
                    FBDatabase.addUpdateUser(user: self.user, with_completion: {(error) in
                        if let actualError = error {
                            print(actualError)
                        }
                        else {
                            print("Updated user in LeaderboardFriends VC")
                        }
                    })
                }
                else {
                    print("Did not get username in LeaderboardsFriends VC")
                }
            })
        })
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
