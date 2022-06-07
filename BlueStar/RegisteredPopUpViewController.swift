//
//  RegisteredPopUpViewController.swift
//  BlueStar
//
//  Created by tarun.kapil on 29/07/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class RegisteredPopUpViewController: UIViewController {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var buttonBorderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupView.layer.cornerRadius = 12
        
        let path = UIBezierPath(roundedRect:button.bounds, byRoundingCorners:[.bottomRight, .bottomLeft], cornerRadii: CGSize(width: 12, height: 12))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        button.layer.mask = maskLayer
        
        buttonBorderLabel.backgroundColor = UIColor(netHex: 0xDEDFE0)

        button.setTitleColor(UIColor(netHex: 0x0672EB), for: UIControl.State())
    }
    
    @IBAction func OKButtonAction(_ sender: AnyObject) {
        let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardView") as! DashboardViewController
        let SideBarVC = self.storyboard?.instantiateViewController(withIdentifier: "SidebarMenu") as! SideBarMenuVC
        let nvc: UINavigationController = UINavigationController(rootViewController: mainVC)
        
        let slideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: SideBarVC)
        UIApplication.shared.keyWindow?.rootViewController = slideMenuController
    }

}
