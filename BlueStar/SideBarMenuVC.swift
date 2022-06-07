//
//  SideBarMenuVC.swift
//  BlueStar
//
//  Created by tarun.kapil on 7/21/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import FirebaseAnalytics

enum LeftMenu: Int {
    case myAccount = 0
    case registeredDevice
    case history
    case faqs
    case trainingVideo
    case privacyPolicy
    case termCondition
    case contactUs
    case aboutUs
    case logout
    
}

class SideBarMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource, SlideMenuControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var mainController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainViewController:DashboardViewController = self.storyboard!.instantiateViewController(withIdentifier: "DashboardView") as! DashboardViewController
        self.mainController = UINavigationController(rootViewController: mainViewController)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor(netHex: 0x246cb0)
        
        tableView.alwaysBounceVertical = false
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name(rawValue: "reloadData"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let screenClass = self.classForCoder.description()
        Analytics.setScreenName("Side Menu Screen", screenClass: screenClass)
        Analytics.logEvent("page_view",parameters: ["page":"Side Menu Screen"])
    }
    @objc func reloadData() {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var topView = SidebarHeaderUIView()
        topView = Bundle.main.loadNibNamed("SidebarHeaderView", owner: self, options: nil)?[0] as! SidebarHeaderUIView
        let user = PlistManager.sharedInstance.getValueForKey("user") as! NSDictionary
        if let _ = user["firstName"] {
            let firstName = user["firstName"] as? String
            let lastName = user["lastName"] as? String
            topView.userNameLabel.text = firstName! + " " + lastName!
            topView.userNameLabel.textColor = UIColor.white
        } else {
            topView.userNameLabel.isHidden = true
        }
        if let val = user["email"] {
            topView.userEmailLabel.text = val as? String
            topView.userEmailLabel.textColor = UIColor.white
        } else {
            topView.userEmailLabel.isHidden = true
        }
        //topView.userImageView.image = UIImage(named: IMG_SlideMenuUser)
        topView.frame = CGRect(x: 0,y: 20,width: self.tableView.frame.size.width, height: 128)
        topView.headerView.backgroundColor = UIColor(netHex: 0x246cb0)
        return topView
    }
    
    func  tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 128
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return sidebarMenuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell : SidebarTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "SidebarCell", for: indexPath) as? SidebarTableViewCell)!
        let data = sidebarMenuArray[indexPath.row]
        cell.menuIconImageView.image = UIImage(named: data["icon"]!)
        cell.menuLabel.text = data["label"]
        cell.menuLabel.textColor = UIColor.white
        cell.backgroundColor = UIColor(netHex: 0x246cb0)
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(netHex: 0x246cb0)
        cell.selectedBackgroundView = bgColorView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if let menu = LeftMenu(rawValue: indexPath.item) {
            self.changeViewController(menu)
        }
    }
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .myAccount:
            self.slideMenuController()?.closeLeft()
            self.slideMenuController()?.removeLeftGestures()
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name(rawValue: "showMyAccountView"), object: nil)
            
        case .history:
            self.slideMenuController()?.closeLeft()
            self.slideMenuController()?.removeLeftGestures()
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name(rawValue: "showHistoryView"), object: nil)
            /*        case .Notifications:
             self.slideMenuController()?.closeLeft()
             self.slideMenuController()?.removeLeftGestures()
             let nc = NSNotificationCenter.defaultCenter()
             nc.postNotificationName("showNotificationView", object: nil)
             */
            
//        case .SafetyTips:
//            self.slideMenuController()?.closeLeft()
//            DataManager.shareInstance.showAlert(self, title: "", message: "Coming Soon")
//            //            self.slideMenuController()?.removeLeftGestures()
//            //            let nc = NSNotificationCenter.defaultCenter()
//        //            nc.postNotificationName("showSafetyTipView", object: nil)
        case .registeredDevice:
            self.slideMenuController()?.closeLeft()
            self.slideMenuController()?.removeLeftGestures()
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name(rawValue: "showRegisterDevice"), object: nil)
        case .faqs:
            self.slideMenuController()?.closeLeft()
//            DataManager.shareInstance.showAlert(self, title: "", message: "Coming Soon")
            self.slideMenuController()?.removeLeftGestures()
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name(rawValue: "showFAQView"), object: nil)
            
        case .logout:
            let logoutAlert = UIAlertController(title: "Logout", message:logOutMessage, preferredStyle: UIAlertController.Style.alert)
            logoutAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                self.slideMenuController()?.closeLeft()
                self.slideMenuController()?.removeLeftGestures()
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.logoutFromApp()
            }))
            logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                
            }))
            present(logoutAlert, animated: true, completion: nil)
     
        case .termCondition:
            self.slideMenuController()?.closeLeft()
            self.slideMenuController()?.removeLeftGestures()
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name(rawValue: "showT&CView"), object: nil)
            
        case .privacyPolicy:
            self.slideMenuController()?.closeLeft()
            self.slideMenuController()?.removeLeftGestures()
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name(rawValue: "showPrivacyPolicy"), object: nil)
            
        case .aboutUs:
            self.slideMenuController()?.closeLeft()
            self.slideMenuController()?.removeLeftGestures()
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name(rawValue: "showAboutUs"), object: nil)
            
        case .contactUs:
            self.slideMenuController()?.closeLeft()
            self.slideMenuController()?.removeLeftGestures()
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name(rawValue: "showContactUs"), object: nil)
        case .trainingVideo:
            self.slideMenuController()?.closeLeft()
            self.slideMenuController()?.removeLeftGestures()
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name(rawValue: "showTrainingVideo"), object: nil)
            
        }
    }
    
}


