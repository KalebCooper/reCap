//
//  PhotoVC.swift
//  reCap
//
//  Created by Jackson Delametter on 2/24/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import UIKit
import RealmSwift

class PhotoVC: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var deleteButton: UIButton!
    var mode: Int!
    static let PHOTO_LIB_MODE = 0
    static let CHALLENGE_MODE = 1
    
    // MARK: - Properties
    var image: UIImage!
    var selectedPictureData: PictureData!
    var nextPictureData: PictureData!
    
    var userData: UserData!
    private var realm: Realm!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setToolbarHidden(true, animated: true)
        self.realm = try! Realm()
        if image != nil, selectedPictureData != nil {
            applyBlurEffect(image: image)
            if self.mode == PhotoVC.PHOTO_LIB_MODE {
                // This is a user viewing their own picture
                self.deleteButton.isHidden = false
                self.deleteButton.isEnabled = true
            }
            else {
                self.deleteButton.isHidden = true
                self.deleteButton.isEnabled = false
            }
            setup()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /*
     Initial setup
    */
    private func setup() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 8.0
        imageView.image = image
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return imageView
    }
    
    func applyBlurEffect(image: UIImage){
        let imageToBlur = CIImage(image: image)
        let blurfilter = CIFilter(name: "CIGaussianBlur")
        blurfilter?.setValue(imageToBlur, forKey: "inputImage")
        let resultImage = blurfilter?.value(forKey: "outputImage") as! CIImage
        let blurredImage = UIImage(ciImage: resultImage)
        self.imageBackground.image = blurredImage
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Outlet Action Methods
    
    /*
     Delete button was pressed
    */
    @IBAction func deletePressed(_ sender: Any) {
        try! self.realm.write {
            let pictureIndex = self.userData.pictures.index(of: self.selectedPictureData)
            self.userData.pictures.remove(at: pictureIndex!)
            if self.nextPictureData != nil {
                // There is another picture in the timeline, set it as the most recent picture
                self.nextPictureData.isMostRecentPicture = true
            }
            let usersWithChallenge = realm.objects(UserData.self).filter("activeChallenge.id = '\(self.selectedPictureData.id.description)'")
            for user in usersWithChallenge {
                user.activeChallenge = nil
                user.activeChallengePoints = 0
            }
            FBDatabase.deletePicture(pictureData: self.selectedPictureData)
            self.realm.delete(self.selectedPictureData)
            self.performSegue(withIdentifier: "DeletedPicSegue", sender: nil)
        }
    }
    
    /*
     Back button was pressed
    */
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
     Activates navigation to go to
     the location where the picture was taken
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

