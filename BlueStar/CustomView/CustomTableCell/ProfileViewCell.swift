//
//  ProfileViewCell.swift
//  Blue Star
//
//  Created by Satish on 18/11/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit

class ProfileViewCell: UITableViewCell {
  var flag=0
    var isChecked : Bool = false
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var selectedTitleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var lastNameTextField: UITextField!
    //@IBOutlet weak var alternateMobileNoLabel: UILabel!
    @IBOutlet weak var alternateMobileNoTextField: UITextField!
    //@IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var primaryNoTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    //@IBOutlet weak var preferredTimeLabel: UILabel!
    @IBOutlet weak var preferredTimeStartTextField: UITextField!
    @IBOutlet weak var preferredTimeEndTextField: UITextField!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var buttonChooseProduct: UIButton!
    @IBOutlet weak var buttonInfoTime: UIButton!
    @IBOutlet weak var emailLabelTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var productListLabel: UILabel!
    @IBOutlet weak var selectProductDropDownTopConstratint: NSLayoutConstraint!
    @IBOutlet weak var alternateMobileNumberLabel: UILabel!

    @IBOutlet weak var PreferedTimeLabel: UILabel!

    @IBOutlet weak var prefredTimeFromTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var emailTextFieldTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var productListLabelTop: NSLayoutConstraint!
    @IBOutlet weak var buttonInfoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var preferedTimeToConstraint: NSLayoutConstraint!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var primaryNoBtn: UIButton!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var ageGroup: UITextField!
    
    
    @IBAction func addAlternateNumberTextField(_ sender: Any) {
        
        let checkedImage = UIImage(named: "check_box")! as UIImage
        let uncheckedImage = UIImage(named: "uncheck_box")! as UIImage
        
        // Post a notification
       
            isChecked = true
            primaryNoBtn.setImage(uncheckedImage, for: .normal)
            btn.setImage(checkedImage, for: .normal)
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "alternateNumber"), object: nil)
    }
    
    
    @IBAction func primaryNoCheckBox(_ sender: Any) {
        let checkedImage = UIImage(named: "check_box")! as UIImage
        let uncheckedImage = UIImage(named: "uncheck_box")! as UIImage
        isChecked=false
        primaryNoBtn.setImage(checkedImage, for: .normal)
        btn.setImage(uncheckedImage, for: .normal)
    }
    
    @IBOutlet weak var preferredTimeLabelTopConstraint: NSLayoutConstraint!
    var tokens = NSMutableArray()
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        doAdditionalViewSetup()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //MARK:
    //MARK:- Custom Methods
    func createBorder(_ textField: UITextField, bottomColor: String) -> CALayer {
        let border = CALayer()
        let width = CGFloat(1.0)
        if bottomColor == "grey" {
            border.borderColor = UIColor(netHex: 0xDEDFE0).cgColor
        } else if bottomColor == "blue" {
            border.borderColor = UIColor(netHex: 0x246cb0).cgColor
        }
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  UIScreen.main.applicationFrame.size.width-40, height: textField.frame.size.height)
        border.borderWidth = width
        return border
    }

    func doAdditionalViewSetup() {
        
        let loc1: Int = "Title ".characters.count
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string:"Title " as String, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(netHex:0x000000)]))
        myMutableString.addAttribute(NSAttributedString.Key.font, value:UIFont(name:fontQuicksandBookRegular, size: 18.0)!, range: NSRange(location:loc1-1,length:1))
        
        selectedTitleLabel.attributedText = myMutableString
        
        self.titleTextField.layer.addSublayer(createBorder(self.titleTextField, bottomColor: "grey"))
        self.titleTextField.layer.masksToBounds = true
        self.gender.layer.addSublayer(createBorder(self.gender, bottomColor: "grey"))
        self.gender.layer.masksToBounds = true
        self.ageGroup.layer.addSublayer(createBorder(self.ageGroup, bottomColor: "grey"))
        self.ageGroup.layer.masksToBounds = true
        
        self.firstNameTextField.layer.addSublayer(createBorder(self.firstNameTextField, bottomColor: "grey"))
        self.firstNameTextField.layer.masksToBounds = true
//        self.firstNameTextField.placeholder = "First Name *"
        
        let loc: Int = "First Name ".characters.count
        myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string:"First Name " as String, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(netHex:0x000000)]))
        myMutableString.addAttribute(NSAttributedString.Key.font, value:UIFont(name:fontQuicksandBookRegular, size: 18.0)!, range: NSRange(location:loc-1,length:1))
            
        firstNameLabel.attributedText = myMutableString
        
