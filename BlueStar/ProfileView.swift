//
//  ProfileView.swift
//  BlueStar
//
//  Created by tarun.kapil on 18/08/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit

protocol ProfileProductTokenViewDelegate:class {
    func tokenViewTotalHeight(_ tokenViewSize:CGSize)
}


class ProfileView: UIView,ZFTokenFieldDataSource, ZFTokenFieldDelegate {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var alternateMobileNoLabel: UILabel!
    @IBOutlet weak var alternateMobileNoTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var preferredTimeLabel: UILabel!
    @IBOutlet weak var preferredTimeStartTextField: UITextField!
    @IBOutlet weak var preferredTimeEndTextField: UITextField!
    @IBOutlet weak var preferredTimeHiphenLabel: UILabel!
    
    @IBOutlet weak var buttonChooseProduct: UIButton!
    @IBOutlet weak var tokenField: ZFTokenField!
    var tokens = NSMutableArray()
    var delegate: ProfileProductTokenViewDelegate?
    
    override func awakeFromNib(){
        self.tokenField.delegate = self
        self.tokenField.dataSource = self
//        self.tokenField.textField.enabled = false;
    }

    func reloadTokenData() {
        self.tokenField.textField.isEnabled = false;
        self.tokenField.reloadData()
    }
    
    func lineHeightForToken(in tokenField: ZFTokenField!) -> CGFloat {
        return 34.0
    }
    
    func numberOfToken(in tokenField: ZFTokenField!) -> UInt {
        return UInt(self.tokens.count)
    }
    
    func tokenField(_ tokenField: ZFTokenField!, viewForTokenAt index: UInt) -> UIView! {
        
        let tokeView = Bundle.main.loadNibNamed("TokenView", owner: self, options: nil)?[0] as! UIView
        
        let crossButton = tokeView.viewWithTag(3) as! UIButton
        crossButton.addTarget(self, action: #selector(tokenCrossButtonPressed(_:)), for: .touchUpInside)
        let tokenlabel = tokeView.viewWithTag(2) as! UILabel
        let product = self.tokens.object(at: Int(index)) as! ProductData
        tokenlabel.text = product.productName
        let size = tokenlabel.sizeThatFits(CGSize(width: 1000, height: 33)) as CGSize
        tokeView.frame = CGRect(x: 0, y: 0, width: size.width+50, height: 33)
        if ((tokeView.frame.size.width > UIScreen.main.bounds.size.width) && tokeView.frame.origin.x >= 0) {
            tokeView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 33)
        }
        return tokeView
        
    }
    
    func tokenMarginInToken(in tokenField: ZFTokenField!) -> CGFloat {
        return 5
    }
    
    @objc func tokenCrossButtonPressed(_ tokenButton: UIButton) {
        let index = self.tokenField.index(ofTokenView: tokenButton.superview)
        if (index != UInt(NSNotFound)) {
            self.tokens.removeObject(at: Int(index))
            //self.tokenField.reloadData()
            // ProductBL.shareInstance.selectedProducts.removeObject(self.tokens.objectAtIndex(Int(index)))
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name(rawValue: "updateProductSelection"), object: nil)
        }
    }
    
    func tokenViewSize(forAllTokens tokenViewSize: CGSize){
        //print("token view size \(tokenViewSize)")
        delegate?.tokenViewTotalHeight(tokenViewSize)
    }
    
    /*
     @IBOutlet weak var questionLabel: UILabel!
     @IBOutlet weak var questionTextField: UITextField!
     @IBOutlet weak var questionDownArrowImageView: UIImageView!
     @IBOutlet weak var answerLabel: UILabel!
     @IBOutlet weak var answerTextField: UITextField!
     @IBOutlet weak var pinLabel: UILabel!
     @IBOutlet weak var pinTextField: UITextField!
     @IBOutlet weak var pinEyeImageView: UIImageView!
     */
    
}
