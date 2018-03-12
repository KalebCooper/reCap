//
//  Extensions.swift
//  reCap
//
//  Created by Kaleb Cooper on 2/8/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import Foundation
import UIKit


extension Double
{
    func truncate(places : Int)-> Double
    {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}

extension String
{
    static func convertGPSCoordinatesToOutput(coordinates: [Double]) -> String {
        
        let lat = coordinates[0]
        var latString: String
        let long = coordinates[1]
        var longString: String
        
        if lat > 0 {
            latString = "\(lat)°N"
        } else {
            latString = "\(lat)°S"
        }
        
        if long > 0 {
            longString = "\(long)°E"
        }
        else {
            longString = "\(long)°W"
        }
        
        let returnString = latString + " , " + longString
        return returnString
        
    }
}


extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
