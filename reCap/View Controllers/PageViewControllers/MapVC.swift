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
        mapView.setCenter(user!, zoomLevel: 2, direction: 0, animated: false)
        let camera = MGLMapCamera(lookingAtCenter: user!, fromDistance: 3000, pitch: 0, heading: 0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            // Animate the camera movement over 5 seconds.
            mapView.setCamera(camera, withDuration: 3, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
            
        })
        
        
        
    }

}
