//
//  MapVC.swift
//  reCap
//
//  Created by Jackson Delametter on 2/4/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import UIKit
import Mapbox

class MapVC: UIViewController, MGLMapViewDelegate {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

    }
    



    func setupMap() {
        
        let mapView = MGLMapView(frame: view.bounds)
        mapView.delegate = self
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.showsUserLocation = true
        
        mapView.styleURL = MGLStyle.outdoorsStyleURL()
        
        
        view.addSubview(mapView)
        
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        
        let user = mapView.userLocation?.coordinate
        mapView.setCenter(user!, zoomLevel: 2, direction: 0, animated: true)
        let camera = MGLMapCamera(lookingAtCenter: user!, fromDistance: 3000, pitch: 0, heading: 0)
        
        let when = DispatchTime.now() + 0.5 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Animate the camera movement over 5 seconds.
            mapView.setCamera(camera, withDuration: 3, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
            
        }
        
        
    }

}
