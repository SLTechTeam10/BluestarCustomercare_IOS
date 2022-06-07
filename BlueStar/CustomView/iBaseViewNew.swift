//
//  iBaseViewNew.swift
//  BlueStar
//
//  Created by Tejas.kutal on 15/11/18.
//  Copyright © 2018 BlueStar. All rights reserved.
//

import UIKit

class iBaseViewNew: UIView {

    @IBOutlet weak var btnCustomerID: UIButton!
    @IBOutlet weak var infoImageView: UIImageView!
    
    override func awakeFromNib(){
        
//        self.containerView.layer.borderColor = UIColor(netHex:0xDEDFE0).cgColor
//        self.label.backgroundColor = UIColor(netHex:0xDEDFE0)
//        self.containerView.layer.cornerRadius = 3.0
//        self.containerView.layer.borderWidth = 1.0
//
//        iBaseButton.layer.borderWidth = 1.0
//        iBaseButton.layer.borderColor = UIColor(netHex: 0x246cb0).cgColor
//        iBaseButton.layer.cornerRadius = 5.0
        
        infoImageView.image = UIImage(named: IMG_Info)
//        var placeholder = "Customer ID"
//        var myMutableString = NSMutableAttributedString()
//        myMutableString = NSMutableAttributedString(string:"Customer ID" as String, attributes: [NSForegroundColorAttributeName: UIColor(netHex:0x000000)])
//        myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: fontQuicksandBookBoldRegular, size: 16)!, range: NSRange(location:0,length:placeholder.characters.count))
//        //        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSRange(location:loc-1,length:1))
//        iBaseTextField.attributedPlaceholder = myMutableString
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
