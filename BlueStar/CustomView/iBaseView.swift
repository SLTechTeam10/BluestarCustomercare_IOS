//
//  DropDownView.swift
//  Blue Star
//
//  Created by Satish on 14/11/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit

class iBaseView: UIView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var iBaseTextField: UITextField!
    
//    @IBOutlet weak var iBaseButton: UIButton!
    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var btnCustomerID: UIButton!
    
    override func awakeFromNib(){
        
        self.containerView.layer.borderColor = UIColor(netHex:0xDEDFE0).cgColor
        self.label.backgroundColor = UIColor(netHex:0xDEDFE0)
        self.containerView.layer.cornerRadius = 3.0
        self.containerView.layer.borderWidth = 1.0
 
//        iBaseButton.layer.borderWidth = 1.0
//        iBaseButton.layer.borderColor = UIColor(netHex: 0x246cb0).cgColor
//        iBaseButton.layer.cornerRadius = 5.0

        infoImageView.image = UIImage(named: IMG_Info)
        var placeholder = "Customer ID"
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string:"Customer ID" as String, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(netHex:0x000000)]))
         myMutableString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: fontQuicksandBookBoldRegular, size: 16)!, range: NSRange(location:0,length:placeholder.characters.count))
//        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSRange(location:loc-1,length:1))
        iBaseTextField.attributedPlaceholder = myMutableString
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
