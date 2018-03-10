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

class ImageCreateVC: UIViewController {
    
    var image: UIImage?
    var lat: Double?
    var long: Double?
    var location: String?
    
    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var locationOutlet: UILabel!
    @IBOutlet weak var titleOutlet: SkyFloatingLabelTextField!
    @IBOutlet weak var descriptionOutlet: SkyFloatingLabelTextField!
    
    @IBOutlet var avoidingView: UIView!
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmPressed(_ sender: Any) {
        print("Confirmed Pressed")
        let ref = Database.database().reference()
        FBDatabase.getUser(with_id: FBDatabase.getSignedInUserID(), ref: ref, with_completion: {(user) in
            if let activeUser = user {
                print("Got user in ImageCreate VC")
                ref.removeAllObservers()
                let currentDate = Date()
                let stringPictureDate = DateGetter.getStringFromDate(date: currentDate)
                let pictureData = PictureData(name: self.titleOutlet.text, gpsCoordinates: [self.lat!, self.long!], orientation: PictureData.ORIENTATION_PORTRAIT, owner: activeUser.id, time: stringPictureDate, locationName: self.location!, id: PictureData.createPictureDataID())
                activeUser.pictures.append(pictureData.id)
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
                        FBDatabase.addUpdateUser(user: activeUser, with_completion: {(error) in
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
            else {
                print("Didn not get user in ImageCreate VC")
                // TODO: Handle error
            }
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        
        let duration: TimeInterval = TimeInterval(exactly: 0.5)!
        imageView.hero.modifiers = [.forceNonFade, .duration(duration)]
        
        imageView.image = image
        locationOutlet.text = self.location
        
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

