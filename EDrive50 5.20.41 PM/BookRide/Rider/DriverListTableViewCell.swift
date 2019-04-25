//
//  DriverListTableViewCell.swift
//  edrive50
//
//  Created by Suuba Magai on 2019-04-20.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit

class DriverListTableViewCell: UITableViewCell {

    @IBOutlet weak var DriverNameText: UILabel!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
