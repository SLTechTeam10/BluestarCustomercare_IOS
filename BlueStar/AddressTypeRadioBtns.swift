//
//  AddressTypeRadioBtns.swift
//  BlueStar
//
//  Created by Tejas.kutal on 27/10/18.
//  Copyright © 2018 BlueStar. All rights reserved.
//

import UIKit

class AddressTypeRadioBtns: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var btnResidential: UIButton!
    @IBOutlet weak var btnCommercial: UIButton!
    
    let img_radio_button_on = UIImage(named: "radio_button_on") as! UIImage
    let img_radio_button_off = UIImage(named: "radio_button_off") as! UIImage

    override func awakeFromNib(){
        btnResidential .setBackgroundImage(img_radio_button_off, for: .normal)
        btnResidential .setBackgroundImage(img_radio_button_on , for: .selected)
        
        btnCommercial .setBackgroundImage(img_radio_button_off, for: .normal)
        btnCommercial .setBackgroundImage(img_radio_button_on , for: .selected)
    }

    @IBAction func radioBtnClicked(_ sender: UIButton) {
        if sender.tag == 1 {
            btnResidential.isSelected = true
            btnCommercial.isSelected = false
        } else {
            btnResidential.isSelected = false
            btnCommercial.isSelected = true
        }
    }
}
