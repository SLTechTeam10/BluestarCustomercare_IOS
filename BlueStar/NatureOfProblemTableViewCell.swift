//
//  NatureOfProblemTableViewCell.swift
//  Blue Star
//
//  Created by Aditya Chitaliya on 03/03/17.
//  Copyright © 2017 BlueStar. All rights reserved.
//

import UIKit

class NatureOfProblemTableViewCell: UITableViewCell {

    @IBOutlet weak var problemListImg: UIImageView!
    @IBOutlet weak var problemListLbl: UILabel!
    // MARK: - View Life Cycle Methods
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
}
