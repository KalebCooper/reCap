//
//  PhotoLibChallengeVC.swift
//  reCap
//
//  Created by Jackson Delametter on 2/6/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import UIKit
import Firebase

class PhotoLibChallengeVC: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, ImageButtonDelegate {
    
    // MARK: - Outlets
    
    // MARK: - Properties
    private var locations: [String]!
    private var locationDictionary: [String : [PictureData]]!
    private var challenges: [String]!
    private var challengesDictionary: [String : [PictureData]]!
    var user: User!
    var mode: Int!
    
    // MARK: - Constants
    private static let PHOTO_SEGUE = "PhotoSegue"
    private static let PHOTO_SEGUE_PICTURE_DATA_INDEX = 0
    private static let PHOTO_SEGUE_PICTURE_INDEX = 1
    private static let TAKE_PIC_FROM_WEEK = "Recapture photos from a week ago"
    private static let TAKE_PIC_FROM_MONTH = "Recapture photos from a month ago"
    private static let TAKE_PIC_FROM_YEAR = "Recapture photos from a year ago"
    static let PHOTO_LIB_MODE = 0
    static let CHALLENGE_MODE = 1
    static let ACTIVE_CHALLENGE_MODE = 2
    static let INVALID_MODE = -1
    static let SECONDS_IN_WEEK = 604800
    static let SECONDS_IN_MONTH = PhotoLibChallengeVC.SECONDS_IN_WEEK * 4
    static let SECONDS_IN_YEAR = PhotoLibChallengeVC.SECONDS_IN_MONTH * 12
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if user != nil, mode != nil {
            if mode == PhotoLibChallengeVC.PHOTO_LIB_MODE {
                setupPhotoLib()
            }
            else if mode == PhotoLibChallengeVC.CHALLENGE_MODE {
                setupChallenge()
            }
            else if mode == PhotoLibChallengeVC.ACTIVE_CHALLENGE_MODE {
                setupChallenge()
            }
        }
        else {
            mode = PhotoLibChallengeVC.INVALID_MODE
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Outlet Action Methods
    
    
    @IBAction func backPressed(_ sender: Any) {
        print("Back Pressed")
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Setup Methods
    
    private func setupPhotoLib() {
        locations = []
        locationDictionary = [:]
        self.tableView.allowsSelection = false
        let ref = Database.database().reference()
        FBDatabase.getPictureData(for_user: user, ref: ref, with_completion: {(pictureDataList) in
            for pictureData in pictureDataList {
                let location = pictureData.locationName
                if !self.locations.contains(location!) {
                    // Location is not in the locations array
                    // Add it to the array and initialize
                    // an empty array for the key location
                    self.locations.append(location!)
                    self.locationDictionary[location!] = []
                }
                var pictureDataArray = self.locationDictionary[location!]!
                pictureDataArray.append(pictureData)
                self.locationDictionary[location!] = pictureDataArray
            }
            self.tableView.reloadData()
        })
    }
    
    private func setupChallenge() {
        challenges = [PhotoLibChallengeVC.TAKE_PIC_FROM_WEEK, PhotoLibChallengeVC.TAKE_PIC_FROM_MONTH, PhotoLibChallengeVC.TAKE_PIC_FROM_YEAR]
        challengesDictionary = [PhotoLibChallengeVC.TAKE_PIC_FROM_WEEK : [], PhotoLibChallengeVC.TAKE_PIC_FROM_MONTH : [], PhotoLibChallengeVC.TAKE_PIC_FROM_YEAR : []]
        self.tableView.allowsSelection = false
        let ref = Database.database().reference()
        let currentDate = Date()
        FBDatabase.getPictureData(for_user: user, ref: ref, with_completion: {(PictureDataList) in
            for pictureData in PictureDataList {
                let pictureDate = DateGetter.getDateFromString(string: pictureData.time)
                let dateDiffSec = Int(abs(pictureDate.timeIntervalSince(currentDate)))
                if dateDiffSec >= PhotoLibChallengeVC.SECONDS_IN_YEAR {
                    self.challengesDictionary[PhotoLibChallengeVC.TAKE_PIC_FROM_YEAR]?.append(pictureData)
                }
                else if dateDiffSec >= PhotoLibChallengeVC.SECONDS_IN_MONTH {
                    self.challengesDictionary[PhotoLibChallengeVC.TAKE_PIC_FROM_MONTH]?.append(pictureData)
                }
                else if dateDiffSec >= PhotoLibChallengeVC.SECONDS_IN_WEEK {
                    self.challengesDictionary[PhotoLibChallengeVC.TAKE_PIC_FROM_WEEK]?.append(pictureData)
                }
            }
            self.tableView.reloadData()
        })
    }
    
    // MARK: - ImageButton Methods
    func imageButtonPressed(image: UIImage, pictureData: PictureData) {
        print("Image Pressed")
        if mode == PhotoLibChallengeVC.CHALLENGE_MODE {
            let alert = UIAlertController(title: nil, message: "How would you like to acept this challenge?", preferredStyle: .actionSheet)
            let withNav = UIAlertAction(title: "With navigation", style: .default, handler: {(action) in
                self.addChallengeToUser(pictureData: pictureData)
                // TODO: Start navigation
            })
            let withoutNav = UIAlertAction(title: "Withought navigation", style: .default, handler: {(action) in
                self.addChallengeToUser(pictureData: pictureData)
                self.tableView.reloadData()
            })
            let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
            alert.addAction(withNav)
            alert.addAction(withoutNav)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
        else if mode == PhotoLibChallengeVC.PHOTO_LIB_MODE {
            self.performSegue(withIdentifier: "PhotoSegue", sender: [pictureData, image])
        }
    }
    
    private func addChallengeToUser(pictureData: PictureData) {
        self.user.activeChallengeID = pictureData.id
        FBDatabase.addUpdateUser(user: self.user, with_completion: {(error) in
            if let actualError = error {
                print(actualError)
            }
            else {
                print("Added challenge to user")
            }
        })
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if mode == PhotoLibChallengeVC.PHOTO_LIB_MODE {
            return locations.count
        }
        else if mode == PhotoLibChallengeVC.CHALLENGE_MODE {
            return challenges.count
        }
        else if mode == PhotoLibChallengeVC.ACTIVE_CHALLENGE_MODE {
            return challenges.count
        }
        else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if mode == PhotoLibChallengeVC.PHOTO_LIB_MODE {
            return locations[section]
        }
        else if mode == PhotoLibChallengeVC.CHALLENGE_MODE {
            return challenges[section]
        }
        else if mode == PhotoLibChallengeVC.ACTIVE_CHALLENGE_MODE {
            return challenges[section]
        }
        else {
            return ""
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! PhotoChallengeTableCell
        // Configure the cell...
        
        return cell
    }
    
    /*
     This method also sets the collection view delegate in
     every table cell. It also tags each collection view
     to determine what table cell it is apart of
     */
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let tableCell = cell as! PhotoChallengeTableCell
        tableCell.setPictureCollectionViewDataSourceDelegate(dataSourceDelegate: self, forSection: indexPath.section)
    }
    
    // MARK: - Collection View Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let collectionViewTag = collectionView.tag
        if mode == PhotoLibChallengeVC.PHOTO_LIB_MODE {
            let location = locations[collectionViewTag]
            return (locationDictionary[location]?.count)!
        }
        else if mode == PhotoLibChallengeVC.CHALLENGE_MODE {
            let challenge = challenges[collectionViewTag]
            return (challengesDictionary[challenge]?.count)!
        }
        else if mode == PhotoLibChallengeVC.ACTIVE_CHALLENGE_MODE {
            let challenge = challenges[collectionViewTag]
            return (challengesDictionary[challenge]?.count)!
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCell", for: indexPath) as! PhotoChalColCell
        cell.setImageViewDelegate(delegate: self)
        let index = collectionView.tag
        let row = indexPath.row
        var pictureData: PictureData?
        if mode == PhotoLibChallengeVC.PHOTO_LIB_MODE {
            let location = locations[index]
            let locationDataArray = locationDictionary[location]
            pictureData = locationDataArray![row]
            cell.pictureData = pictureData
        }
        else if (mode == PhotoLibChallengeVC.CHALLENGE_MODE) || (mode == PhotoLibChallengeVC.ACTIVE_CHALLENGE_MODE) {
            let challenge = challenges[index]
            let challengeDataArray = challengesDictionary[challenge]
            pictureData = challengeDataArray![row]
            cell.pictureData = pictureData
        }
        if let realPictureData = pictureData{
            FBDatabase.getPicture(pictureData: realPictureData, with_progress: {(progress, total) in
                
            }, with_completion: {(image) in
                if let realImage = image {
                    print("Got image in PhotoLibChal VC")
                    cell.imageView.image = realImage
                }
                else {
                    print("Did not get image in PhotoLibChal VC")
                }
            })
            return cell
        }
        return cell
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let segueID = segue.identifier
        if segueID == PhotoLibChallengeVC.PHOTO_SEGUE {
            let destination = segue.destination as! PhotoVC
            let infoArray = sender as! [Any]
            let pictureData = infoArray[PhotoLibChallengeVC.PHOTO_SEGUE_PICTURE_DATA_INDEX] as! PictureData
            let picture = infoArray[PhotoLibChallengeVC.PHOTO_SEGUE_PICTURE_INDEX] as! UIImage
            destination.pictureData = pictureData
            destination.image = picture
        }
    }
    
    
}

