//
//  Button.swift
//  BlueStar
//
//  Created by tarun.kapil on 05/08/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit

extension UIButton {
    func setPreferences() {
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: 50)
        self.backgroundColor = UIColor(netHex:0x0672EB)
        self.layer.cornerRadius = 25
        self.titleLabel!.font = UIFont(name: fontQuicksandBookRegular, size: 20)
    }
}
