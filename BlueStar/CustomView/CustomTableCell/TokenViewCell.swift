//
//  TokenViewCell.swift
//  Blue Star
//
//  Created by Satish on 18/11/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


protocol MyProductTokenViewDelegate:class {
    func tokenViewTotalHeight(_ tokenViewSize:CGSize)
}

class TokenViewCell: UITableViewCell,ZFTokenFieldDataSource, ZFTokenFieldDelegate {

    @IBOutlet weak var tokenField: ZFTokenField!
    var tokens = NSMutableArray()
    var delegate: MyProductTokenViewDelegate?
    var controller : UIViewController?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reloadTokenData() {
        self.tokenField.delegate = self
        self.tokenField.dataSource = self
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
        crossButton.addTarget(self, action: #selector(tokenDeleteButtonPressed(_:)), for: .touchUpInside)
        let tokenlabel = tokeView.viewWithTag(2) as! UILabel
        let product = self.tokens.object(at: Int(index)) as! ProductData
        tokenlabel.text = product.productDisplayName
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
    
    @objc func tokenDeleteButtonPressed(_ tokenButton: UIButton) {
        
        let index = self.tokenField.index(ofTokenView: tokenButton.superview)
        if (index != UInt(NSNotFound)) {
            
            // OLD LOGIC
            if (TicketHistoryModel.shareInstance.tickets?.count)! > 0 {
                    //check if any added product status is running for service
                    let product = self.tokens.object(at: Int(index)) as! ProductData
                    let productInfo = TicketHistoryModel.shareInstance.productStatus(product.productId! as NSString)//filterContentForSearchText((data["productId"] as? String)!) as NSDictionary
                    if productInfo.allKeys.count>0 {
                        
                        let productStatus = productInfo["progressStatus"] as! String
                        
                        if (productStatus.trim().caseInsensitiveCompare(statusWorkCompleted) == ComparisonResult.orderedSame ||  productStatus.trim().caseInsensitiveCompare(statusClosed) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusCallCancelled) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusAppointmentFixedForWorkCompletion) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusCallOnHoldObligationDispute) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusCallOnHoldAwaitingCustomerClearance) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusCallAttendedPendingForMaterial) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusWorkStartedAtSite) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusWorkInProcess) == ComparisonResult.orderedSame) || (productStatus == "Cancelled"){
                            
                            removeTokenFromArray(Int(index))
                        }else{
                            //show alert
                            if controller != nil{
                                let message = "You cannot remove " + product.productDisplayName! + " as you have one or more open tickets against it."

                                DataManager.shareInstance.showAlert(controller!, title:"Warning", message:message)
                            }
                        }
                    }else{
                        removeTokenFromArray(Int(index))
                    }
                    
            }else{
                removeTokenFromArray(Int(index))
            }

        }
    }
    
    
    func tokenViewSize(forAllTokens tokenViewSize: CGSize){
        //print("token view size \(tokenViewSize)")
        //delegate?.tokenViewTotalHeight(tokenViewSize)
    }

    func removeTokenFromArray(_ atIndex: Int) {
        
        self.tokens.removeObject(at: Int(atIndex))
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name(rawValue: "updateProductSelection"), object: nil)
    }
}
