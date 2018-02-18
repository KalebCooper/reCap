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
    private var pickedMode: Int!
    var mode: Int?
    var user: User!
    var queriedUsers: [User]!

    override func viewDidLoad() {
        super.viewDidLoad()
        queriedUsers = []
        if let pickedMode = mode {
            // If the mode has been selected
            if pickedMode == LeaderboardsFriendsVC.FRIENDS_LIST_MODE {
                // Friends list mode has been picked
                setupFriendsList()
            }
        }
        else {
            // Leaderboard mode has been picked
            setupLeaderboards()
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
        return queriedUsers.count
    }
    
    // MARK: - Setup Methods
    private func setupLeaderboards() {
        let settingsButton = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsPressed))
        let navController = self.navigationController
        let navBar = navController?.navigationBar
        let navItem = navBar?.topItem
        navItem?.setRightBarButton(settingsButton, animated: true)
        navItem?.title = "Leaderboards"
        navBar?.setItems([navItem!], animated: true)
    }
    
    private func setupFriendsList() {
        let friendsList = user.friendsID
        let ref = Database.database().reference()
        for id in friendsList! {
            // Searches through the logged in users friends list
            FBDatabase.getUser(with_id: id, ref: ref, with_completion: {(user) in
                if let activeUser = user {
                    self.queriedUsers.append(activeUser)
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
        let queriedUser = queriedUsers[indexPath.row]
        cell.fullNameOutlet.text = queriedUser.name
        cell.usernameOutlet.text = queriedUser.username
        if pickedMode == LeaderboardsFriendsVC.FRIENDS_LIST_MODE {
            cell.pointsOutlet.text = ""
        }
        else if pickedMode == LeaderboardsFriendsVC.LEADERBOARD_MODE {
            cell.pointsOutlet.text = String(user.points)
        }
        FBDatabase.getProfilePicture(for_user: queriedUser, with_progress: {(progress, total) in
            
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
    
    /*
     Called when settings is pressed
     in leaderboard mode
    */
    @objc private func settingsPressed() {
        print("Settings Pressed")
        self.performSegue(withIdentifier: "SettingsSegue", sender: nil)
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
