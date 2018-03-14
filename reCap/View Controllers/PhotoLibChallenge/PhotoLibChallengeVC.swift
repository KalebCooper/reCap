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
    private static let VIEW_CHALLENGE_SEGUE = "ViewChallengeSegue"
    private static let PHOTO_SEGUE_PICTURE_DATA_INDEX = 0
    private static let PHOTO_SEGUE_PICTURE_INDEX = 1
    private static let TAKE_PIC_FROM_RECENT = "Recent Photos (+1 point)"
    private static let TAKE_PIC_FROM_WEEK = "Photos over a week ago (+5 points)"
    private static let TAKE_PIC_FROM_MONTH = "Photos over a month ago (+15 points)"
    private static let TAKE_PIC_FROM_YEAR = "Photos from over a year ago (+50 points)"
    private static let CHALLENGE_RECENT_POINTS = 1
    private static let CHALLENGE_WEEK_POINTS = 5
    private static let CHALLENGE_MONTH_POINTS = 10
    private static let CHALLENGE_YEAR_POINTS = 20
    static let PHOTO_LIB_MODE = 0
    static let CHALLENGE_MODE = 1
    static let ACTIVE_CHALLENGE_MODE = 2
    static let INVALID_MODE = -1
    static let SECONDS_IN_WEEK = 604800
    static let SECONDS_IN_MONTH = PhotoLibChallengeVC.SECONDS_IN_WEEK * 4
    static let SECONDS_IN_YEAR = PhotoLibChallengeVC.SECONDS_IN_MONTH * 12
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyBlurEffect(image: #imageLiteral(resourceName: "Gradient"))
        if user != nil, mode != nil {
            if mode == PhotoLibChallengeVC.PHOTO_LIB_MODE {
                setupPhotoLib()
            }
            else if mode == PhotoLibChallengeVC.CHALLENGE_MODE {
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
        self.title = "Photo Library"
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
        self.title = "Challenges"
        challenges = [PhotoLibChallengeVC.TAKE_PIC_FROM_RECENT, PhotoLibChallengeVC.TAKE_PIC_FROM_WEEK, PhotoLibChallengeVC.TAKE_PIC_FROM_MONTH, PhotoLibChallengeVC.TAKE_PIC_FROM_YEAR]
        challengesDictionary = [PhotoLibChallengeVC.TAKE_PIC_FROM_RECENT : [], PhotoLibChallengeVC.TAKE_PIC_FROM_WEEK : [], PhotoLibChallengeVC.TAKE_PIC_FROM_MONTH : [], PhotoLibChallengeVC.TAKE_PIC_FROM_YEAR : []]
        self.tableView.allowsSelection = false
        let ref = Database.database().reference()
        let currentDate = Date()
//        FBDatabase.getPictureData(for_user: user, ref: ref, with_completion: {(pictureDataList) in
//            ref.removeAllObservers()
//            for pictureData in pictureDataList {
//                let challengeCategory = self.getPicChallengeCategory(pictureData: pictureData, currentDate: currentDate)
//                self.challengesDictionary[challengeCategory]?.append(pictureData)
//            }
//            self.tableView.reloadData()
//        })
        
        FBDatabase.getAllPictureData(count: 50, ref: ref) { (rawPictureDataArray) in
            if rawPictureDataArray != nil {

                for rawPictureData in rawPictureDataArray! {

                    FBDatabase.getPictureData(id: rawPictureData.id, ref: ref, with_completion: { (pictureData) in
                        let challengeCategory = self.getPicChallengeCategory(pictureData: pictureData!, currentDate: currentDate)
                        self.challengesDictionary[challengeCategory]?.append(pictureData!)
                        if rawPictureData.id == rawPictureDataArray?.last?.id {
                            self.tableView.reloadData()
                        }
                    })
                }
            }
        }*/
        FBDatabase.getRootPictureData(ref: ref, with_completion: {(pictureDataList) in
            ref.removeAllObservers()
            for pictureData in pictureDataList {
                let challengeCategory = self.getPicChallengeCategory(pictureData: pictureData, currentDate: currentDate)
                self.challengesDictionary[challengeCategory]?.append(pictureData)
            }
            self.tableView.reloadData()
        })
    }
    
    // MARK: - ImageButton Methods
    func imageButtonPressed(image: UIImage, pictureData: PictureData) {
        print("Image Pressed")
        if mode == PhotoLibChallengeVC.CHALLENGE_MODE {
            let alert = UIAlertController(title: nil, message: "What would you like to do with this challenge?", preferredStyle: .actionSheet)
            let withNav = UIAlertAction(title: "Start Navigation", style: .default, handler: {(action) in
                self.addChallengeToUser(pictureData: pictureData)
                // TODO: Start navigation
                self.navigationController?.dismiss(animated: true, completion: nil)
            })
            let withoutNav = UIAlertAction(title: "Make active challenge without navigation", style: .default, handler: {(action) in
                self.addChallengeToUser(pictureData: pictureData)
                self.navigationController?.dismiss(animated: true, completion: nil)
            })
            let viewChallenge = UIAlertAction(title: "View this challenge", style: .default, handler: {(action) in
                self.performSegue(withIdentifier: "ViewChallengeSegue", sender: [pictureData, image])
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(withNav)
            alert.addAction(withoutNav)
            alert.addAction(viewChallenge)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
        else if mode == PhotoLibChallengeVC.PHOTO_LIB_MODE {
            //self.performSegue(withIdentifier: "PhotoSegue", sender: [pictureData, image])
            
            self.performSegue(withIdentifier: "ViewChallengeSegue", sender: [pictureData, image])
        }
    }
    
    /*
     Gets the time difference between now and
     when the picture was taken. Returns a constant
     representing what type of challenge category the pic
     falls into
    */
    private func getPicChallengeCategory(pictureData: PictureData, currentDate: Date) -> String {
        //let pictureDate = DateGetter.getDateFromString(string: pictureData.time)
        let dateDiffSec = Int(abs(TimeInterval(pictureData.time)! - currentDate.timeIntervalSince1970))
        //let dateDiffSec = Int(abs(pictureDate.timeIntervalSince(currentDate)))
        if dateDiffSec >= PhotoLibChallengeVC.SECONDS_IN_YEAR {
            return PhotoLibChallengeVC.TAKE_PIC_FROM_YEAR
        }
        else if dateDiffSec >= PhotoLibChallengeVC.SECONDS_IN_MONTH {
            return PhotoLibChallengeVC.TAKE_PIC_FROM_MONTH
        }
        else if dateDiffSec >= PhotoLibChallengeVC.SECONDS_IN_WEEK {
            return PhotoLibChallengeVC.TAKE_PIC_FROM_WEEK
        }
        else {
            return PhotoLibChallengeVC.TAKE_PIC_FROM_RECENT
        }
    }
    
    private func addChallengeToUser(pictureData: PictureData) {
        let challengeCategory = getPicChallengeCategory(pictureData: pictureData, currentDate: Date())
        var points = 0
        if challengeCategory == PhotoLibChallengeVC.TAKE_PIC_FROM_WEEK {
            points = PhotoLibChallengeVC.CHALLENGE_WEEK_POINTS
        }
        else if challengeCategory == PhotoLibChallengeVC.TAKE_PIC_FROM_MONTH {
            points = PhotoLibChallengeVC.CHALLENGE_MONTH_POINTS
        }
        else if challengeCategory == PhotoLibChallengeVC.TAKE_PIC_FROM_YEAR {
            points = PhotoLibChallengeVC.CHALLENGE_YEAR_POINTS
        }
        else if challengeCategory == PhotoLibChallengeVC.TAKE_PIC_FROM_RECENT {
            points = PhotoLibChallengeVC.CHALLENGE_RECENT_POINTS
        }
        self.user.activeChallengeID = pictureData.id
        self.user.activeChallengePoints = points.description
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
        
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.white
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.backgroundColor = UIColor.clear
        
        let label = UILabel(frame: headerView.frame)
        label.font.withSize(30)
        if mode == PhotoLibChallengeVC.CHALLENGE_MODE {
            label.text = self.challenges[section]
        }
        else if mode == PhotoLibChallengeVC.PHOTO_LIB_MODE {
            label.text = self.locations[section]
        }
        label.textColor = UIColor.white
        label.textAlignment = .center
        headerView.addSubview(label)
        
        return headerView
        
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
        
        if segueID == PhotoLibChallengeVC.VIEW_CHALLENGE_SEGUE {
            let nav = segue.destination as! UINavigationController
            let destination = nav.topViewController as! ChallengeViewVC
            let infoArray = sender as! [Any]
            let pictureData = infoArray[PhotoLibChallengeVC.PHOTO_SEGUE_PICTURE_DATA_INDEX] as! PictureData
            let picture = infoArray[PhotoLibChallengeVC.PHOTO_SEGUE_PICTURE_INDEX] as! UIImage
            destination.pictureData = pictureData
            destination.image = picture
            print("Segue Done")
        }
    }
    
    
}

