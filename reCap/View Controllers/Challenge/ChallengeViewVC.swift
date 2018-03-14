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

class ChallengeViewVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ImageButtonDelegate {
    
    
    
    var image: UIImage!
    var pictureData: PictureData!
    
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
        
        imageOutlet.hero.id = "imageID"
        imageOutlet.image = image
        locationOutlet.text = String.convertGPSCoordinatesToOutput(coordinates: pictureData.gpsCoordinates)
        let coordinates = CLLocationCoordinate2D(latitude: pictureData.gpsCoordinates[0], longitude: pictureData.gpsCoordinates[1])
        Locator.location(fromCoordinates: coordinates, using: .apple, onSuccess: { places in
            print(places)
            self.locationNameOutlet.text = "\(places[0])"
        }) { err in
            print(err)
        }
        titleOutlet.text = pictureData.name
        descriptionOutlet.text = pictureData.description
        let ref = Database.database().reference()
        FBDatabase.getPictureData(in_group: "1054C096E512441B84D91ED1392EDE13", ref: ref, with_completion: {(data) in
            
        })
        // Do any additional setup after loading the view.
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
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Collection View Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let collectionViewTag = collectionView.tag
//        if mode == PhotoLibChallengeVC.PHOTO_LIB_MODE {
//            let location = locations[collectionViewTag]
//            return (locationDictionary[location]?.count)!
//        }
//        else if mode == PhotoLibChallengeVC.CHALLENGE_MODE {
//            let challenge = challenges[collectionViewTag]
//            return (challengesDictionary[challenge]?.count)!
//        }
//        else {
//            return 0
//        }
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCell", for: indexPath) as! PhotoChalColCell
        cell.setImageViewDelegate(delegate: self)
        let index = collectionView.tag
        let row = indexPath.row
        var pictureData: PictureData?
        
        
//        if mode == PhotoLibChallengeVC.PHOTO_LIB_MODE {
//            let location = locations[index]
//            let locationDataArray = locationDictionary[location]
//            pictureData = locationDataArray![row]
//            cell.pictureData = pictureData
//        }
//        else if (mode == PhotoLibChallengeVC.CHALLENGE_MODE) || (mode == PhotoLibChallengeVC.ACTIVE_CHALLENGE_MODE) {
//            let challenge = challenges[index]
//            let challengeDataArray = challengesDictionary[challenge]
//            pictureData = challengeDataArray![row]
//            cell.pictureData = pictureData
//        }
        
        
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
    
    
    
    
    // MARK: - ImageButton Methods
    func imageButtonPressed(image: UIImage, pictureData: PictureData) {
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
