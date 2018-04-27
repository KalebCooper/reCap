//
//  ChallengeViewVC.swift
//  reCap
//
//  Created by Kaleb Cooper on 3/10/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Hero
import SwiftLocation
import CoreLocation
import Firebase
import RealmSwift

class ChallengeViewVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, ImageButtonDelegate {
    
    var image: UIImage!
    var pictureData: PictureData!
    var userData: UserData!
    var pictureArray: Results<PictureData>!
    var imageToPass: UIImage?
    var pictureDataToPass: PictureData?
    
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var locationOutlet: UILabel!
    @IBOutlet weak var locationNameOutlet: UILabel!
    @IBOutlet weak var titleOutlet: SkyFloatingLabelTextField!
    @IBOutlet weak var descriptionOutlet: SkyFloatingLabelTextField!
    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet var avoidingView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func donePressed(_ sender: Any) {
        
        self.navigationController?.setToolbarHidden(true, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View loaded")
        setupCollectionView()
        applyBlurEffect(image: image)
        
        
        self.navigationController?.toolbar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
        
        setupUI(index: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    
    func setupUI(index: Int) {
        
        
        let coordinatesToPass = [pictureArray[index].latitude, pictureArray[index].longitude]
        
        locationOutlet.text = String.convertGPSCoordinatesToOutput(coordinates: coordinatesToPass)
        let coordinates = CLLocationCoordinate2D(latitude: coordinatesToPass[0], longitude: coordinatesToPass[1])
        Locator.location(fromCoordinates: coordinates, using: .apple, onSuccess: { places in
            print(places)
            self.locationNameOutlet.text = "\(places[0])"
        }) { err in
            print(err)
        }
        titleOutlet.text = pictureArray[index].name
        descriptionOutlet.text = pictureArray[index].info
        
    }
    
    func applyBlurEffect(image: UIImage){
        let imageToBlur = CIImage(image: image)
        let blurfilter = CIFilter(name: "CIGaussianBlur")
        blurfilter?.setValue(imageToBlur, forKey: "inputImage")
        let resultImage = blurfilter?.value(forKey: "outputImage") as! CIImage
        let blurredImage = UIImage(ciImage: resultImage)
        self.imageBackground.image = blurredImage
        
    }
    
    func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        //self.pictureArray = []
        let groupID = pictureData.groupID!
        let realm = try! Realm()
        self.pictureArray = realm.objects(PictureData.self).filter("groupID = '\(groupID.description)'").sorted(byKeyPath: "time", ascending: false)
        
        /*for data in results {
            self.pictureArray.append(data)
        }*/
        self.collectionView.reloadData()
    }
    
    // MARK: - Collection View Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCell", for: indexPath) as! PhotoChalColCell
        cell.setImageViewDelegate(delegate: self)
        let row = indexPath.row
        let cellPictureData = pictureArray[row]
        //print(cellPictureData)
        cell.pictureData = cellPictureData
        FBDatabase.getPicture(pictureData: cellPictureData, with_progress: {(progress, total) in
            
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
    
    
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//
//        let totalCellWidth = CellWidth * CellCount
//        let totalSpacingWidth = CellSpacing * (CellCount - 1)
//
//        let leftInset = (collectionViewWidth - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
//        let rightInset = leftInset
//
//        return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
//    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        snapToCenter()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            snapToCenter()
        }
    }
    
    func snapToCenter() {
        let centerPoint = view.convert(view.center, to: collectionView)
        if let centerIndexPath = collectionView.indexPathForItem(at: centerPoint) {
            collectionView.scrollToItem(at: centerIndexPath, at: .centeredHorizontally, animated: true)
            setupUI(index: centerIndexPath.row)
        }
        
    }

    
    
    
    // MARK: - ImageButton Methods
    func imageButtonPressed(image: UIImage, pictureData: PictureData) {
        print("Image Pressed")
        let infoArray = [pictureData, image] as [Any]
        self.performSegue(withIdentifier: "PhotoSegue", sender: infoArray)
    }
    
    @IBAction func unwindSegue(segue:UIStoryboardSegue) {
        // Called when a photo is deleted
        let photoVC = segue.source as! PhotoVC
        let pictureIndex = self.pictureArray.index(of: photoVC.pictureData)
        //self.pictureArray.remove(at: pictureIndex!)
        self.collectionView.reloadData()
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let segueID = segue.identifier
        if segueID == "PhotoSegue" {
            let destination = segue.destination as! PhotoVC
            let infoArray = sender as! [Any]
            let pictureData = infoArray[0] as! PictureData
            let image = infoArray[1] as! UIImage
            destination.userData = self.userData
            destination.pictureData = pictureData
            destination.image = image
        }
    }
    
}




