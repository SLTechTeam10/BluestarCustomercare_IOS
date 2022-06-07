//
//  videoCellTableViewCell.swift
//  BlueStarCustomerCare
//
//  Created by aditya.chitaliya on 28/09/18.
//  Copyright © 2018 aditya.chitaliya. All rights reserved.
//

import UIKit

class videoCellTableViewCell: UITableViewCell {

    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var btnPlayVideo: UIButton!
    @IBOutlet weak var LblVideoName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
