//
//  TableCell.swift
//  reCap
//
//  Created by Jackson Delametter on 2/6/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import Foundation
import UIKit

class PhotoChallengeTableCell: UITableViewCell {
    
    @IBOutlet weak var pictureCollection: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /*
     Sends two protocols as parameters of the
     function, sets the delegate and data
     source for pictureCollection
     */
    func setPictureCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forSection section: Int) {
        
        pictureCollection.delegate = dataSourceDelegate
        pictureCollection.dataSource = dataSourceDelegate
        pictureCollection.tag = section
        pictureCollection.reloadData()
    }
    
}
