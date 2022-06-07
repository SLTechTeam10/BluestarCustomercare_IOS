//
//  FollowupPopupViewController.swift
//  BlueStar
//
//  Created by tarun.kapil on 03/08/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit

class FollowupPopupViewController: UIViewController {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var ticketAlreadyGeneratedLabel: UILabel!
    @IBOutlet weak var generateTicketButton: UIButton!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var followupButton: UIButton!
    @IBOutlet weak var closePopupButton: UIButton!
    
    var isComingFromReg : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popupView.layer.cornerRadius = 12
        ticketAlreadyGeneratedLabel.textColor = UIColor(netHex: 0x666666)
        orLabel.textColor = UIColor(netHex: 0x666666)
    }
    
    override func viewDidLayoutSubviews() {
        generateTicketButton.setPreferences()
        followupButton.setPreferences()
    }

    @IBAction func generateTicketButtonAction(_ sender: AnyObject) {
        
        self.showPlaceHolderView()
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
        let nc = NotificationCenter.default
       // nc.post(name: Notification.Name(rawValue: "generateNewTicket"), object: nil)
    
        if let isComingFrom = UserDefaults.standard.value(forKey: "Register"){
            nc.post(name: Notification.Name(rawValue: "GenNewBookTicket"), object: nil)
        }
        else
        {
            nc.post(name: Notification.Name(rawValue: "presentNatureOfProblemView"), object: nil)
        }
//        nc.post(name: Notification.Name(rawValue: "presentNatureOfProblemView"), object: nil)
        self.hidePlaceHolderView()
        //self.presentedViewController?.dismiss(animated: true, completion: { _ in })
    }
    
    @IBAction func followupButtonAction(_ sender: AnyObject) {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name(rawValue: "followUpTicket"), object: nil)
    }

    @IBAction func closePopupButtonAction(_ sender: AnyObject) {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    func showPlaceHolderView() {
        
        let controller:UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "PlaceHolderView")
        controller.view.frame = self.view.bounds;
        controller.view.tag = 100
        controller.view.backgroundColor = UIColor(white: 0.1, alpha: 0.65)
        controller.willMove(toParent: self)
        self.view.addSubview(controller.view)
        self.addChild(controller)
        controller.didMove(toParent: self)
    }
    
    func hidePlaceHolderView() {
        
        if let viewWithTag = self.view.viewWithTag(100) {
            
            viewWithTag.removeFromSuperview()
        }
    }

}
