//
//  ImageCreateVC.swift
//  reCap
//
//  Created by Kaleb Cooper on 2/9/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//
import UIKit
import IHKeyboardAvoiding
import SkyFloatingLabelTextField
import Firebase
import SwiftLocation
import CoreLocation
import FCAlertView
import RealmSwift

class ImageCreateVC: UIViewController {
    
    var image: UIImage?
    var lat: Double?
    var long: Double?
    var location: String?
    var isAtChallengeLocation: Bool!
    var previousPic: PictureData!
    var user: User!
    var userData: UserData!
    var challengePoints: String?
    
    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var locationOutlet: UILabel!
    @IBOutlet weak var locationNameOutlet: UILabel!
    @IBOutlet weak var titleOutlet: SkyFloatingLabelTextField!
    @IBOutlet weak var descriptionOutlet: SkyFloatingLabelTextField!
    
    @IBOutlet var avoidingView: UIView!
    
    @IBAction func cancelPressed(_ sender: Any) {
        
        self.navigationController?.setToolbarHidden(true, animated: true)
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    @IBAction func confirmPressed(_ sender: Any) {
        print("Confirmed Pressed")
        var isRoot: Bool!
        var groupID: String!
        let currentDate = Int((Date().timeIntervalSince1970)).description
        let pictureID = PictureData.createPictureDataID(userData: self.userData)
        let realm = try! Realm()
        
        FCAlertView.displayAlert(title: "Saving Picture...", message: "Adding your picture to the database...", buttonTitle: "", type: "progress", view: self)
        
        if self.isAtChallengeLocation {
            // If the user took the picture at the challenge coordinates, there is an active challenge
            try! realm.write {
                self.userData.points = self.user.points + Int(self.user.activeChallengePoints)!
                self.previousPic.isMostRecentPicture = false
            }
            isRoot = false
            groupID = self.previousPic.groupID
            print("User earned \(self.user.activeChallengePoints) points")
            self.challengePoints = self.user.activeChallengePoints
        }
        else {
            print("root picture")
            isRoot = true
            groupID = pictureID
        }
        let pictureData = PictureData(name: self.titleOutlet.text, info: self.descriptionOutlet.text!, owner: self.userData, latitude: self.lat!,longitude: self.long!,orientation: PictureData.ORIENTATION_PORTRAIT, time: currentDate, locationName: self.locationNameOutlet.text!, id: pictureID, isRootPicture: isRoot, groupID: groupID, isMostRecentPicture: true)
        try! realm.write {
            realm.add(pictureData)
            self.userData.pictures.append(pictureData)
            self.userData.activeChallengeID = ""
            self.userData.activeChallengePoints = 0
        }
        FBDatabase.addPicture(image: self.image!, pictureData: pictureData, with_completion: {(error) in
            if let actualError = error {
                // There was an error
                print(actualError)
            }
            else {
                // No error
                if self.isAtChallengeLocation {
                    self.displayChallengeComplete()
                }
                else {
                    self.displayPictureAdded(pictureData: pictureData)
                }
                self.navigationController?.setToolbarHidden(true, animated: true)
                self.navigationController?.popToRootViewController(animated: true)
            }
        })
    }
    
    private func displayChallengeComplete() {
        
        let challengePoints = self.challengePoints!
        let totalPoints: Int = self.user.points
        
        let titleString = "+\(challengePoints) Points"
        let subtitleString = "Good Job! You now have \(totalPoints) points!"
        
        FCAlertView.displayAlert(title: titleString, message: subtitleString, buttonTitle: "Hooray!", type: "success", view: self, blur: true)
        
    }
    
    private func displayPictureAdded(pictureData: PictureData) {
        
        let titleString = "Picture Added"
        let subtitleString = "Good Job! You now have added \(pictureData.name!) to your library"
        
        FCAlertView.displayAlert(title: titleString, message: subtitleString, buttonTitle: "Hooray!", type: "success", view: self, blur: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        
        let duration: TimeInterval = TimeInterval(exactly: 0.5)!
        imageView.hero.modifiers = [.forceNonFade, .duration(duration)]
        
        
        let coordinates = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
        Locator.location(fromCoordinates: coordinates, using: .apple, onSuccess: { places in
            print(places)
            self.locationNameOutlet.text = "\(places[0])"
        }) { err in
            print(err)
        }
        
        
        imageView.image = image
        self.locationOutlet.text = self.location
        
        applyBlurEffect(image: image!)
        
        KeyboardAvoiding.avoidingView = self.avoidingView
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    
    
    func applyBlurEffect(image: UIImage){
        let imageToBlur = CIImage(image: image)
        let blurfilter = CIFilter(name: "CIGaussianBlur")
        blurfilter?.setValue(imageToBlur, forKey: "inputImage")
        let resultImage = blurfilter?.value(forKey: "outputImage") as! CIImage
        let blurredImage = UIImage(ciImage: resultImage)
        self.imageBackground.image = blurredImage
        
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
