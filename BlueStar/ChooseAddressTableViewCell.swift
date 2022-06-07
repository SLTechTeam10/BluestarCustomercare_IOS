//
//  ChooseAddressTableViewCell.swift
//  BlueStar
//
//  Created by tarun.kapil on 23/09/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit

class ChooseAddressTableViewCell: UITableViewCell {

    @IBOutlet weak var addressBgView: UIView!
    @IBOutlet weak var addressLine1Label: UILabel!
    @IBOutlet weak var addressLine2Label: UILabel!
    @IBOutlet weak var addressLine3Label: UILabel!
   // @IBOutlet weak var enableSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
