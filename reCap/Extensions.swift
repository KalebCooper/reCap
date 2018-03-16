//
//  Extensions.swift
//  reCap
//
//  Created by Kaleb Cooper on 2/8/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import Foundation
import UIKit
import FCAlertView


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

extension Bool {
    
    static func checkIfTimeIs(between: Int, and: Int) -> Bool {
        
        let calendar = Calendar.current
        let now = Date()
        
        let date1 = calendar.date(bySettingHour: between, minute: 0, second: 0, of: now)!
        
        var date2 = Date()
        
        if and == 23 {
            date2 = calendar.date(bySettingHour: and, minute: 59, second: 59, of: now)!
        }
        else {
            date2 = calendar.date(bySettingHour: and, minute: 0, second: 0, of: now)!
        }
        
        
        
        if now >= date1 && now <= date2 {
            return true
        }
        else {
            return false
        }
        
    }
    
}

extension FCAlertView
{
    
    static func displayAlert(title: String, message: String, buttonTitle: String, type: String, view: UIViewController, blur: Bool = false) {
        let alert = FCAlertView()
        alert.dismissOnOutsideTouch = true
        alert.darkTheme = true
        alert.bounceAnimations = true
        
        if blur == true {
            alert.blurBackground = true
        }
        
        if type == "caution" {
            alert.makeAlertTypeCaution()
        }
        else if type == "warning" {
            alert.makeAlertTypeWarning()
        }
        else if type == "success" {
            alert.makeAlertTypeSuccess()
        }
        else if type == "progress" {
            alert.makeAlertTypeProgress()
            alert.blurBackground = true
            
            let when = DispatchTime.now() + 1 // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                alert.dismiss()
            }
        }
        
        let titleString = title
        let subtitleString = message
        
        alert.showAlert(inView: view,
                        withTitle: titleString,
                        withSubtitle: subtitleString,
                        withCustomImage: nil,
                        withDoneButtonTitle: buttonTitle,
                        andButtons: nil)
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


extension UIView{
    func rotateToDestination(from: Double, to: Double) {
        
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = NSNumber(value: from)
        rotation.toValue = NSNumber(value: to)
        rotation.duration = 0.25
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
        
        
    }
}


extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
