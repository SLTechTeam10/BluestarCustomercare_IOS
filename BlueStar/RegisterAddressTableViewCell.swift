//
//  RegisterAddressTableViewCell.swift
//  BlueStar
//
//  Created by aditya.chitaliya on 16/11/18.
//  Copyright © 2018 BlueStar. All rights reserved.
//

import UIKit

class RegisterAddressTableViewCell: UITableViewCell {

    @IBOutlet weak var addressBgView: UIView!
    @IBOutlet weak var addressLine1Label: UILabel!
    @IBOutlet weak var addressLine2Label: UILabel!
    @IBOutlet weak var addressLine3Label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
