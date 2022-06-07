//
//  OptionsListTableViewCell.swift
//  Blue Star
//
//  Created by Ankush on 14/03/17.
//  Copyright © 2017 BlueStar. All rights reserved.
//

import UIKit

class OptionsListTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    
    // MARK: - View Life Cycle Methods
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }

}
