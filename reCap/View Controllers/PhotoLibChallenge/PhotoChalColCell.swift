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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        //Attempting to add shadow for 3D effect
        self.contentView.layer.borderWidth = 2.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 5.0)
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 0.9
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath

    }

    
    func setImageViewDelegate(delegate: ImageButtonDelegate) {
        self.delegate = delegate
    }
    @IBAction func imageButtonPressed(_ sender: Any) {
        delegate.imageButtonPressed(image: imageView.image!, pictureData: pictureData)
    }
}
