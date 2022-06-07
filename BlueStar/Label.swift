//
//  Label.swift
//  BlueStar
//
//  Created by tarun.kapil on 09/08/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit

//extension UILabel {
//
//
//     func drawText(in rect: CGRect) {
//        let insets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 0)
//        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
//    }
//}
@IBDesignable class PaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 0
    @IBInspectable var bottomInset: CGFloat = 0
    @IBInspectable var leftInset: CGFloat = 10.0
    @IBInspectable var rightInset: CGFloat = 0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }  
}
