//
//  ImageButtonDelegate.swift
//  reCap
//
//  Created by Jackson Delametter on 2/24/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import Foundation
import UIKit

protocol ImageButtonDelegate {
    func imageButtonPressed(image: UIImage, pictureData: PictureData)
}
