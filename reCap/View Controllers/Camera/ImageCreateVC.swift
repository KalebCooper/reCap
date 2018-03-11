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

class ImageCreateVC: UIViewController {
    
    var image: UIImage?
    var lat: Double?
    var long: Double?
    var location: String?
    var isAtChallengeLocation: Bool!
    var user: User!
    
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
        let currentDate = Date()
        let stringPictureDate = DateGetter.getStringFromDate(date: currentDate)
        let pictureData = PictureData(name: self.titleOutlet.text, description: self.descriptionOutlet.text!, gpsCoordinates: [self.lat!, self.long!], orientation: PictureData.ORIENTATION_PORTRAIT, owner: self.user.id, time: stringPictureDate, locationName: self.locationNameOutlet.text!, id: PictureData.createPictureDataID())
        self.user.pictures.append(pictureData.id)
        if self.isAtChallengeLocation {
            // If the user took the picture at the challenge coordinates
            self.user.points = self.user.points + Int(self.user.activeChallengePoints)!
            print("User earned \(self.user.activeChallengePoints) points")
        }
        FBDatabase.addPicture(image: self.image!, pictureData: pictureData, with_completion: {(error) in
            if let actualError = error {
                // There was an error
                print(actualError)
            }
            else {
                // No error
                print("Added picture for user in ImageCreateVC")
                FBDatabase.addUpdatePictureData(pictureData: pictureData, with_completion: {(error) in
                    if let actualError = error {
                        // Error
                        print(actualError)
                    }
                    else {
                        // No error
                        print("Added picture data for user in ImageCreateVC")
                        self.navigationController?.setToolbarHidden(true, animated: true)
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                })
                FBDatabase.addUpdateUser(user: self.user, with_completion: {(error) in
                    if let actualError = error {
                        print(actualError)
                    }
                    else {
                        print("Updated user in ImageCreate VC")
                    }
                })
            }
        })
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

