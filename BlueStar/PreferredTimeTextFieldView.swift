//
//  PreferredTimeTextFieldView.swift
//  BlueStar
//
//  Created by tarun.kapil on 28/07/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit

class PreferredTimeTextFieldView: UIView {

    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var textFieldOne: UITextField!
    @IBOutlet weak var textFieldTwo: UITextField!
    @IBOutlet weak var preferredTimeLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var buttonInfoTime: UIButton!

    override func awakeFromNib(){
        preferredTimeLabel.text = "Preferred Time for Service"
//        var placeholder = "Preferred Time for Service"
//        var myMutableString = NSMutableAttributedString()
//        myMutableString = NSMutableAttributedString(string:"Preferred Time for Service" as String, attributes: [NSForegroundColorAttributeName: UIColor(netHex:0x000000)])
//        myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: fontQuicksandBookBoldRegular, size: 16)!, range: NSRange(location:0,length:placeholder.characters.count))
        //        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSRange(location:loc-1,length:1))
        //preferredTimeLabel.attributedPlaceholder = myMutableString
        preferredTimeLabel.font =  UIFont(name: fontQuicksandBookBoldRegular, size: 12.0)

    }

}
