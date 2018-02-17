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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
