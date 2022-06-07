//
//  SafetyTipTableViewCell.swift
//  BlueStar
//
//  Created by tarun.kapil on 12/08/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit

class SafetyTipTableViewCell: UITableViewCell {

    @IBOutlet weak var safetyTipLabel: UILabel!
    @IBOutlet weak var borderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
