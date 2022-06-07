//
//  AddressView.swift
//  BlueStar
//
//  Created by tarun.kapil on 19/08/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit

class AddressView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var addressLine1Label: UILabel!
    @IBOutlet weak var addressLine2Label: UILabel!
    @IBOutlet weak var addressLine3Label: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var enableSwitch: UISwitch!
    @IBOutlet weak var BtnAddressActiveInactive: UIButton!
    @IBOutlet weak var customerID: UILabel!
    @IBOutlet weak var resConfigLabel: UILabel!
    @IBOutlet weak var resConfigHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var addressLineOneYConstraint: NSLayoutConstraint!
}
