//
//  PhotoLibChallengeVC.swift
//  reCap
//
//  Created by Jackson Delametter on 2/6/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import UIKit
import Firebase

class PhotoLibChallengeVC: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let sections = ["13.5", "16.3"]
    let fakeData = [["Item1", "Item2", "Item3"], ["Item1", "Item2"]]
    
    // MARK: - Properties
    var locations: [String]!
    var locationDictionary: [String : [PictureData]]!
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        if user != nil {
            // User is valid
            setup()
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
    
    // MARK: - Outlet Action Methods
    
    
    @IBAction func backPressed(_ sender: Any) {
        print("Back Pressed")
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Setup Methods
    
    private func setup() {
        locations = []
        locationDictionary = [:]
        //let cell = UINib(nibName: "TableCell", bundle: nil)
        //self.tableView.register(cell, forCellReuseIdentifier: "CustomCell")
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
            }
        })
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return locations.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let location = locations[section]
        return locationDictionary[location]!.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return locations[section]
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! PhotoChallengeTableCell
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let tableCell = cell as! PhotoChallengeTableCell
        tableCell.setPictureCollectionViewDataSourceDelegate(dataSourceDelegate: self, forSection: indexPath.section)
    }
    
    // MARK: - Collection View Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fakeData[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCell", for: indexPath)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
