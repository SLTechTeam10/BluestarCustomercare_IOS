//
//  HistoryTableViewCell.swift
//  BlueStar
//
//  Created by tarun.kapil on 11/08/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leftIconView: UIView!
    @IBOutlet weak var leftIconImageView: UIImageView!
    @IBOutlet weak var ticketNumberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusValueLabel: UILabel!
    @IBOutlet weak var buttonReminderFeedBack: UIButton!
    @IBOutlet weak var buttonShare: UIButton!
    @IBOutlet weak var buttonCancelTicket: UIButton!
    @IBOutlet weak var dealerNameLabel: UILabel!
    @IBOutlet weak var dealerContactLabel: UILabel!

    @IBOutlet weak var roundViewForImageView: UIView!
    var isFeedBack : Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        buttonReminderFeedBack.layer.cornerRadius = buttonReminderFeedBack.frame.size.height/2
        buttonShare.layer.cornerRadius = buttonShare.frame.size.height/2
        buttonCancelTicket.layer.cornerRadius = buttonCancelTicket.frame.size.height/2
        
//        dealerContactLabel.isUserInteractionEnabled = true // Remember to do this
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapDealerContactNumber))
//        dealerContactLabel.addGestureRecognizer(tap)
        tap.delegate = self
    }
    
    @objc func didTapDealerContactNumber(_ sender: UITapGestureRecognizer)
    {
        let contactNumber = dealerContactLabel.text!.trim() as String
        if contactNumber != ""{
            if let phoneCallURL:URL = URL(string: "tel://\(contactNumber)") {
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
                    application.openURL(phoneCallURL);
                }
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
