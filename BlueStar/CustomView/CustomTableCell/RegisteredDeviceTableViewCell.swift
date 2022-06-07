//
//  RegisteredDeviceTableViewCell.swift
//  BlueStar
//
//  Created by aditya.chitaliya on 23/10/18.
//  Copyright © 2018 BlueStar. All rights reserved.
//

import UIKit

class RegisteredDeviceTableViewCell: UITableViewCell {

    @IBOutlet weak var LblDeviceName: UILabel!
    @IBOutlet weak var LblRegNo: UILabel!
    @IBOutlet weak var LblModelNo: UILabel!
    @IBOutlet weak var LblSrNo: UILabel!
    @IBOutlet weak var equipmentImage: UIImageView!
    
    @IBOutlet weak var LblSerialNo: UILabel!
    
    @IBOutlet weak var LblModelName: UILabel!
    @IBOutlet weak var saperatorView: UILabel!
    @IBOutlet weak var leftImageView: UIView!
    @IBOutlet weak var lblStaticObligation: UILabel!
    @IBOutlet weak var lblObligationName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
