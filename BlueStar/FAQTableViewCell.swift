//
//  FAQTableViewCell.swift
//  BlueStar
//
//  Created by tarun.kapil on 05/08/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit

class FAQTableViewCell: UITableViewCell {

    @IBOutlet weak var FAQLabel: UILabel!
    @IBOutlet weak var bottomLineLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
