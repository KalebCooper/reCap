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

