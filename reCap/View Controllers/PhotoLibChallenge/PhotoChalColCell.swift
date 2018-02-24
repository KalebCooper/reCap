//
//  PhotoChalColCell.swift
//  reCap
//
//  Created by Jackson Delametter on 2/21/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import UIKit

class PhotoChalColCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageButton: UIButton!
    
    // MARK: - Properties
    var pictureData: PictureData!
    private var delegate: ImageButtonDelegate!
    
    func setImageViewDelegate(delegate: ImageButtonDelegate) {
        self.delegate = delegate
    }
    @IBAction func imageButtonPressed(_ sender: Any) {
        delegate.imageButtonPressed(image: imageView.image!, pictureData: pictureData)
    }
}
