//
//  VisitCell.swift
//  Blue Star
//
//  Created by Satish on 23/11/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit


class VisitCell: UITableViewCell {

    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var labelSubtitle: FRHyperLabel!

    @IBOutlet weak var buttonEmail: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    @IBAction func emailButtonAction(sender: UIButton) {
//        
//        var url = ""
//        if sender.tag == 6 {
//            url = "coolingsolutions@bluestarindia.com"
//            let mailComposeViewController = configuredMailComposeViewController(url)
//            
//            if MFMailComposeViewController.canSendMail() {
//                self.present(mailComposeViewController, animated: true, completion: nil)
//            } else {
//             //   self.showSendMailErrorAlert()
//            }
//
//             UIApplication.sharedApplication().openURL(NSURL(string:url)!)
//        }else if sender.tag == 7{
//            url = "https://www.bluestarindia.com"
//             UIApplication.sharedApplication().openURL(NSURL(string:url)!)
//        }
//    }
    

}
