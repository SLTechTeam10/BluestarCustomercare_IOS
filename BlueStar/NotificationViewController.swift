//
//  NotificationViewController.swift
//  BlueStar
//
//  Created by tarun.kapil on 02/08/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import FirebaseAnalytics
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var date = Date()
    let dateFormatter = DateFormatter()
    
    var notificationHistoryList: NSArray! = []
    var reachability = Reachability()
    var showNoConnection: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        date = toLocalTime()
//        dispatch_async(dispatch_get_main_queue()) {
//            self.getNotificationHistory()
//        }
        
        setNavigationBar()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        do {
            //try reachability = Reachability.reachabilityForInternetConnection();
            try reachability?.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let screenClass = self.classForCoder.description()
        Analytics.setScreenName("Notification Screen", screenClass: screenClass)
        Analytics.logEvent("page_view",parameters: ["page":"Notification Screen"])
    }
    @objc func reachabilityChanged(_ note: Notification) {
        let reachability = note.object as! Reachability
        if reachability.isReachable {
            if notificationHistoryList.count == 0 {
                DispatchQueue.main.async {
                    self.getNotificationHistory()
                }
            }
        } else {
            if notificationHistoryList.count == 0 {
                showNoConnection = true
                DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
            }
        }
    }
    
    func setNavigationBar() {
        self.title = "Notifications"
        let nav = self.navigationController?.navigationBar
        nav!.titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.font.rawValue: UIFont(name: fontQuicksandBookRegular, size: 18)!])
        nav!.barTintColor = UIColor(netHex: 0x246cb0)
        nav!.barStyle = UIBarStyle.black
        nav!.isTranslucent = false
        nav!.tintColor = UIColor.white
        if #available(iOS 13, *)
        {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(netHex: 0x246cb0)

            // Customizing our navigation bar
            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: IMG_Back), for: UIControl.State())
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.addTarget(self, action: #selector(moveBackToDashboard), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if notificationHistoryList.count == 0 && showNoConnection {
            let messageLabel = UILabel(frame: CGRect(x: 0,y: 0,width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            messageLabel.text = noInternetTitle
            messageLabel.textColor = UIColor(netHex:0x666666)
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont(name: fontQuicksandBookRegular, size: 15)
            messageLabel.sizeToFit()
            tableView.backgroundView = messageLabel
        } else {
            tableView.backgroundView = nil
            numOfSections = 1
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return notificationHistoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell : NotificationTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? NotificationTableViewCell)!
        let data = notificationHistoryList[indexPath.row] as? NSDictionary
        cell.notificationLabel.text = data?["message"] as? String
        cell.notificationLabel.textColor = UIColor(netHex: 0x666666)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.zzz"
        let oldDate = dateFormatter.date(from: data?["notificationTime"] as! String)
        if date.hoursFrom(oldDate!) > 23 {
            dateFormatter.dateFormat = "dd MMM"
            cell.timeLabel.text = dateFormatter.string(from: oldDate!)
        } else {
            cell.timeLabel.text =  "\(date.hoursFrom(oldDate!)) hours ago"
        }
        cell.timeLabel.textColor = UIColor(netHex: 0xAEAEAE)
        let lineViewBottom = UIView(frame: CGRect(x: 0, y: cell.notificationLabel.frame.size.height, width: tableView.bounds.size.width-20, height: 1))
        lineViewBottom.backgroundColor = UIColor(netHex: 0xDEDFE0)
        cell.notificationLabel.addSubview(lineViewBottom)
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = bgColorView
        return cell
    }
    
    func toLocalTime() -> Date {
        let timeZone = TimeZone.autoupdatingCurrent
        let seconds : TimeInterval = Double(timeZone.secondsFromGMT(for: date))
        let localDate = Date(timeInterval: seconds, since: date)
        return localDate
    }
    
    @objc func moveBackToDashboard() {
        navigationController?.popViewController(animated: true)
    }
    
    func getNotificationHistory() {
        self.showPlaceHolderView()
        if NetworkChecker.isConnectedToNetwork() {
            var values: Dictionary<String, AnyObject> = [:]
            values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
            values["platform"] = platform as AnyObject?
            values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
            DataManager.shareInstance.getDataFromWebService(notificationHistoryURL, dataDictionary:values as NSDictionary) { (result, error) -> Void in
                if error == nil {
                    DispatchQueue.main.async {
                        self.hidePlaceHolderView()
                        NotificationHistoryModel.shareInstance.parseResponseObject(result)
                        let status: String = NotificationHistoryModel.shareInstance.status!
                        if status == "success" {
                            self.notificationHistoryList = NotificationHistoryModel.shareInstance.notifications!
                            self.sortNotificationHistoryList()
                            if self.notificationHistoryList.count == 0 {
                                DataManager.shareInstance.showAlert(self, title: "", message: "No notification history found.")
                            } else {
                                self.tableView.reloadData()
                            }
                        } else {
                            DataManager.shareInstance.showAlert(self, title: errorTitle, message: errorMessage)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.hidePlaceHolderView()
                        if error?.code != -999 {
                            DataManager.shareInstance.showAlert(self, title: (error?.domain)!, message: (error?.localizedDescription)!)
                        }
                    }
                }
            }
        } else {
            self.hidePlaceHolderView()
            DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
        }
    }
    
    func sortNotificationHistoryList() {
        self.notificationHistoryList = self.notificationHistoryList.sorted{
            (($0 as! Dictionary<String, String>)["notificationTime"]) > (($1 as! Dictionary<String, String>)["notificationTime"])
        } as NSArray!
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
