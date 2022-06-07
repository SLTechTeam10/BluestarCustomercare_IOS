//
//  registerCompanyAddressCell.swift
//  BlueStar
//
//  Created by Tejas Kutal on 06/01/19.
//  Copyright © 2019 BlueStar. All rights reserved.
//

import UIKit

class registerCompanyAddressCell: UITableViewCell {
    @IBOutlet weak var addressBgView: UIView!
    @IBOutlet weak var companyNameLabel: UILabel!
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
