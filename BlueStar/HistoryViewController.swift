//
//  HistoryViewController.swift
//  BlueStar
//
//  Created by tarun.kapil on 11/08/16.
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


class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    let dateFormatter = DateFormatter()
    var ticketHistoryList : NSArray? = []
    var reachability = Reachability()
    var showNoConnection: Bool = false
    var cancelTicketReload: Bool? = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        dispatch_async(dispatch_get_main_queue()) {
        //            self.getTicketHistory()
        //        }
        
        setNavigationBar()
        
        additionalViewSetUp()
       
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 166.0;
        tableView.rowHeight = UITableView.automaticDimension;
        
        let nc = NotificationCenter.default
         nc.addObserver(self, selector: #selector(cancelTicketReloadData), name: NSNotification.Name(rawValue: "cancelTicketReload"), object: nil)
         nc.addObserver(self, selector: #selector(dismissView), name: NSNotification.Name(rawValue: "closeViewController"), object: nil)
        nc.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        do {
            //try reachability = Reachability.reachabilityForInternetConnection();
            try reachability?.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
        if(cancelTicketReload == true){
            self.cancelTicketReloadData()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let screenClass = self.classForCoder.description()
        Analytics.setScreenName("Ticket History Screen", screenClass: screenClass)
        Analytics.logEvent("page_view",parameters: ["page":"Ticket History Screen"])
    }
    func additionalViewSetUp() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTicketStatusList(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func dismissView(){
        //print("It COme Here.-------------------------->")
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelTicketReloadData(){
        
        let refreshControl = UIRefreshControl()
        self.refreshTicketStatusList(_:refreshControl)
    }
    @objc func reachabilityChanged(_ note: Notification) {
        let reachability = note.object as! Reachability
        if reachability.isReachable {
            if ticketHistoryList?.count == 0 {
                DispatchQueue.main.async {
                    self.getTicket()
                    //self.getTicketHistory()
                }
            }
        } else {
            if ticketHistoryList?.count == 0 {
                showNoConnection = true
                getTicket()
                DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
            }
        }
    }
    
    func setNavigationBar() {
        self.title = "Ticket Status"
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
        if ticketHistoryList?.count == 0 && showNoConnection {
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
        return (self.ticketHistoryList?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell : HistoryTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as? HistoryTableViewCell)!
        let data = self.ticketHistoryList?[indexPath.row] as! NSDictionary
        //let productId = data["productId"] as! String
        let ticketNumber = data["ticketNumber"] as! String?
        let lastUpdatedDate = data["lastUpdatedDate"] as! String?
        let productName: String!
        if data["productName"] != nil {
                productName = data["productName"] as! String?
        } else
        {
            productName = ""
        }
        
        
        //let customerVisitTime = data["customerVisitTime"] as? String
         //        if let val = productsData[productId] {
        //            productName = val["productDisplayName"]!
        //        }
        let progressStatus = data["progressStatus"] as! String

        if(progressStatus.trim().caseInsensitiveCompare(statusDispatchedMize) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusDispatchRejectedMize) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusMaterialPendingMize) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusQueuedMize) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusWorkStartedMize) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusAllocatedMize) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusDispatchAcceptedMize) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusInWorkMize) == ComparisonResult.orderedSame){
                        cell.buttonCancelTicket.isEnabled = true
            
            // extra check for CR#87 PMS
            // check first char for 'A'
            if ticketNumber?.prefix(1) == "A"{
                print("Ticket found with A : \(ticketNumber)")
                cell.buttonCancelTicket.isEnabled = false
                let buttonCancelTicketColor = cell.buttonCancelTicket.backgroundColor
                cell.buttonCancelTicket.backgroundColor = buttonCancelTicketColor?.withAlphaComponent(0.3)
                cell.buttonCancelTicket.alpha = 0.3
//                cell.buttonCancelTicket.isUserInteractionEnabled = false
            }
        }
//        if (progressStatus.trim().caseInsensitiveCompare(statusWorkCompleted) == ComparisonResult.orderedSame ||  progressStatus.trim().caseInsensitiveCompare(statusClosed) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusCallCancelled) == ComparisonResult.orderedSame  || progressStatus.trim().caseInsensitiveCompare(statusAppointmentFixedForWorkCompletion) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusCallOnHoldObligationDispute) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusCallOnHoldAwaitingCustomerClearance) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusCallAttendedPendingForMaterial) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusWorkStartedAtSite) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusWorkInProcess) == ComparisonResult.orderedSame){
//            cell.buttonCancelTicket.isEnabled = false
//            //cell.buttonCancelTicket.backgroundColor = UIColor()
//            //cell.buttonCancelTicket.alpha = 0.5
//
//        }
        else{
           // cell.buttonCancelTicket.isEnabled = true
                        cell.buttonCancelTicket.isEnabled = false
        }
        cell.ticketNumberLabel.text = ticketNumber!
        cell.dateLabel.textColor = UIColor(netHex: 0x666666)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let customerVisitTime = data["customerVisitTime"] as? String ?? ""
        if customerVisitTime.trim() != "" {
            let date: Date? = dateFormatter.date(from: (customerVisitTime))
            //dateFormatter.dateFormat = "MMM dd, yyyy"
            if(date == nil){
                cell.dateLabel.text = ""
            } else{
            cell.dateLabel.text = dateFormatter.string(from: (date)!)
            }
        } else{
            cell.dateLabel.text = ""
        }
        
        cell.productLabel.text =  productName
        cell.productLabel.textColor = UIColor(netHex: 0x666666)
        cell.statusLabel.textColor = UIColor(netHex: 0x666666)
        cell.statusValueLabel.text = progressStatus
        
        cell.productLabel.numberOfLines = 0
//        cell.productLabel.preferredMaxLayoutWidth = 137
        cell.productLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
//        cell.productLabel.sizeToFit()

        
        let dealername = data["dealerName"] as? String ?? nil
        //dealername = (dealername.substring(from: dealername.characters.index(dealername.startIndex, offsetBy: 11)))
        let contact = data["dealerMobile"] as? String ?? nil
//        cell.dealerNameLabel.text = dealername
//        cell.dealerContactLabel.text = contact
        
        cell.buttonReminderFeedBack.tag = indexPath.row+100;
        cell.buttonShare.tag = indexPath.row+200;
        cell.buttonCancelTicket.tag = indexPath.row+300;
        if(progressStatus.trim().caseInsensitiveCompare(statusDispatchedMize) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusDispatchRejectedMize) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusMaterialPendingMize) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusQueuedMize) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusWorkStartedMize) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusAllocatedMize) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusDispatchAcceptedMize) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusInWorkMize) == ComparisonResult.orderedSame){
//        if (progressStatus.trim().caseInsensitiveCompare(statusWorkCompleted) == ComparisonResult.orderedSame ||  progressStatus.trim().caseInsensitiveCompare(statusClosed) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusCallCancelled) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusAppointmentFixedForWorkCompletion) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusCallOnHoldObligationDispute) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusCallOnHoldAwaitingCustomerClearance) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusCallAttendedPendingForMaterial) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusWorkStartedAtSite) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusWorkInProcess) == ComparisonResult.orderedSame){
            
            cell.statusValueLabel.textColor = UIColor(netHex: 0xFF9600)
            cell.buttonReminderFeedBack.setImage(UIImage(named: "call_small"), for:UIControl.State())
            cell.buttonReminderFeedBack.setTitle("Call Now", for: UIControl.State())
            let buttonCancelTicketColor = cell.buttonCancelTicket.backgroundColor
            cell.buttonCancelTicket.backgroundColor = buttonCancelTicketColor?.withAlphaComponent(1.0)
            cell.buttonCancelTicket.isUserInteractionEnabled = true

        } else {
            cell.statusValueLabel.textColor = UIColor(netHex: 0x0D8108)
            cell.buttonReminderFeedBack.setImage(UIImage(named: "feedback"), for:UIControl.State())
            cell.buttonReminderFeedBack.setTitle("Feedback", for: UIControl.State())
            let buttonCancelTicketColor = cell.buttonCancelTicket.backgroundColor
            cell.buttonCancelTicket.backgroundColor = buttonCancelTicketColor?.withAlphaComponent(0.3)
            cell.buttonCancelTicket.isUserInteractionEnabled = false
            //cell.buttonCancelTicket.isEnabled = false
            //cell.buttonReminderFeedBack.isUserInteractionEnabled = true
            //
            
          
           
        }
