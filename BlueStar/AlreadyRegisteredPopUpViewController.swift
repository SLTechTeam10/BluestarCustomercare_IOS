//
//  AlreadyRegisteredPopUpViewController.swift
//  BlueStar
//
//  Created by tarun.kapil on 20/07/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit

class AlreadyRegisteredPopUpViewController: UIViewController {
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var registerAgainButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popupView.layer.cornerRadius = 12
        
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: okButton.frame.size.width, height: 1))
        lineView.backgroundColor = UIColor(netHex: 0xDEDFE0)
        let rightLineView = UIView(frame: CGRect(x: okButton.frame.size.width-1, y: 0, width: 1, height: okButton.frame.size.height))
        rightLineView.backgroundColor = UIColor(netHex: 0xDEDFE0)
        okButton.addSubview(lineView)
        okButton.addSubview(rightLineView)
        let registerLineView = UIView(frame: CGRect(x: 0, y: 0, width: okButton.frame.size.width, height: 1))
        registerLineView.backgroundColor = UIColor(netHex: 0xDEDFE0)
        registerAgainButton.addSubview(registerLineView)
        
        let path = UIBezierPath(roundedRect:okButton.bounds, byRoundingCorners:[.bottomLeft], cornerRadii: CGSize(width: 12, height: 12))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        okButton.layer.mask = maskLayer
        
        let registerPath = UIBezierPath(roundedRect:registerAgainButton.bounds, byRoundingCorners:[.bottomRight], cornerRadii: CGSize(width: 12, height: 12))
        let registerMaskLayer = CAShapeLayer()
        registerMaskLayer.path = registerPath.cgPath
        registerAgainButton.layer.mask = registerMaskLayer
        
        okButton.setTitleColor(UIColor(netHex: 0x0672EB), for: UIControl.State())
        registerAgainButton.setTitleColor(UIColor(netHex: 0x0672EB), for: UIControl.State())
    }
    
    @IBAction func okButtonAction(_ sender: AnyObject) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "AnswerSecurityQuestionView") as! AnswerSecurityQuestionViewController
        self.present(next, animated: true, completion: nil)
    }
    
    @IBAction func registerAgainButtonAction(_ sender: AnyObject) {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name(rawValue: "showRegistrationView"), object: nil)
    }

}
