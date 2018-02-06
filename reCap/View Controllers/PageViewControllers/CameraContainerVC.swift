//
//  CameraContainerVC.swift
//  reCap
//
//  Created by Kaleb Cooper on 2/6/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import UIKit

class CameraContainerVC: UIViewController {

    @IBOutlet weak var cameraButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupShadows()
        configureButton()
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func configureButton() {
        
        cameraButton.layer.borderColor = UIColor.white.cgColor
        cameraButton.layer.borderWidth = 2
        cameraButton.layer.cornerRadius = 40
        
    }
    func setupShadows() {
        let topShadow = EdgeShadowLayer(forView: view, edge: .Top)
        view.layer.insertSublayer(topShadow, at: 1)
        
        let bottomShadow = EdgeShadowLayer(forView: view, edge: .Bottom)
        view.layer.insertSublayer(bottomShadow, at: 1)
    }

    
}

