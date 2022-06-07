//
//  AboutUsCell.swift
//  Blue Star
//
//  Created by Kamlesh on 11/22/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit

class AboutUsCell: UITableViewCell {

    @IBOutlet weak var imageViewLogo: UIImageView!
    @IBOutlet weak var labelText: FRHyperLabel!
    @IBOutlet weak var topSpaceConstrain: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
