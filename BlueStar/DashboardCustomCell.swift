//
//  DashboardCustomCell.swift
//  BlueStar
//
//  Created by tarun.kapil on 7/21/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit

class DashboardCustomCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var progressStatusDot: UILabel!
    @IBOutlet weak var progressStatusImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        progressStatusDot.layer.cornerRadius = progressStatusDot.frame.size.width/2
//        progressStatusDot.layer.masksToBounds = true
    }
}