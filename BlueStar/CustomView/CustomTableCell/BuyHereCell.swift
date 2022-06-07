//
//  BuyHereCell.swift
//  Blue Star
//
//  Created by Satish on 28/11/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit

class BuyHereCell: UITableViewCell {

    @IBOutlet weak var labelHERE: FRHyperLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        labelHERE.text = "Buy Online here"


        let handler = {
            (hyperLabel: FRHyperLabel?, substring: String?) -> Void in
           UIApplication.shared.openURL(URL(string:"https://www.bluestarindia.com")!)
        }

        labelHERE.setLinksForSubstrings(["here"], withLinkHandler: handler)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
