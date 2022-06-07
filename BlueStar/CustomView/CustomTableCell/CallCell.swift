//
//  CallCell.swift
//  Blue Star
//
//  Created by Kamlesh on 11/24/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit

class CallCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
     @IBAction func mobileNumberButtonAction(_ sender: UIButton) {
        var phone = "+97144576728"
        if sender.tag == 1 {
            phone = "+911244094100"
        }else if sender.tag == 2{
            phone = "+913322134100"
        }else if sender.tag == 3{
            phone = "+912266684229"
        }else if sender.tag == 4{
            phone = "+914442444100"
        }else if sender.tag == 5{
            phone = "+97144576728"
        }
        if let phoneCallURL:URL = URL(string: "tel://\(phone)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
            }
        }
    }
    
}
