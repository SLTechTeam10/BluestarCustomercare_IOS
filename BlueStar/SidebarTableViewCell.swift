//
//  SidebarTableViewCell.swift
//  BlueStar
//
//  Created by tarun.kapil on 04/08/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit

class SidebarTableViewCell: UITableViewCell {

    @IBOutlet weak var menuIconImageView: UIImageView!
    @IBOutlet weak var menuLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
