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

class ChallengeViewVC: UIViewController {
    
    var image: UIImage!
    var pictureData: PictureData!
    
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var locationOutlet: UILabel!
    @IBOutlet weak var locationNameOutlet: UILabel!
    @IBOutlet weak var titleOutlet: SkyFloatingLabelTextField!
    @IBOutlet weak var descriptionOutlet: SkyFloatingLabelTextField!
    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet var avoidingView: UIView!
    
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
        applyBlurEffect(image: image)
        
        self.navigationController?.toolbar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
        
        imageOutlet.hero.id = "imageID"
        imageOutlet.image = image
        locationOutlet.text = pictureData.locationName
        let coordinates = CLLocationCoordinate2D(latitude: pictureData.gpsCoordinates[0], longitude: pictureData.gpsCoordinates[1])
        Locator.location(fromCoordinates: coordinates, using: .apple, onSuccess: { places in
            print(places)
            self.locationNameOutlet.text = "\(places[0])"
        }) { err in
            print(err)
        }
        titleOutlet.text = pictureData.name
        descriptionOutlet.text = pictureData.description
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
