//
//  ProductTokenView.swift
//  Blue Star
//
//  Created by Kamlesh on 11/11/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit

protocol ProductTokenViewDelegate:class {
    func tokenViewTotalHeight(_ tokenViewSize:CGSize)
}


class ProductTokenView: UIView,ZFTokenFieldDataSource, ZFTokenFieldDelegate {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var rightFirstImageView: UIImageView!
    @IBOutlet weak var tokenField: ZFTokenField!
    
    var delegate: ProductTokenViewDelegate?
    var tokens = NSMutableArray()
    
    override func awakeFromNib(){
        
    }
    

    func reloadTokeData() {
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
    

}