//        self.firstNameTextField.attributedPlaceholder = myMutableString
        
        self.lastNameTextField.layer.addSublayer(createBorder(self.lastNameTextField, bottomColor: "grey"))
        self.lastNameTextField.layer.masksToBounds = true
        
        let loc2: Int = "Last Name ".characters.count
         myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string:"Last Name " as String, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(netHex:0x000000)]))
    //    myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange(location:loc2-1,length:1))
        
        myMutableString.addAttribute(NSAttributedString.Key.font, value:UIFont(name:fontQuicksandBookRegular, size: 18.0)!, range: NSRange(location:loc2-1,length:1))

        lastNameLabel.attributedText = myMutableString
        
        self.primaryNoTextField.layer.addSublayer(createBorder(self.primaryNoTextField, bottomColor: "grey"))
        self.primaryNoTextField.layer.masksToBounds = true
        self.primaryNoTextField.isEnabled = false
        //self.primaryNoTextField.backgroundColor = UIColor(color.whitec)
        self.primaryNoTextField.textColor = UIColor(netHex:0x666666)

        self.alternateMobileNoTextField.font = UIFont(name: fontQuicksandBookRegular, size: 16)
        self.alternateMobileNoTextField.layer.addSublayer(createBorder(self.alternateMobileNoTextField, bottomColor: "grey"))
        self.alternateMobileNoTextField.layer.masksToBounds = true
        self.emailTextField.layer.addSublayer(createBorder(self.emailTextField, bottomColor: "grey"))
        self.emailTextField.layer.masksToBounds = true
        
//        self.emailTextField.text = userData["email"] as? String
        
//        self.preferredTimeLabel.textColor = UIColor(netHex: 0x666666)
//        let preferredTimeLabelTap = UITapGestureRecognizer(target: self, action: #selector(startEditingPreferredTime))
//        self.preferredTimeLabel.userInteractionEnabled = true
//        self.preferredTimeLabel.addGestureRecognizer(preferredTimeLabelTap)
//        self.preferredTimeHiphenLabel.textColor = UIColor(netHex: 0x666666)
        //self.preferredTimeStartTextField.layer.addSublayer(createBorder(self.preferredTimeStartTextField, bottomColor: "grey"))
        //self.preferredTimeStartTextField.layer.masksToBounds = true
//        if let _ = userData["prefferedTimingFrom"] {
//            let startTime = userData["prefferedTimingFrom"] as! String
//            
//            if startTime != "" {
//                dateFormatter.dateFormat = "HH:mm:ss"
//                let startDate = dateFormatter.dateFromString(startTime)
//                dateFormatter.dateFormat = "hh:mm a"
//                let newStartTime = dateFormatter.stringFromDate(startDate!)
//                self.preferredTimeStartTextField.text = newStartTime
//            }
//        }
       // self.preferredTimeEndTextField.layer.addSublayer(createBorder(self.preferredTimeEndTextField, bottomColor: "grey"))
        //self.preferredTimeEndTextField.layer.masksToBounds = true
//        if let _ = userData["prefferedTimingTo"] {
//            let endTime = userData["prefferedTimingTo"] as! String
//            
//            if endTime != "" {
//                dateFormatter.dateFormat = "HH:mm:ss"
//                let endDate = dateFormatter.dateFromString(endTime)
//                dateFormatter.dateFormat = "hh:mm a"
//                let newEndTime = dateFormatter.stringFromDate(endDate!)
//                self.preferredTimeEndTextField.text = newEndTime
//            }
//        }
        
//        self.firstNameTextField.delegate = self
//        self.lastNameTextField.delegate = self
//        self.alternateMobileNoTextField.delegate = self
//        self.emailTextField.delegate = self
//        self.preferredTimeStartTextField.delegate = self
//        self.preferredTimeEndTextField.delegate = self
//        self.delegate = self
//        if ProductBL.shareInstance.selectedProducts.count>0 {
//            self.tokens = ProductBL.shareInstance.selectedProducts
//            self.reloadTokenData()
//        }
//        self.buttonChooseProduct.addTarget(self, action: #selector(openProductList), forControlEvents:.TouchUpInside)
//        scrollView.addSubview(profileView)
//        scrollView.bringSubviewToFront(self.tokenField)
//        scrollView.setContentOffset(CGPointZero, animated:false)
//        scrollView.contentSize = CGSize(width: scrollView.bounds.size.width, height:self.tokenField.frame.origin.y+self.tokenField.frame.size.height+20)
        
        let loc3: Int = "Product List ".characters.count
        myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string:"Product List " as String, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(netHex:0x000000)]))
   //     myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange(location:loc3-1,length:1))
        myMutableString.addAttribute(NSAttributedString.Key.font, value:UIFont(name:fontQuicksandBookRegular, size: 18.0)!, range: NSRange(location:loc3-1,length:1))

        productLabel.attributedText = myMutableString
       // alternateMobileNoTextField.isHidden=true
        //emailLabelTopConstraint.constant=10
        //emailLabelTopConstraint.constant=28
       // selectProductDropDownTopConstratint.constant=8
    }
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