//        if (progressStatus.trim().caseInsensitiveCompare(statusQueued) == ComparisonResult.orderedSame ||  progressStatus.trim().caseInsensitiveCompare(statusDispatched) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(DispatchAccepted) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusQueuedDispatchRejected) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusResponseScheduled) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusCallAssignedToServiceProvider) == ComparisonResult.orderedSame){
//                        cell.statusValueLabel.textColor = UIColor(netHex: 0xFF9600)
//                        cell.buttonReminderFeedBack.setImage(UIImage(named: "call_small"), for:UIControlState())
//                        cell.buttonReminderFeedBack.setTitle("Call Now", for: UIControlState())
//                        let buttonCancelTicketColor = cell.buttonCancelTicket.backgroundColor
//                        cell.buttonCancelTicket.backgroundColor = buttonCancelTicketColor?.withAlphaComponent(1.0)
//                        cell.buttonCancelTicket.isUserInteractionEnabled = true
//        } else{
//            
//                        cell.statusValueLabel.textColor = UIColor(netHex: 0x0D8108)
//                        cell.buttonReminderFeedBack.setImage(UIImage(named: "feedback"), for:UIControlState())
//                        cell.buttonReminderFeedBack.setTitle("Feedback", for: UIControlState())
//                        let buttonCancelTicketColor = cell.buttonCancelTicket.backgroundColor
//                        cell.buttonCancelTicket.backgroundColor = buttonCancelTicketColor?.withAlphaComponent(0.3)
//                        cell.buttonCancelTicket.isUserInteractionEnabled = false
//                        //cell.buttonCancelTicket.isEnabled = false
//                        //cell.buttonReminderFeedBack.isUserInteractionEnabled = true
//        }
        
         cell.buttonCancelTicket.addTarget(self, action: #selector(cancelTicketButtonAction(_:)), for: .touchUpInside)
        cell.buttonReminderFeedBack.addTarget(self, action: #selector(feedBackButtonAction(_:)), for:.touchUpInside)
               cell.buttonShare.addTarget(self, action: #selector(shareButtonAction(_:)), for: .touchUpInside)
        
        
        cell.roundViewForImageView.layer.cornerRadius = cell.roundViewForImageView.frame.height/2
        cell.roundViewForImageView.layer.masksToBounds = true
        cell.roundViewForImageView.layer.borderWidth = 1
        cell.roundViewForImageView.layer.borderColor = UIColor(netHex: 0xDEDFE0).cgColor
        
        let image = data["productImage"] as! String?
        if let imageUrl = URL(string: image!){
            print(image)
            cell.leftIconImageView.af_setImage(withURL: imageUrl, placeholderImage: placeholderImage)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        return UITableViewAutomaticDimension
        return 190

    }
    //
    //
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
        return 190
    }
    
    @objc func moveBackToDashboard() {
        
        var isPop:Bool = false
        for vc: UIViewController in (self.navigationController?.viewControllers)! {
            
            if (vc is TicketViewController) {
                //It exists
                isPop = true
            }
        }
        
        if isPop {
            
            self.navigationController?.popToViewController((self.navigationController?.viewControllers[0])!, animated: true)
        }
        else {
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    func getTicket() {
        self.showPlaceHolderView()
        DispatchQueue.main.async {
            let fileURL = DBManager.shareInstance.getPath()
            let db1 = FMDatabase(path: fileURL)
            var ticketList:NSMutableArray = []
            var totalrecord:NSMutableArray = []
            db1?.open()
            if let rs = db1?.executeQuery("select * from ticketHistory order by lastUpdatedDate DESC", withArgumentsIn:nil) {
                totalrecord.removeAllObjects()
                //self.ticketHistoryList.removeAllObjects()
                while rs.next() {
                    //                print(rs.resultDictionary())
                    //                print(rs.string(forColumn: "ticketNumber"))
                    //                print(rs.string(forColumn: "lastUpdatedDate"))
                    //                print(rs.string(forColumn: "dealerMobile"))
                    //                print(rs.string(forColumn: "productImage"))
                    //                print(rs.string(forColumn: "dealerName"))
                    //                print(rs.string(forColumn: "productId"))
                    //                print(rs.string(forColumn: "dealerMobile"))
                    //                print(rs.string(forColumn: "progressStatus"))
                    //                print(rs.string(forColumn: "productName"))
                    totalrecord.addObjects(from: [rs.resultDictionary() as Any])
                    
                    
                    ticketList.addObjects(from: [rs.resultDictionary() as Any])
                }
                self.ticketHistoryList = ticketList as NSArray
                TicketHistoryModel.shareInstance.parseResponseObject(self.ticketHistoryList)
                //self.ticketHistoryList = TicketHistoryModel.shareInstance.tickets!
                if self.ticketHistoryList?.count == 0 {
                    self.hidePlaceHolderView()
                    DataManager.shareInstance.showAlert(self, title: "", message: "No ticket history found.")
                } else {
                    self.sortTicketHistoryList()
                    self.hidePlaceHolderView()
                    self.tableView.reloadData()
                }
                
                print(totalrecord.count)
            }else {
                self.hidePlaceHolderView()
                print("select failure: \(String(describing: db1?.lastErrorMessage()))")
            }
        }
        
        
    }
    
    

//    func getTicketHistory() {
//        self.showPlaceHolderView()
//        if NetworkChecker.isConnectedToNetwork() {
//            var values: Dictionary<String, AnyObject> = [:]
//            values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
//            values["platform"] = platform as AnyObject?
//            values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
//            DataManager.shareInstance.getDataFromWebService(ticketHistoryURL, dataDictionary:values as NSDictionary) { (result, error) -> Void in
//                if error == nil {
//                    DispatchQueue.main.async {
//                        self.hidePlaceHolderView()
//                        TicketHistoryModel.shareInstance.parseResponseObject(result)
//                        let status: String = TicketHistoryModel.shareInstance.status!
//                        if status == "success" {
//                            self.ticketHistoryList = TicketHistoryModel.shareInstance.tickets!
//                            // self.sortTicketHistoryList()
//                            if self.ticketHistoryList.count == 0 {
//                                DataManager.shareInstance.showAlert(self, title: "", message: "No ticket history found.")
//                            } else {
//                                self.tableView.reloadData()
//                            }
//                        } else {
//                            DataManager.shareInstance.showAlert(self, title: errorTitle, message: errorMessage)
//                        }
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        self.hidePlaceHolderView()
//                        if error?.code != -999 {
//                            DataManager.shareInstance.showAlert(self, title: errorTitle, message: errorMessage)
//                        }
//                    }
//                }
//            }
//        } else {
//            self.hidePlaceHolderView()
//            DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
//        }
//    }
    
    func sortTicketHistoryList()
    {
        var localHistoryList : NSMutableArray! = []
        for (_, data) in (self.ticketHistoryList?.enumerated())!
        {
            var localDict = data as! Dictionary<String, AnyObject>
            var anchc=localDict["progressStatus"]
            if !(isNotNull(anchc))
            {
                localDict["progressStatus"] = "null" as AnyObject?
            }
            localHistoryList.add(localDict)
        }
        self.ticketHistoryList = localHistoryList
        let newSet = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
        self.ticketHistoryList = self.ticketHistoryList?.sorted(by: {(int1, int2)  -> Bool in

            return (((int1 as! NSDictionary).value(forKey: "ticketNumber") as! String).trimmingCharacters(in: newSet)) > (((int2 as! NSDictionary).value(forKey: "ticketNumber") as! String).trimmingCharacters(in: newSet)) // It sorted the values and return to the mySortedArray
        }) as! NSArray

//        self.ticketHistoryList = (self.ticketHistoryList as! NSArray).sortedArray(using: [NSSortDescriptor(key: "ticketNumber", ascending: false)]) as! [[String:AnyObject]] as NSArray

//        print(sortedResults)
    }
    
    @objc func refreshTicketStatusList(_ refreshControl:UIRefreshControl)
    {
        //self.showPlaceHolderView()
        if NetworkChecker.isConnectedToNetwork()
        {
             self.getTicketOnRefresh(refreshControl)
//            var values: Dictionary<String, AnyObject> = [:]
//            values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
//            values["platform"] = platform as AnyObject?
//            values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
//            DataManager.shareInstance.getDataFromWebService(ticketHistoryURL, dataDictionary:values as NSDictionary)
//            { (result, error) -> Void in
//                if error == nil
//                {
//                    DispatchQueue.main.async
//                        {
//                            refreshControl.endRefreshing()
//                            // self.hidePlaceHolderView()
//                            TicketHistoryModel.shareInstance.parseResponseObject(result)
//                            let status: String = TicketHistoryModel.shareInstance.status!
//                            if status == "success"
//                            {
//                                self.ticketHistoryList = TicketHistoryModel.shareInstance.tickets!
//                                //self.sortTicketHistoryList()
//                                if self.ticketHistoryList.count == 0
//                                {
//                                    DataManager.shareInstance.showAlert(self, title: "", message: "No ticket history found.")
//                                }
//                                else
//                                {
//                                    self.tableView.reloadData()
//                                }
//                            }
//                            else
//                            {
//                                DataManager.shareInstance.showAlert(self, title: errorTitle, message: errorMessage)
//                            }
//                    }
//                }
//                else
//                {
//                    DispatchQueue.main.async
//                        {
//                            refreshControl.endRefreshing()
//                            // self.hidePlaceHolderView()
//                            if error?.code != -999
//                            {
//                                DataManager.shareInstance.showAlert(self, title: errorTitle, message: errorMessage)
//                            }
//                    }
//                }
//            }
        }
        else
        {
            refreshControl.endRefreshing()
            // self.hidePlaceHolderView()
            DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
        }
    }
    
    
    
    
    //==========================================Pull To Refresh API+Database===========================================================>
    func getTicketOnRefresh(_ refreshControl:UIRefreshControl){
        if NetworkChecker.isConnectedToNetwork() {
            var ticketList:NSMutableArray = []
            let last = UserDefaults.standard.value(forKey: "LastSynced")
            var values: Dictionary<String, AnyObject> = [:]
            //self.ticketList.removeAllObjects()
            //let last = UserDefaults.standard.value(forKey: "LastSynced")
            values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
            values["platform"] = platform as AnyObject?
            values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
            if(last == nil)
            {
                values["lastsynced"] = "1950-01-01 00:00:00.000" as AnyObject?
            } else{
                values["lastsynced"] = last as AnyObject?
            }
            print(last)
            DataManager.shareInstance.getDataFromWebService(ticketHistoryURLMize, dataDictionary:values as NSDictionary)
            { (result, error) -> Void in
                if error == nil
                {
                    DispatchQueue.main.async
                        {
                            // self.hidePlaceHolderView()
                            TicketHistoryModel.shareInstance.parseResponseObject(result)
                            let status: String = TicketHistoryModel.shareInstance.status!
                            if status == "success"
                            {
                                self.ticketHistoryList = TicketHistoryModel.shareInstance.tickets!
                                let lastSynced: String = TicketHistoryModel.shareInstance.lastSynced!
                                UserDefaults.standard.setValue(lastSynced, forKey: "LastSynced")
                                UserDefaults.standard.synchronize()
                                //self.sortTicketHistoryList()
                                //                            if self.ticketHistoryList.count == 0
                                //                            {
                                //                                refreshControl.endRefreshing()
                                //                                DataManager.shareInstance.showAlert(self, title: "", message: "No ticket history found.")
                                //                            }
                                //                            else
                                //                            {
                                
                                let fileURL = DBManager.shareInstance.getPath()
                                let db1 = FMDatabase(path: fileURL)
                                let totalTicket = self.ticketHistoryList?.count
                                // print("sdbsvbd\(totalTicket)")
                                for var i in 0..<Int(totalTicket!) {
                                    //totalTicket = totalTicket - 1
                                    let data = self.ticketHistoryList?[i] as! NSDictionary
                                    let ticketNumber = data["ticketNumber"] as! String
                                    let lastUpdatedDate = data["lastUpdatedDate"] as! String
                                    let productName = data["productName"] as! String
                                    let progressStatus = data["progressStatus"] as! String
                                    var dealername:String = ""
                                    var contact : String = ""
                                    var prodImage : String = ""
                                    let prodId = data["productId"] as! String
                                    let customerVisitTime = data["customerVisitTime"] as? String ?? ""
                                    
                                    if data["dealerName"] != nil{
                                        dealername = data["dealerName"] as! String
                                    }
                                    if data["productImage"] != nil{
                                        prodImage = data["productImage"] as! String
                                    }
                                    if data["dealerMobile"] != nil{
                                        contact = data["dealerMobile"]  as! String
                                    }
                                   // let updatedOn = data["updatedOn"] as! String
                                    db1?.open()
                                    //let rs = db1?.executeQuery("select * from ticketHistory where ticketNumber like '?'  ", withArgumentsIn:[ticketNumber])
                                    
                                    //           if let rs = db1?.executeQuery("select * from ticketHistory where ticketNumber like '?'  ", withArgumentsIn:[ticketNumber]) {
                                    // while rs.next() {
                                    //                                            let isupdated = db1?.executeUpdate("update ticketHistory set lastUpdatedDate = ? ,productImage  = ? ,dealerName = ? ,productId = ? ,dealerMobile = ? ,progressStatus = ? ,productName = ? where ticketNumber = ?", withArgumentsIn: [lastUpdatedDate,prodImage,dealername,prodId,contact,progressStatus,productName,ticketNumber])
                                    //
                                    //                                            if (!isupdated!){
                                    //                                                print("Ticket Number\(ticketNumber) is not updated. Update failure: \(db1?.lastErrorMessage())")
                                    //                                            } else {
                                    //
                                    //                                        }
                                    //                                            print("comes in")
                                    //                                            let isDeleted = db1?.executeUpdate("delete from ticketHistory where ticketNumber like '?'", withArgumentsIn: [ticketNumber])
                                    //                                            if (!isDeleted!){
                                    //                                            print("Ticket Number\(ticketNumber) is not Deleted. Delete failure: \(db1?.lastErrorMessage())")
                                    //                                            }
                                    //     }
                                    let check = "INSERT or replace into ticketHistory (ticketNumber,lastUpdatedDate,productImage,dealerName,productId,dealerMobile,progressStatus,productName,customerVisitTime) VALUES ('\(ticketNumber)','\(lastUpdatedDate)','\(prodImage)','\(dealername)','\(prodId)','\(contact)','\(progressStatus)','\(productName)','\(customerVisitTime)')"
                                    print(check)
                                    let temp = db1?.executeUpdate(check, withArgumentsIn: nil)
                                    //let isinserted = db1?.executeUpdate("INSERT or replace into ticketHistory (ticketNumber,lastUpdatedDate,productImage,dealerName,productId,dealerMobile,progressStatus,productName) VALUES ('?','?','?','?','?','?','?','?')", withArgumentsIn: [ticketNumber,lastUpdatedDate,prodImage,dealername,prodId,contact,progressStatus,productName])
                                    if(!temp!){
                                        print("Database failure: \(db1?.lastErrorMessage())")
                                    }
                                    //                            }
                                }
                                //self.ticketHistoryList = ""
                                ticketList.removeAllObjects()
                                db1?.open()
                                if let rs = db1?.executeQuery("select * from ticketHistory order by lastUpdatedDate DESC", withArgumentsIn:nil) {
                                    //            totalrecord.removeAllObjects()
                                    //            ticketList.removeAllObjects()
                                    while rs.next() {
                                        ticketList.addObjects(from: [rs.resultDictionary() as Any])
                                    }
                                    self.ticketHistoryList = ticketList as NSArray
                                    if self.ticketHistoryList?.count == 0 {
                                        refreshControl.endRefreshing()
                                        DataManager.shareInstance.showAlert(self, title: "", message: "No ticket history found.")
                                    } else {
                                        self.sortTicketHistoryList() //uncomment
                                        self.tableView.reloadData()
                                        
                                        refreshControl.endRefreshing()
                                    }
                                }else {
                                    refreshControl.endRefreshing()
                                    print("select failure: \(db1?.lastErrorMessage())")
                                }
                                
                                //                                self.tableView.reloadData()
                                //                            }
                            }
                            else
                            {
                                DataManager.shareInstance.showAlert(self, title: errorTitle, message: errorMessage)
                            }
                    }
                }
                else
                {
                    DispatchQueue.main.async
                        {
                            refreshControl.endRefreshing()
                            // self.hidePlaceHolderView()
                            if error?.code != -999
                            {
                                DataManager.shareInstance.showAlert(self, title: (error?.domain)!, message: (error?.localizedDescription)!)
                            }
                    }
                }
            }
        }
        else {
            
            DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
        }
        
    }

    
    @objc func feedBackButtonAction(_ buttonFeedback:UIButton)
    {
        let ticketDetail = self.ticketHistoryList?[buttonFeedback.tag-100] as? NSDictionary
        if buttonFeedback.titleLabel?.text == "Call Now" {
            let dealerMobileNumber = "18002091177"
            if (dealerMobileNumber.trim() != "" ){
                if let phoneCallURL:URL = URL(string: "tel://\(dealerMobileNumber)")
                {
                    let application:UIApplication = UIApplication.shared
                    if (application.canOpenURL(phoneCallURL))
                    {
                        application.openURL(phoneCallURL);
                    }
                }
            }
            return
        } else {
            let controller:FeedbackViewController = self.storyboard!.instantiateViewController(withIdentifier: "FeedbackView") as! FeedbackViewController
            controller.isFromTicketStatus = true
            controller.ticketDetails =  ticketDetail//self.ticketHistoryList[buttonFeedback.tag-100] as? NSDictionary
            self.navigationController?.pushViewController(controller, animated:true)
            return
        }
        
        
        // OLD LOGIC, COMMENTED OUT - 20/12 ZYZZ
//        let ticketDetail = self.ticketHistoryList?[buttonFeedback.tag-100] as? NSDictionary
//        let progressStatus = ticketDetail!["progressStatus"] as! String
//        if(progressStatus.trim().caseInsensitiveCompare(statusDispatchedMize) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusDispatchRejectedMize) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusMaterialPendingMize) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusQueuedMize) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusWorkStartedMize) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusAllocatedMize) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusDispatchAcceptedMize) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusInWorkMize) == ComparisonResult.orderedSame){
////        if (progressStatus.trim().caseInsensitiveCompare(statusWorkCompleted) == ComparisonResult.orderedSame ||  progressStatus.trim().caseInsensitiveCompare(statusClosed) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusCallCancelled) == ComparisonResult.orderedSame  || progressStatus.trim().caseInsensitiveCompare(statusAppointmentFixedForWorkCompletion) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusCallOnHoldObligationDispute) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusCallOnHoldAwaitingCustomerClearance) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusCallAttendedPendingForMaterial) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusWorkStartedAtSite) == ComparisonResult.orderedSame || progressStatus.trim().caseInsensitiveCompare(statusWorkInProcess) == ComparisonResult.orderedSame)
////        {
//            let controller:FeedbackViewController = self.storyboard!.instantiateViewController(withIdentifier: "FeedbackView") as! FeedbackViewController
//            controller.isFromTicketStatus = true
//            controller.ticketDetails =  ticketDetail//self.ticketHistoryList[buttonFeedback.tag-100] as? NSDictionary
//            self.navigationController?.pushViewController(controller, animated:true)
//        }
//        else
//        {
//            let dealerMobileNumber = "18002091177"
//            if (dealerMobileNumber.trim() != "" ){
//                if let phoneCallURL:URL = URL(string: "tel://\(dealerMobileNumber)")
//                {
//                    let application:UIApplication = UIApplication.shared
//                    if (application.canOpenURL(phoneCallURL))
//                    {
//                        application.openURL(phoneCallURL);
//                    }
//                }
//            }
//            else
//            {
//                DataManager.shareInstance.showAlert(self, title:"Ticket Status", message:"Dealer mobile number is not available.")
//            }
//        }
    }
    
    @objc func shareButtonAction(_ buttonShare:UIButton)
    {
        let ticketDetail = self.ticketHistoryList?[buttonShare.tag-200] as? NSDictionary
        
        let productName = ticketDetail?["productName"] as! String
        let ticketNumber = ticketDetail?["ticketNumber"] as! String
        let progressStatus = ticketDetail?["progressStatus"] as! String
        let dealerName = ticketDetail?["dealerName"] as? String ?? ""
        let lastUpdatedDate = ticketDetail?["lastUpdatedDate"] as? String 
        let dealerMobile = ticketDetail?["dealerMobile"] as? String ?? ""
        var message: String!
        var message1: String!
        var message2: String!
        var message3: String!
        //dealerName = (dealerName.substring(from: dealerName.characters.index(dealerName.startIndex, offsetBy: 11)))
        if(dealerMobile == "" && lastUpdatedDate == "") {
            message1 = "Your ticket reference number for Blue Star "+productName+" is "
            message2 = message1+ticketNumber+"\nStatus: "
            message3 = message2+progressStatus+"\nDelear name: "+dealerName
            message = message3+",\nSent via: Blue Star Customer Care Application"
            //message = "Your ticket reference number for Blue Star "+productName+" is "+ticketNumber+"\nStatus: "+progressStatus+"\nDelear name: "+dealerName+",\nSent via: Blue Star Customer Care Application"
        }
        else if (dealerMobile == "" && dealerName == "") {
            message1 = "Your ticket reference number for Blue Star "+productName+" is "+ticketNumber
            message2 = message1+"\nStatus: "+progressStatus
            message = message2+",\nVisit time: "+lastUpdatedDate!+"\nSent via: Blue Star Customer Care Application"
            //message = "Your ticket reference number for Blue Star "+productName+" is "+ticketNumber+"\nStatus: "+progressStatus+"\nDelear name: "+dealerName+",\nVisit time: "+lastUpdatedDate+"\nSent via: Blue Star Customer Care Application"
        }
        else if(dealerMobile == "" && dealerName == "" && lastUpdatedDate == ""){
            message1 = "Your ticket reference number for Blue Star "+productName+" is "+ticketNumber
            
            //message2 = message1+"\nStatus: "+progressStatus+"\nDelear name: "+dealerName
            message = message1+"\nSent via: Blue Star Customer Care Application"
            //message = "Your ticket reference number for Blue Star "+productName+" is "+ticketNumber+"\nStatus: "+progressStatus+"\nDelear name: "+dealerName+",\nVisit time: "+lastUpdatedDate+"\nSent via: Blue Star Customer Care Application"

        }
        else if(lastUpdatedDate == "") {
            
        message1 = "Your ticket reference number for Blue Star "+productName+" is "+ticketNumber+"\nStatus: "+progressStatus
            message2 = message1+"\nDelear name: "+dealerName+",\nContact no: "
            message = message2+dealerMobile+"\nSent via: Blue Star Customer Care Application"
            //message = "Your ticket reference number for Blue Star "+productName+" is "+ticketNumber+"\nStatus: "+progressStatus+"\nDelear name: "+dealerName+",\nContact no: "+dealerMobile+"\nSent via: Blue Star Customer Care Application"
        }
        else {
            message1 = "Your ticket reference number for Blue Star "+productName+" is "+ticketNumber+"\nStatus: "+progressStatus
            message2 = message1+"\nDelear name: "+dealerName+",\nVisit time: "+lastUpdatedDate!
            message = message2+"Contact no: "+dealerMobile+"Sent via: Blue Star Customer Care Application"
            //message = "Your ticket reference number for Blue Star "+productName+" is "+ticketNumber+"\nStatus: "+progressStatus+"\nDelear name: "+dealerName+",\nVisit time: "+lastUpdatedDate+"Contact no: "+dealerMobile+"Sent via: Blue Star Customer Care Application"
        }
        
        print(dealerName)
        let textToShare = [ message ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func cancelTicketButtonAction(_ buttonCancelTicket:UIButton)
    {
        let ticketDetail = self.ticketHistoryList?[buttonCancelTicket.tag-300] as? NSDictionary
        
        let optionsListViewController = self.storyboard?.instantiateViewController(withIdentifier: "OptionsListViewController") as! OptionsListViewController
        optionsListViewController.optionsType = "cancel"
        optionsListViewController.flag = false
        optionsListViewController.ticketNumber = ticketDetail?["ticketNumber"] as! String as NSString!
        self.present(optionsListViewController, animated: true, completion: nil)
}
    /*
     func reminderCall(buttonReminder:UIButton) {
     
     let dealerMobileNumber = "18002091177"
     if (dealerMobileNumber.trim() != "" ){
     if let phoneCallURL:NSURL = NSURL(string: "tel://\(dealerMobileNumber)") {
     let application:UIApplication = UIApplication.sharedApplication()
     if (application.canOpenURL(phoneCallURL)) {
     application.openURL(phoneCallURL);
     }
     }
     }else{
     DataManager.shareInstance.showAlert(self, title:"Ticket Status", message:"Dealer mobile number is not available.")
     }
     
     }
     */
    
    func showPlaceHolderView()
    {
        let controller:UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "PlaceHolderView")
        controller.view.frame = self.view.bounds;
        controller.view.tag = 100
        controller.view.backgroundColor = UIColor(white: 0.1, alpha: 0.65)
        controller.willMove(toParent: self)
        self.view.addSubview(controller.view)
        self.addChild(controller)
        controller.didMove(toParent: self)
    }
    
    func hidePlaceHolderView()
    {
        if let viewWithTag = self.view.viewWithTag(100)
        {
            viewWithTag.removeFromSuperview()
        }
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
