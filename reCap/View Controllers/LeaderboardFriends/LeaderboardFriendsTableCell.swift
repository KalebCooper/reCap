//
//  LeaderboardFriendsTableCell.swift
//  reCap
//
//  Created by Jackson Delametter on 2/13/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import UIKit

class LeaderboardFriendsTableCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var pointsOutlet: UILabel!
    @IBOutlet weak var usernameOutlet: UILabel!
    @IBOutlet weak var fullNameOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imageOutlet.layer.borderWidth = 1
        self.imageOutlet.layer.borderColor = UIColor.white.cgColor
        self.imageOutlet.layer.cornerRadius = self.imageOutlet.layer.frame.width / 2
        self.imageOutlet.layer.masksToBounds = false
        self.imageOutlet.clipsToBounds = true
        self.imageOutlet.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
