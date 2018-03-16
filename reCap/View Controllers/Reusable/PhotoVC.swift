//
//  PhotoVC.swift
//  reCap
//
//  Created by Jackson Delametter on 2/24/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import UIKit

class PhotoVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageBackground: UIImageView!
    
    
    // MARK: - Properties
    var image: UIImage!
    var pictureData: PictureData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setToolbarHidden(true, animated: true)
        if image != nil, pictureData != nil {
            applyBlurEffect(image: image)
            setup()
        }
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /*
     Initial setup
    */
    private func setup() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        imageView.image = image
        
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
     Edits photo
    */
    @IBAction func editPressed(_ sender: Any) {
    }
    
    /*
     Share photo on Facebook
    */
    @IBAction func sharePressed(_ sender: Any) {
    }
    
    /*
     Delete button was pressed
    */
    @IBAction func deletePressed(_ sender: Any) {
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
