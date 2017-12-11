//
//  LibraryTableViewCell.swift
//  sweatTimer
//
//  Created by Sam Parhizkar on 2017-11-26.
//  Copyright © 2017 Sam Parhizkar. All rights reserved.
//

import UIKit

class LibraryTableViewCell: UITableViewCell {

    @IBOutlet weak var workoutImage: UIImageView!
    @IBOutlet weak var workoutLabel: UILabel!
    @IBOutlet weak var workoutDetails: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
