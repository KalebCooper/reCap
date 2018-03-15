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
    
    @IBOutlet weak var backButtonOutlet: UIBarButtonItem!
    
    // MARK: - Properties
    static var LEADERBOARD_MODE = 0
    static var FRIENDS_LIST_MODE = 1
    var mode: Int!
    var user: User!
    private var friendsList: [User]!
    private var leaderboardsList: [User]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyBlurEffect(image: #imageLiteral(resourceName: "Gradient"))
        print("Leaderboards loaded")
        if mode != nil, user != nil {
            // If the mode has been selected
            if mode == LeaderboardsFriendsVC.FRIENDS_LIST_MODE {
                // Friends list mode has been picked
                setupFriendsList()
                self.title = "Friends List"
            }
            else if mode == LeaderboardsFriendsVC.LEADERBOARD_MODE {
                setupLeaderboards()
                self.title = "Leaderboards"
                backButtonOutlet.isEnabled = false
                backButtonOutlet.title = " "
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if mode != nil, user != nil {
            // If the mode has been selected
            if mode == LeaderboardsFriendsVC.FRIENDS_LIST_MODE {
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
        leaderboardsList = []
        var unsortedList: [User] = []
        let ref = Database.database().reference()
        FBDatabase.getAllUsers(query_by: FBDatabase.USER_POINTS, with_max_query: 50, with_ref: ref, with_completion: {(users) in
            for user in users {
                unsortedList.append(user)
            }
            self.leaderboardsList = Sort.SortUsersByDescendingOrder(users: unsortedList)
            self.tableView.reloadData()
        })
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
                    self.tableView.reloadData()
                }
                else {
                    // Did not get a user in the friends list
                    print("Did not get a user on the friends list in leaderboardsFriendsVC")
                }
            })
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! LeaderboardFriendsTableCell
        let user: User!
        if mode == LeaderboardsFriendsVC.FRIENDS_LIST_MODE {
            user = friendsList[indexPath.row]
            cell.pointsOutlet.text = "\(user.points!) points"
        }
        else if mode == LeaderboardsFriendsVC.LEADERBOARD_MODE {
            user = leaderboardsList[indexPath.row]
            cell.pointsOutlet.text = "\(user.points!) points"
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
        let alert = UIAlertController(title: "Add Friend", message: "Enter the exact username of the person you are wishing to add.", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {(textField) in
            textField.placeholder = "Username"
            textField.keyboardAppearance = .dark
        })
        let okAction = UIAlertAction(title: "Add", style: .default, handler: {(action) in
            let usernameTextField = alert.textFields![0]
            let username = usernameTextField.text
            let ref = Database.database().reference()
            FBDatabase.getUsername(with_ref: ref, with_username: username!, with_completion: {(username) in
                ref.removeAllObservers()
                if let usernameObj = username {
                    print("Got username in LeaderboardsFriends VC")
                    let id = usernameObj.id
                    self.user.friendsID.append(id!)
                    let ref = Database.database().reference()
                    FBDatabase.getUser(with_id: id!, ref: ref, with_completion: {(user) in
                        if let activeUser = user {
                            print("Got new user in LeaderboardFriends VC")
                            self.friendsList.append(activeUser)
                        }
                        else {
                            print("Did not get new user in LeaderboardsFriends VC")
                        }
                        self.tableView.reloadData()
                    })
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
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "PhotoLibSegue", sender: friendsList[indexPath.row])
    }
    
    // MARK: - Outlet Actions
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Misc.
    public func updateViewController(user: User) {
        self.user = user
        self.tableView.reloadData()
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
            let friend = sender as! User
            let destination = segue.destination as! UINavigationController
            let photoLibVC = destination.topViewController as! PhotoLibChallengeVC
            photoLibVC.user = friend
            photoLibVC.mode = PhotoLibChallengeVC.PHOTO_LIB_MODE
        }
    }
    
    
}
