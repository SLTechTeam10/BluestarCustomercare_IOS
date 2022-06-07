//
//  DashboardViewController.swift
//  BlueStar
//
//  Created by tarun.kapil on 19/07/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//



import UIKit
import SlideMenuControllerSwift
import AlamofireImage
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


class DashboardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, SlideMenuControllerDelegate,EquipmentListViewControllerDelegate {

    
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var ticketHistoryList : NSArray! = []
    
    var productName: String!
    var productId: String!
    var ticketNumber: String!
    var date: String!
    var status: String!
    var popupWindow: UIWindow?
    
    var productList : NSArray! = []
    var limitedProductList : NSArray! = []
    var allProductList : NSArray! = []
    var selectedIndex : Int!
    var isAlreadyGenerated : Bool = false
    var ticketList:NSMutableArray = []
    var productImage: String!
    
    var alreadyGeneratedTicket: Bool?
    
    var dispaddress: NSDictionary!
    var data: Dictionary<String, AnyObject> = [:]
    let dateFormatter = DateFormatter()
    var reachability = Reachability()
    var showNoConnection: Bool = false
    var cell : DashboardCustomCell!
    var isForcefullyGenerated = "false" as AnyObject?
    let ticketStatusButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getProductList()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        //collectionView.backgroundColor = UIColor.whiteColor()
        //let last = UserDefaults.standard.value(forKey: "LastSynced")
        //print(last)
//        let controller:RegisterAddressViewController = self.storyboard!.instantiateViewController(withIdentifier: "RegisterAddressView") as! RegisterAddressViewController
//        controller.view.frame = self.view.bounds
//        controller.view.backgroundColor = UIColor(white: 0.1, alpha: 0.65)
//        controller.willMove(toParentViewController: self)
//        self.view.addSubview(controller.view)
//        self.addChildViewController(controller)
//        controller.didMove(toParentViewController: self)
        setNavigationBar()
        
        additionalViewSetUp()
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(doGenerateTicket), name: NSNotification.Name(rawValue: "doGenerateTicket"), object: nil)
        nc.addObserver(self, selector: #selector(generateNewTicket), name: NSNotification.Name(rawValue: "generateNewTicket"), object: nil)
        nc.addObserver(self, selector: #selector(followUpTicket), name: NSNotification.Name(rawValue: "followUpTicket"), object: nil)
        //nc.addObserver(self, selector: #selector(skipButtonPressed), name: NSNotification.Name(rawValue: "presentNatureOfProblem"), object: nil)
        nc.addObserver(self, selector: #selector(presentNatureOfProblemView), name: NSNotification.Name(rawValue: "presentNatureOfProblemView"), object: nil)
        
        nc.addObserver(self, selector: #selector(moveToNotificationView), name: NSNotification.Name(rawValue: "showNotificationView"), object: nil)
        nc.addObserver(self, selector: #selector(moveToFAQView), name: NSNotification.Name(rawValue: "showFAQView"), object: nil)
        nc.addObserver(self, selector: #selector(feedbackViewDidRemove), name: NSNotification.Name(rawValue: "removeFeedbackView"), object: nil)
        nc.addObserver(self, selector: #selector(moveToHistoryView), name: NSNotification.Name(rawValue: "showHistoryView"), object: nil)
        nc.addObserver(self, selector: #selector(moveToSafetyTipView), name: NSNotification.Name(rawValue: "showSafetyTipView"), object: nil)
        nc.addObserver(self, selector: #selector(moveToMyAccountView), name: NSNotification.Name(rawValue: "showMyAccountView"), object: nil)
        nc.addObserver(self, selector: #selector(moveToMyAccountAddressView), name: NSNotification.Name(rawValue: "showMyAccountAddressView"), object: nil)
        nc.addObserver(self, selector: #selector(moveToTermAndConditionView), name: NSNotification.Name(rawValue: "showT&CView"), object: nil)
        nc.addObserver(self, selector: #selector(moveToPrivacyPolicy), name: NSNotification.Name(rawValue: "showPrivacyPolicy"), object: nil)
        nc.addObserver(self, selector: #selector(moveToAboutUsScreen), name: NSNotification.Name(rawValue: "showAboutUs"), object: nil)
        nc.addObserver(self, selector: #selector(moveToContactUsScreen), name: NSNotification.Name(rawValue: "showContactUs"), object: nil)
        nc.addObserver(self, selector: #selector(moveToRegisterDeviceScreen), name: NSNotification.Name(rawValue: "showRegisterDevice"), object: nil)
        nc.addObserver(self, selector: #selector(moveToTrainingVideoScreen), name: NSNotification.Name(rawValue: "showTrainingVideo"), object: nil)
        nc.addObserver(self, selector: #selector(refreshProductList), name: NSNotification.Name(rawValue: "refreshProductsList"), object: nil)
        nc.addObserver(self, selector: #selector(getTicketStatus), name: NSNotification.Name(rawValue: "refreshTicketStatus"), object: nil)
        nc.addObserver(self, selector: #selector(displayTicketView), name: NSNotification.Name(rawValue: "displayTicketView"), object: dispaddress)
        nc.addObserver(self, selector: #selector(generateTicket), name: NSNotification.Name(rawValue: "ticketGenerate"), object: nil)
        nc.addObserver(self, selector: #selector(dismissView), name: NSNotification.Name(rawValue: "dismissNatureView"), object: data)
        
        nc.addObserver(self, selector: #selector(getTicketStatusApi), name: NSNotification.Name(rawValue: "ticketGeneratedRefreshView"), object: data)
        
        PlistManager.sharedInstance.saveValue(false as AnyObject, forKey: "alreadyRegisteredUser")
        
        nc.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        do {
            try reachability = Reachability();
            try reachability?.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
        
        // Load Ticket After product load from Local database or Service.
        getTicketHistoryByService()
        print("================================== DASHBOARD SHOWING END ::: \(Date())")
    }
    @objc func dismissView(notification: NSNotification) {
//        
//        self.presentedViewController?.dismiss(animated: true, completion: { _ in })
//        print(self.presentedViewController ?? "abc")
//        //self.showPlaceHolderView()
//        let dict = notification.object as! NSDictionary
        //let controller:ChooseAddressViewController = self.storyboard!.instantiateViewController(withIdentifier: "ChooseAddressView") as! ChooseAddressViewController
        
                   //controller.problem = dict.value(forKey: "selectedProblem")
                    //controller.problem = dict
//                    controller.problem = dict.value(forKey: "selectedProblem") as! String
//                    controller.selectedProductDetails = dict.value(forKey: "selectedProductDetails") as! NSDictionary
////                       //self.selectedProductDetails
//                    controller.isForcefullyGenerated = dict.value(forKey: "isForcefullyGenerated") as AnyObject
////                        // self.isForcefullyGenerated
//////                    //controller.natureHeight = self.totalHeight
//                    controller.view.frame = self.view.bounds
//                    controller.view.backgroundColor = UIColor(white: 0.1, alpha: 0.65)
//                    self.hidePlaceHolderView()
//                    controller.willMove(toParentViewController: self)
//                                        self.view.addSubview(controller.view)
//                                        self.addChildViewController(controller)
//                                        controller.didMove(toParentViewController: self)
        
//        let controller:ChooseAddressViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChooseAddressView") as! ChooseAddressViewController
//                    controller.problem = dict.value(forKey: "selectedProblem") as! String
//                    controller.selectedProductDetails = dict.value(forKey: "selectedProductDetails") as! NSDictionary
//                    controller.isForcefullyGenerated = dict.value(forKey: "isForcefullyGenerated") as AnyObject
//                    //controller.view.frame = self.view.bounds;
//                    //controller.view.frame(forAlignmentRect: <#T##CGRect#>)
//                    controller.view.backgroundColor = UIColor(white: 0.1, alpha: 0.65)
//                    self.present(controller, animated: true, completion: nil)
//
    }
    func additionalViewSetUp() {
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshGetProductList(_:)), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
    }
   
    
    //=====================================Pull To Refresh Product List Api==========================================================>
//    func refreshGetProductList(_ refreshControl:UIRefreshControl) {
//        
//        if NetworkChecker.isConnectedToNetwork() {
//            
//            var values: Dictionary<String, AnyObject> = [:]
//            values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
//            values["platform"] = platform as AnyObject?
//            values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
//            DataManager.shareInstance.getDataFromWebService(productListURL, dataDictionary:values as NSDictionary) { (result, error) -> Void in
//                if error == nil {
//                    DispatchQueue.main.async {
//                        
//                        if let responseDictionary: NSDictionary = result as? NSDictionary {
//                            
//                            if let responseStatus : String = (responseDictionary.object(forKey: KEY_Status) as? String)!{
//                                if responseStatus == "success"{
//                                    
//                                    ProductListModel.shareInstance.parseResponseObject(result)
//                                    self.productList = ProductListModel.shareInstance.products!
//                                    self.allProductList = ProductListModel.shareInstance.allProducts!
//                                    self.refreshGetTicketStatus(refreshControl)
//                                    ProductBL.shareInstance.resultProductData =  responseDictionary
//                                }
//                                else{
//                                    
//                                    if let responseError : String = (responseDictionary.object(forKey: "errorMessage") as? String)! {
//                                        
//                                        DataManager.shareInstance.showAlert(self, title: errorTitle, message: responseError)
//                                    }
//                                }
//                            }
//                        }
//                        self.registerDeviceToken()
//                    }
//                }
//                else {
//                    DispatchQueue.main.async {
//                        
//                        if error?.code != -999 {
//                            
//                            DataManager.shareInstance.showAlert(self, title: errorTitle, message: errorMessage)
//                        }
//                    }
//                }
//            }
//        }
//        else {
//            
//            DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
//        }
//    }
    
    
    //=====================================Pull To Refresh Product List Api + database==========================================================>
    
    @objc func refreshGetProductList(_ refreshControl:UIRefreshControl) {
        let fileURL = DBManager.shareInstance.getPath()
        
        if NetworkChecker.isConnectedToNetwork() {
            
            var values: Dictionary<String, AnyObject> = [:]
            values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
            values["platform"] = platform as AnyObject?
            values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
            DataManager.shareInstance.getDataFromWebService(productListURLMize, dataDictionary:values as NSDictionary) { (result, error) -> Void in
                if error == nil {
                    DispatchQueue.main.async {
                        if let responseDictionary: NSDictionary = result as? NSDictionary {
                            
                            if let responseStatus : String = (responseDictionary.object(forKey: KEY_Status) as? String){
                                if responseStatus == "success"{
                                    refreshControl.endRefreshing()
                                    ProductListModel.shareInstance.parseResponseObject(result)
                                    self.productList = ProductListModel.shareInstance.products!
                                    self.allProductList = ProductListModel.shareInstance.allProducts!
                                    //                                    let fileURL = DBManager.shareInstance.getPath()
                                    //                                    let db1 = FMDatabase(path: fileURL)
                                    //
                                    //                                    db1?.open()
                                    ProductListDatabaseModel.shareInstance.addProducts(self.allProductList)
                                    
                                    
                                    self.refreshGetTicketStatus(refreshControl)
                                    ProductBL.shareInstance.resultProductData =  responseDictionary
                                    //Enter Database
                                }
                                else{
                                    if let responseError : String = (responseDictionary.object(forKey: "errorMessage") as? String) {
                                        refreshControl.endRefreshing()
                                        DataManager.shareInstance.showAlert(self, title: errorTitle, message: responseError)
                                    }
                                }
                            }
                        }
                  //      self.registerDeviceToken()
                    }
                }
                else {
                    DispatchQueue.main.async {
                        
                        if error?.code != -999 {
                            refreshControl.endRefreshing()
                            DataManager.shareInstance.showAlert(self, title: (error?.domain)!, message: (error?.localizedDescription)!)
                        }
                    }
                }
            }
        }
        else {
            refreshControl.endRefreshing()
            DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
            refreshControl.endRefreshing()
        }
    }

    
    
    //=====================================Pull To Refresh API==========================================================>
 
//    func refreshGetTicketStatus(_ refreshControl:UIRefreshControl) {
//        
//        if NetworkChecker.isConnectedToNetwork() {
//            
//            var values: Dictionary<String, AnyObject> = [:]
//            values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
//            values["platform"] = platform as AnyObject?
//            values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
//            DataManager.shareInstance.getDataFromWebService(ticketHistoryURL, dataDictionary:values as NSDictionary) { (result, error) -> Void in
//                if error == nil {
//                    
//                    DispatchQueue.main.async {
//                        
//                        TicketHistoryModel.shareInstance.parseResponseObject(result)
//                        let status: String = TicketHistoryModel.shareInstance.status!
//                        if status == "success" {
//                            
//                            refreshControl.endRefreshing()
//                            
//                            self.ticketHistoryList = TicketHistoryModel.shareInstance.tickets!
//                            if self.ticketHistoryList.count == 0 {
//                                
//                                self.ticketStatusButton.isHidden = true
//                            }
//                            else {
//                                
//                                self.ticketStatusButton.isHidden = false
//                                self.collectionView.reloadData()
//                            }
//                        }
//                        else {
//                            
//                            // DataManager.shareInstance.showAlert(self, title: errorTitle, message: errorMessage)
//                        }
//                    }
//                }
//                else {
//                    
//                    DispatchQueue.main.async {
//                        
//                        if error?.code != -999 {
//                            
//                            // DataManager.shareInstance.showAlert(self, title: errorTitle, message: errorMessage)
//                        }
//                    }
//                }
//            }
//        }
//        else {
//            
//            DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
//        }
//    }
    
    
    
    //=====================================Pull To Refresh Ticket Status API==========================================================>
    func refreshGetTicketStatus(_ refreshControl:UIRefreshControl) {
        
        if NetworkChecker.isConnectedToNetwork() {
            let last = UserDefaults.standard.value(forKey: "LastSynced")
            var values: Dictionary<String, AnyObject> = [:]
            values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
            values["platform"] = platform as AnyObject?
            values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
            if(last == nil)
            {
                values["lastsynced"] = "1950-01-01 00:00:00.000" as AnyObject?
            } else{
                values["lastsynced"] = last as AnyObject?
            }
            DataManager.shareInstance.getDataFromWebService(ticketHistoryURLMize, dataDictionary:values as NSDictionary) { (result, error) -> Void in
                if error == nil {
                    
                    DispatchQueue.main.async {
                        
                        TicketHistoryModel.shareInstance.parseResponseObject(result)
                        let status: String = TicketHistoryModel.shareInstance.status!
                        if status == "success" {
                            refreshControl.endRefreshing()
                            self.ticketHistoryList = TicketHistoryModel.shareInstance.tickets!
                            let lastSynced: String = TicketHistoryModel.shareInstance.lastSynced!
                            UserDefaults.standard.setValue(lastSynced, forKey: "LastSynced")
                            UserDefaults.standard.synchronize()
                            //                                if self.ticketHistoryList.count == 0 {
                            //
                            //                                    self.ticketStatusButton.isHidden = true
                            //                                }
                            //                                else {
                            //
                            //                                    self.ticketStatusButton.isHidden = false
                            //                                    self.collectionView.reloadData()
                            //                                }
                            //                                let fileURL = DBManager.shareInstance.getPath()
                            //                                let db1 = FMDatabase(path: fileURL)
                            //                                let totalTicket = self.ticketHistoryList.count
                            // print("sdbsvbd\(totalTicket)")
                            TicketListModel.shareInstance.addTickets(self.ticketHistoryList)
                            self.refreshGetEquipmentList(refreshControl)
                            //                                for var i in 0..<totalTicket {
                            //                                    //totalTicket = totalTicket - 1
                            //                                    let data = self.ticketHistoryList[i] as! NSDictionary
                            //                                    let ticketNumber = data["ticketNumber"] as! String
                            //                                    let lastUpdatedDate = data["lastUpdatedDate"] as! String
                            //                                    let productName = data["productName"] as! String
                            //                                    let progressStatus = data["progressStatus"] as! String
                            //                                    let dealername = data["dealerName"] as! String
                            //                                    let contact = data["dealerMobile"] as! String
                            //                                    let prodImage = data["productImage"] as! String
                            //                                    let prodId = data["productId"] as! String
                            //let updatedOn = data["updatedOn"] as! String]
                            //                                    db1?.open()
                            //                                    if let rs = db1?.executeQuery("select * from ticketHistory where ticketNumber like '?'  ", withArgumentsIn:[ticketNumber]) {
                            //                                        if(rs.next())
                            //                                        {
                            //                                            let isupdated = db1?.executeUpdate("update ticketHistory set lastUpdatedDate = ? ,productImage  = ? ,dealerName = ? ,productId = ? ,dealerMobile = ? ,progressStatus = ? ,productName = ? where ticketNumber = ?", withArgumentsIn: [lastUpdatedDate,prodImage,dealername,prodId,contact,progressStatus,productName,ticketNumber])
                            //
                            //                                            if (!isupdated!){
                            //                                                print("Ticket Number\(ticketNumber) is not updated. Update failure: \(db1?.lastErrorMessage())")
                            //                                            }
                            //                                        } else{
                            //                                            let isinserted = db1?.executeUpdate("INSERT INTO ticketHistory (ticketNumber,lastUpdatedDate,productImage,dealerName,productId,dealerMobile,progressStatus,productName,updatedOn) VALUES (?,?,?,?,?,?,?,?,?)", withArgumentsIn: [ticketNumber,lastUpdatedDate,prodImage,dealername,prodId,contact,progressStatus,productName,updatedOn])
                            //                                            if(!isinserted!){
                            //                                                print("Database failure: \(db1?.lastErrorMessage())")
                            //                                            }
                            //                                        }
                            //                                    }
                            //                                }
                            let fileURL = DBManager.shareInstance.getPath()
                            let db1 = FMDatabase(path: fileURL)
                            self.ticketList.removeAllObjects()
                            db1?.open()
                            if let rs = db1?.executeQuery("select * from ticketHistory  order by lastUpdatedDate DESC", withArgumentsIn:nil) {
                                //            totalrecord.removeAllObjects()
                                //            ticketList.removeAllObjects()
                                while rs.next() {
                                    self.ticketList.addObjects(from: [rs.resultDictionary() as Any])
                                }
                                self.ticketHistoryList = self.ticketList as NSArray
                                if self.ticketHistoryList.count == 0 {
                                    refreshControl.endRefreshing()
                                    self.ticketStatusButton.isHidden = true
                                } else {
                                    self.ticketStatusButton.isHidden = false
                                    self.collectionView.reloadData()
                                    refreshControl.endRefreshing()
                                }
                            }else {
                                refreshControl.endRefreshing()
                                print("select failure: \(db1?.lastErrorMessage())")
                            }
                            
                        }
                        else {
                            
                            //DataManager.shareInstance.showAlert(self, title: errorTitle, message: errorMessage)
                        }
                    }
                }
                else {
                    
                    DispatchQueue.main.async {
                        self.refreshGetEquipmentList(refreshControl)
                        if error?.code != -999 {
                            
                            //DataManager.shareInstance.showAlert(self, title: errorTitle, message: errorMessage)
                        }
                    }
                }
            }
        }
        else {
            DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
        }
    }
    
    //=====================================Pull To Refresh Get Equipment List API==========================================================>
    func refreshGetEquipmentList(_ refreshControl:UIRefreshControl) {
//        let fileURL = DBManager.shareInstance.getPath()
//        let db1 = FMDatabase(path: fileURL)
        var equipmentList : NSArray! = []
        if NetworkChecker.isConnectedToNetwork() {
            var values: Dictionary<String, String> = [:]
            values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber") as? String
            values["platform"] = platform
            values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey") as? String
            let ccIDs = UserAddressesDatabaseModel.shareInstance.getCustomerIDs(values["mobileNumber"]!)
            print(ccIDs)
            values["customerIds"] = ccIDs as String
            DataManager.shareInstance.getDataFromMizeWebService(equipmentListURLMize, dataDictionary:values as NSDictionary) { (result, error) -> Void in
                if error == nil {
                        DispatchQueue.main.async {
                    if let responseDictionary: NSDictionary = result as? NSDictionary {
                        if let responseStatus : String = (responseDictionary.object(forKey: KEY_Status) as? String) {
                            if responseStatus == "success"{
                                EquipmentListModel.shareInstance.parseResponseObject(result)
                                equipmentList = EquipmentListModel.shareInstance.allEquipment
                                EquipmentListDatabaseModel.shareInstance.addProducts(equipmentList)
                                if(equipmentList.count>0){
                                }
                            }else{
                                if let responseError : String = (responseDictionary.object(forKey: "errorMessage") as? String)
                                {
                                    //DataManager.shareInstance.showAlert(self, title: errorTitle, message: responseError)
                                }
                            }
                        }
                    }
                    }
                } else {
                    if error?.code != -999 {
                        //DataManager.shareInstance.showAlert(self, title: errorTitle, message: errorMessage)
                    }
                }
            }
        } else {
            //            DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
        }
    }
    
    
    @objc func reachabilityChanged(_ note: Notification) {
        let reachability = note.object as! Reachability
        if reachability.isReachable{
            if productList.count == 0 {
                DispatchQueue.main.async {
                    self.getProductList()
                }
            }
        } else {
            if productList.count == 0 {
                showNoConnection = true
                DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let screenClass = self.classForCoder.description()
        Analytics.setScreenName("Dashboard Screen", screenClass: screenClass)
        Analytics.logEvent("page_view",parameters: ["page":"Dashboard Screen"])
        
        self.slideMenuController()?.addLeftGestures()
        
        let shouldShowFeedback = PlistManager.sharedInstance.getValueForKey("showFeedback") as! Bool
        if shouldShowFeedback {
            showFeedbackView()
        }else{
            if productList.count > 0 {
//                let refreshControl = UIRefreshControl()
//                self.refreshGetTicketStatus(refreshControl)
            }
        }
        
        //self.collectionView.reloadData()
    }
    
    @objc func getTicketStatusApi() {
        let refreshControl = UIRefreshControl()
        self.refreshGetTicketStatus(refreshControl)
    }
    
    func setNavigationBar() {
        //self.title = "Customer Care"
        let logo = UIImage(named: "bsl_updated_logo")
        let imageView = UIImageView(image:logo)
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        /*
        let nav = self.navigationController?.navigationBar
        nav!.titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.font.rawValue: UIFont(name: fontQuicksandBookRegular, size: 18)!])
        //        nav!.barTintColor = UIColor(netHex: 0x005BA7)
        nav!.barTintColor = UIColor(netHex: 0x246cb0)

        nav!.barStyle = UIBarStyle.black
        nav!.isTranslucent = false
        nav!.tintColor = UIColor.white
         */
        
//        START OF NEW NAVIGATIONBAR CODE
        
        let nav = self.navigationController?.navigationBar
//        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        if #available(iOS 13, *)
        {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(netHex: 0x246cb0)

            // Customizing our navigation bar
            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }else{
            nav!.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            nav!.barTintColor = UIColor(netHex: 0x246cb0)
            nav!.backgroundColor = UIColor(netHex: 0x246cb0)
            nav!.barStyle = UIBarStyle.black
            nav!.isTranslucent = false
            //nav!.tintColor = UIColor.white
        }
        
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.setToolbarHidden(true, animated: false)
        
//        END
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: IMG_ThreeBar), for: UIControl.State())
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.addTarget(self, action: #selector(openSidebarMenu), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        //        let ticketImage   = UIImage(named:IMG_Ticket_Status)!
        //        let addProductImage = UIImage(named:IMG_Edit_Products)!
        //        let ticketStatusButton   = UIBarButtonItem(image: ticketImage,  style: .Plain, target: self, action:#selector(openTicketStatus))
        //        ticketStatusButton.imageInsets = UIEdgeInsetsMake(0, 0, 0, -25.0)
        //        let addProductButton = UIBarButtonItem(image: addProductImage,  style: .Plain, target: self, action: #selector(openAddProducts))
        
        
        
        ticketStatusButton.setImage(UIImage(named: IMG_Ticket_Status), for: UIControl.State())
        ticketStatusButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        ticketStatusButton.addTarget(self, action: #selector(openTicketStatus), for: .touchUpInside)
        //        ticketStatusButton.backgroundColor = UIColor.yellowColor()
        let ticketStatusBarButton = UIBarButtonItem(customView: ticketStatusButton)
        
        let editProductButton = UIButton()
        editProductButton.setImage(UIImage(named: IMG_Edit_Products), for: UIControl.State())
        editProductButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //        editProductButton.backgroundColor = UIColor.yellowColor()
        editProductButton.addTarget(self, action: #selector(openAddProducts), for: .touchUpInside)
        let editBarButton = UIBarButtonItem(customView: editProductButton)
        let naviagtionSpacer = UIBarButtonItem(barButtonSystemItem:UIBarButtonItem.SystemItem.fixedSpace, target:nil, action:nil)
        naviagtionSpacer.width = -10
        navigationItem.rightBarButtonItems = [naviagtionSpacer,editBarButton,ticketStatusBarButton]
        ticketStatusButton.isHidden = true
        
        let callButton = UIButton()
        callButton.setImage(UIImage(named: IMG_Call), for: UIControl.State())
        let appFrame :CGRect =  UIScreen.main.applicationFrame
        callButton.frame = CGRect(x: appFrame.width-75, y: appFrame.height-119, width: 60, height: 60)
        callButton.backgroundColor = UIColor(netHex:App_Theme_Color_HexCode)
        callButton.layer.cornerRadius = callButton.frame.size.height/2
        callButton.layer.shadowColor = UIColor.black.cgColor
        callButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        callButton.layer.masksToBounds = false
        callButton.layer.shadowRadius = 1.0
        callButton.layer.shadowOpacity = 0.5
        callButton.addTarget(self, action: #selector(makeaCall), for: .touchUpInside)
        self.view.addSubview(callButton)
        self.view.bringSubviewToFront(callButton)
        
        //        let addProductImage = UIImage(named: "call")!
        //        let addProductButton = UIBarButtonItem(image: addProductImage,  style: .Plain, target: self, action: #selector(makeaCall))
        //        navigationItem.rightBarButtonItem = addProductButton
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var numOfSections: Int = 0
        if productList.count == 0 && showNoConnection {
            let messageLabel = UILabel(frame: CGRect(x: 0,y: 0,width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
            messageLabel.text = noInternetTitle
            messageLabel.textColor = UIColor(netHex:0x666666)
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont(name: fontQuicksandBookRegular, size: 15)
            messageLabel.sizeToFit()
            collectionView.backgroundView = messageLabel
        } else {
            collectionView.backgroundView = nil
            if self.productList.count == 1 {
                numOfSections = 1
            }else if self.productList.count == 2 {
                numOfSections = 2
            }else if self.productList.count == 3 {
                numOfSections = 2
            }
            else{
                let result : Double = Double(self.productList.count)/2.0
                numOfSections = lround(result)
            }
        }
        return numOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        var numOfRows: Int = 1
        if (self.productList.count == 1){
            numOfRows = 1
        }else if (self.productList.count == 2){
            numOfRows = 1
        }else if self.productList.count == 3 {
            if section == 0 {
                numOfRows = 2
            }else{
                numOfRows = 1
            }
        }
        else{
            if (self.productList.count >= 4 && section > 1){
                
                if (section*2  <= self.productList.count-2){
                    numOfRows = 2
                }else{
                    numOfRows = 1
                }
                
            }else{
                numOfRows = 2
            }
        }
        return numOfRows//self.productList!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if self.productList.count == 1 {
            selectedIndex = 0
        }else if self.productList.count == 2 {
            if indexPath.section == 0 {
                selectedIndex = 0
            }
            else if indexPath.section == 1 {
                selectedIndex = 1
            }
        }else if self.productList.count == 3 {
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                    selectedIndex = 0
                }else if indexPath.row == 1{
                    selectedIndex = 1
                }
            }else if indexPath.section == 1{
                if indexPath.row == 0 {
                    selectedIndex = 2
                }
            }
        }else {
            selectedIndex = indexPath.section*2 + indexPath.row
        }
        cell = collectionView.cellForItem(at: indexPath) as! DashboardCustomCell
        
        self.generateTicket()
    }
    
    //====================================Ticket Status Database======================================================>
    
    @objc func getTicketStatus() {
        let fileURL = DBManager.shareInstance.getPath()
        let db1 = FMDatabase(path: fileURL)
        var totalrecord:NSMutableArray = []
        db1?.open()
        if let rs = db1?.executeQuery("select * from ticketHistory", withArgumentsIn:nil) {
            totalrecord.removeAllObjects()
            ticketList.removeAllObjects()
            while rs.next() {
                totalrecord.addObjects(from: [rs.resultDictionary() as Any])
                self.ticketList.addObjects(from: [rs.resultDictionary() as Any])
            }
            if self.ticketList.count == 0 {
                self.ticketStatusButton.isHidden = true
                // DataManager.shareInstance.showAlert(self, title: "", message: "No ticket history found.")
            } else {
                //self.tableView.reloadData()
                self.ticketStatusButton.isHidden = false
                self.collectionView.reloadData()
            }
            
            //            print(totalrecord.count)
        }else {
            print("select failure: \(db1?.lastErrorMessage())")
        }
        
    }
    
    
    func getTicketHistoryByService() {
        let fileURL = DBManager.shareInstance.getPath()
        let db1 = FMDatabase(path: fileURL)
        let last = UserDefaults.standard.value(forKey: "LastSynced")
        let startTime = Date()
        if NetworkChecker.isConnectedToNetwork() {
            
            var values: Dictionary<String, AnyObject> = [:]
            
            values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
            values["platform"] = platform as AnyObject?
            values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
            // NOTE : THIS IS CALLING FIRST TIME
            values["lastsynced"] = "1950-01-01 00:00:00.000" as AnyObject?
            print(UserDefaults.standard.value(forKey: "LastSynced"))
            print("================================== GET TICKET HISTORY LIST START ::: \(Date().timeIntervalSince(startTime))")
            //values["lastSynced"] = UserDefaults.standard.value(forKey: "LastSynced") as AnyObject?
            DataManager.shareInstance.getDataFromWebService(ticketHistoryURLMize, dataDictionary:values as NSDictionary) { (result, error) -> Void in
                
                print("================================== GET TICKET HISTORY LIST RESPONSE RECEIVED ::: \(Date().timeIntervalSince(startTime))")
                if error == nil {
                    DispatchQueue.main.async {
                        TicketHistoryModel.shareInstance.parseResponseObject(result)
                        let status: String = TicketHistoryModel.shareInstance.status!
                        
                        if status == "success" {
                            self.ticketHistoryList = TicketHistoryModel.shareInstance.tickets!
                            let lastSynced: String = TicketHistoryModel.shareInstance.lastSynced!
                            UserDefaults.standard.setValue(lastSynced, forKey: "LastSynced")
                            UserDefaults.standard.synchronize()
                            // self.sortTicketHistoryList()
                            TicketListModel.shareInstance.addTickets(self.ticketHistoryList)
                            self.getTicketStatus()
//                            if self.ticketList.count == 0 {
//                                self.ticketStatusButton.isHidden = true
//                                // DataManager.shareInstance.showAlert(self, title: "", message: "No ticket history found.")
//                            } else {
//                                //self.tableView.reloadData()
//                                self.ticketStatusButton.isHidden = false
//                            }

                        } else {
                            print("Status Error.")
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        if error?.code != -999 {
                            print("cant")
                            //  DataManager.shareInstance.showAlert(self, title: errorTitle, message: errorMessage)
                        }
                    }
                }
                print("================================== GET TICKET HISTORY LIST RESPONSE SAVED ::: \(Date().timeIntervalSince(startTime))")
            }
        }
    }
    
    
    
    
    
    
    @objc func generateTicket() {
        if cell.progressStatusImage.isHidden {
            
            /*let message = "Do you want to register a complaint?"
             
             let confirmationAlert = UIAlertController(title:message, message:nil, preferredStyle: UIAlertControllerStyle.alert)
             
             confirmationAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
             self.doGenerateTicket()
             }))
             
             confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
             
             }))
             
             self.present(confirmationAlert, animated: true, completion: nil)*/
            //                let isAlreadyGenerated = GenerateTicketModel.shareInstance.isAlreadyGenerated!
            //                if isAlreadyGenerated {
            //                    self.hidePlaceHolderView()
            //
            //                    let controller:FollowupPopupViewController = self.storyboard!.instantiateViewController(withIdentifier: "FollowupPopupView") as! FollowupPopupViewController
            //                    self.present(controller, animated: true, completion: nil)
            //                    //                                controller.view.frame = self.view.bounds;
            //                    //                                controller.view.backgroundColor = UIColor(white: 0.1, alpha: 0.65)
            //                    //                                controller.willMove(toParentViewController: self)
            //                    //                                self.view.addSubview(controller.view)
            //                    //                                self.addChildViewController(controller)
            //                    //self.presentedViewController?.dismiss(animated: true, completion: { _ in })
            //                    //                                controller.didMove(toParentViewController: self)
            //                } else{
            self.isAlreadyGenerated = false
            self.generateNewTicket()
            //                    let data = self.productList[selectedIndex] as? NSDictionary
            //                    let natureOfProblemViewController = self.storyboard?.instantiateViewController(withIdentifier: "NatureOfProblemViewController") as! NatureOfProblemViewController
            //                    natureOfProblemViewController.selectedProductDetails = data
            //                    self.present(natureOfProblemViewController, animated: true, completion: nil)
            //}
        }
        else {
            self.isAlreadyGenerated = true
            //self.alreadyGeneratedTicket = true
            self.generateNewTicket()
            //
            /*let data = self.productList[selectedIndex] as? NSDictionary
             let natureOfProblemViewController = self.storyboard?.instantiateViewController(withIdentifier: "NatureOfProblemViewController") as! NatureOfProblemViewController
             natureOfProblemViewController.selectedProductDetails = data
             self.present(natureOfProblemViewController, animated: true, completion: nil)*/
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor(netHex: 0x666666)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.white
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell : DashboardCustomCell = (collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? DashboardCustomCell)!
        
        var itemIndex:Int = 0
        if self.productList.count == 1 {
            itemIndex = 0
        }else if self.productList.count == 2 {
            if indexPath.section == 0 {
                itemIndex = 0
            }
            else if indexPath.section == 1 {
                itemIndex = 1
                
            }
        }else if self.productList.count == 3 {
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                    itemIndex = 0
                }else if indexPath.row == 1{
                    itemIndex = 1
                }
            }else if indexPath.section == 1{
                if indexPath.row == 0 {
                    itemIndex = 2
                }
            }
        }else {
            itemIndex = indexPath.section*2 + indexPath.row
        }
        
        let data = self.productList[itemIndex] as? NSDictionary
        cell.Label.text = data?["productDisplayName"] as? String
        cell.Label.font = UIFont(name: fontQuicksandBookRegular, size: 16)
        cell.Label.textColor = UIColor(netHex: 0x4F90D9)
        let image = data?["productImage"] as? String
        let imageUrl = URL(string: image!)
        
        cell.imageView.af_setImage(withURL: imageUrl!, placeholderImage: placeholderImage)
        
        cell.progressStatusDot.isHidden = true
        let ticketStatus: NSMutableDictionary = [:]
        ticketStatus.setValue(ticketList, forKey: "ticket")
        TicketHistoryModel.shareInstance.parseResponseObject(ticketStatus)
        if(ticketList.count > 0){
                self.ticketStatusButton.isHidden = false
            
        } else {
            self.ticketStatusButton.isHidden = true
        }
//        if let ticketStatus: NSArray = TicketHistoryModel.shareInstance.tickets{
            if ticketStatus.count>0 {
            
                
                var arrOfTickets = ticketStatus.value(forKey: "ticket") as! NSArray
                
//                for arrTicket in arrOfTickets {
//                    for case let arrTicket as NSDictionary in arrOfTickets {

//                    var filterProductStatusInfo = arrTicket.value(forKey: "progressStatus")

//                }
                
                // IMP
//
                
                
                
                
                
                let filterProductStatusInfo = TicketHistoryModel.shareInstance.productStatus((data!["productId"] as? String)! as NSString)
                
                
                
                if filterProductStatusInfo.allKeys.count>0 {
                    
                    let ifTicketExists = checkTicketAlreadyRegisteredOrNotForProduct(productID: filterProductStatusInfo.object(forKey: "productId")! as! String)
                    //filterProductStatusInfo.object(forKey: "productId")!
                    if ifTicketExists {
                        cell.progressStatusImage.isHidden = false
                    } else {
                        cell.progressStatusImage.isHidden = true
                        //cell.progressStatusDot.backgroundColor = UIColor(netHex: 0xFF9600)
                    }
                    
                    //cell.progressStatusDot.hidden = false
                    //cell.progressStatusImage.isHidden = false
                    
//                    let productStatus = filterProductStatusInfo["progressStatus"] as! String
//                    if(productStatus.trim().caseInsensitiveCompare(statusDispatchedMize) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusDispatchRejectedMize) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusMaterialPendingMize) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusQueuedMize) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusWorkStartedMize) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusAllocatedMize) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusDispatchAcceptedMize) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusInWorkMize) == ComparisonResult.orderedSame){
//                    if (productStatus.trim().caseInsensitiveCompare(statusWorkCompleted) == ComparisonResult.orderedSame ||  productStatus.trim().caseInsensitiveCompare(statusClosed) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusCallCancelled) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusAppointmentFixedForWorkCompletion) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusCallOnHoldObligationDispute) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusCallOnHoldAwaitingCustomerClearance) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusCallAttendedPendingForMaterial) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusWorkStartedAtSite) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusWorkInProcess) == ComparisonResult.orderedSame){
                        
                        //cell.progressStatusDot.backgroundColor = UIColor(netHex: 0x0D8108)
                        //changes- need to hide the dot
                        //cell.progressStatusDot.hidden = true
//                        cell.progressStatusImage.isHidden = false
//                    } else {
//                        cell.progressStatusImage.isHidden = true
//                        //cell.progressStatusDot.backgroundColor = UIColor(netHex: 0xFF9600)
//                    }
                    
                
                }else{
                    //cell.progressStatusDot.hidden = true
                    cell.progressStatusImage.isHidden = true
                    
                }
            }else{
                //cell.progressStatusDot.hidden = true
                cell.progressStatusImage.isHidden = true
                
            }
//        }else{
//            //cell.progressStatusDot.hidden = true
//            cell.progressStatusImage.isHidden = true
//            
//        }
        
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.frame.width-1) / 2), height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        if self.productList.count == 1 {
            let topSpace:CGFloat = (self.collectionView.frame.size.height-140)/2
            let leftSpace:CGFloat = self.collectionView.frame.size.width/4
            return UIEdgeInsets.init(top: topSpace, left: leftSpace, bottom: topSpace, right: leftSpace); //top,left,bottom,right
        }
        if self.productList.count == 2 {
            let leftSpace:CGFloat = self.collectionView.frame.size.width/4
            
            if section == 0{
                let topSpace:CGFloat = (self.collectionView.frame.size.height-280)/6
                return UIEdgeInsets.init(top: topSpace*2, left: leftSpace, bottom: topSpace, right: leftSpace); //top,left,bottom,right
                
            }else{
                let topSpace:CGFloat = (self.collectionView.frame.size.height-280)/6
                return UIEdgeInsets.init(top: topSpace, left: leftSpace, bottom: topSpace*2, right: leftSpace); //top,left,bottom,right
            }
        }
        if self.productList.count == 3 {
            let leftSpace:CGFloat = self.collectionView.frame.size.width/4
            if section == 0{
                let topSpace:CGFloat = (self.collectionView.frame.size.height-280)/2
                return UIEdgeInsets.init(top: topSpace, left: 0, bottom: 0, right: 0); //top,left,bottom,right
                
            }else{
                let topSpace:CGFloat = (self.collectionView.frame.size.height-280)/2
                return UIEdgeInsets.init(top: 0, left: leftSpace, bottom: topSpace, right: leftSpace); //top,left,bottom,right
            }
        }else if self.productList.count == 4 {
            if section == 0{
                let topSpace:CGFloat = (self.collectionView.frame.size.height-280)/2
                return UIEdgeInsets.init(top: topSpace, left: 0, bottom: 0, right: 0); //top,left,bottom,right
                
            }else{
                let topSpace:CGFloat = (self.collectionView.frame.size.height-280)/2
                return UIEdgeInsets.init(top: 0, left: 0, bottom: topSpace, right: 0); //top,left,bottom,right
            }
        }
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0); //top,left,bottom,right
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        animateCell(cell)
    }
    
    func animateCell(_ cell: UICollectionViewCell) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.5
        cell.layer.add(animation, forKey: animation.keyPath)
    }
    
    @objc func openSidebarMenu() {
        self.slideMenuController()?.openLeft()
    }
    
    @objc func moveToNotificationView() {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "NotificationView") as! NotificationViewController
        navigationController?.pushViewController(next, animated: true)
    }
    
    @objc func moveToFAQView() {
        //let next = self.storyboard?.instantiateViewControllerWithIdentifier("FAQView") as! FAQViewController
        let vc : FAQVC =  FAQVC(nibName: "FAQVC", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func moveToHistoryView() {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "HistoryView") as! HistoryViewController
        navigationController?.pushViewController(next, animated: true)
    }
    
    @objc func generateNewTicket() {
        
        if NetworkChecker.isConnectedToNetwork() {
            showPlaceHolderView()
            var values: Dictionary<String, AnyObject> = [:]
            values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
            values["productId"] = productId as AnyObject?
            values["isForcefullyGenerated"] = "true" as AnyObject?
            values["platform"] = platform as AnyObject?
            values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
            
            var user: Dictionary<String, AnyObject> = PlistManager.sharedInstance.getValueForKey("user") as! Dictionary<String, AnyObject>
            values["ibaseNumber"] = user["ibaseNumber"]
            self.hidePlaceHolderView()
            let data = self.productList[selectedIndex] as? NSDictionary
            //EquipmentListDatabaseModel.shareInstance.productData = data
            UserDefaults.standard.removeObject(forKey: "AddCooling")
            if(self.checkItemHasEquipmentList(data?.value(forKey: "productId") as! String)){
                let equipmentListViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisteredDeviceView") as! RegisteredDeviceViewController
                if(self.checkItemEquipmentHasTicketOrNot(data?.value(forKey: "productId") as! String)){
                    equipmentListViewController.isForcefullyGenerated = "true" as AnyObject?
                }else{
                    equipmentListViewController.isForcefullyGenerated = "false" as AnyObject?
                }
                equipmentListViewController.selectedProductDetail = data
                equipmentListViewController.isComingFromDashbord = true
                equipmentListViewController.delegate = self
                navigationController?.pushViewController(equipmentListViewController, animated: true)
            }else{
                if(self.checkTicketAlreadyRegisteredOrNot()){
                    self.isAlreadyGenerated = true
                }else{
                    self.isAlreadyGenerated = false
                }
                if(self.isAlreadyGenerated){
                    self.doGenerateTicket()
                }else{
                    self.presentNatureOfProblemView()
                    }
            }
        } else {
            DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
        }
    }
    
    func checkItemHasEquipmentList(_ productId:String) -> Bool{
        let fileURL = DBManager.shareInstance.getPath()
        let db1 = FMDatabase(path: fileURL)
        db1?.open()
        var activeAddresses = UserAddressesDatabaseModel.shareInstance.getUserAddrress(PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String)
        var customerID = "M3280502140835559"
        
        var queryString : String
        var queryString2 = ""
        
        for case let dict as NSDictionary in activeAddresses {
            // do something with button
            if let customerId = dict["customerId"] as? String {
                customerID = customerId
            }
//            customerID = dict.value(forKey: "customerId") as! String
            queryString = "'" + customerID + "'" + ","
            queryString2.append(queryString)
        }
        
        if !queryString2.isEmpty {
            queryString2.removeLast()
        }
        
        
        //            let Query = "select * from registeredDevice where customerId in '" + customerID + "'"
        
        //select count(equipmentId) from registeredDevice where customerId in ('800000012989','800000013467','800000012622') and productId like 'F1200'

        let Query = "select count(equipmentId) from registeredDevice where customerId in (" + queryString2 + ")" + " and productId like " + "'" + productId + "'"
        print(Query)
        if let productRS = db1?.executeQuery(Query, withArgumentsIn: nil) {
            while productRS.next() {
                if(((productRS.resultDictionary() as NSDictionary).value(forKey: "count(equipmentId)") as! Int) > 0){
                    return true
                }else{
                    return false
                }
            }
        }else {
            print("select failure: \(String(describing: db1?.lastErrorMessage()))")
            return false
        }
        
        
        
        // OLD LOGIC 26/12
//        if let productRS = db1?.executeQuery("select count(equipmentId) from registeredDevice where productId like (?)", withArgumentsIn: [productId]) {
//            while productRS.next() {
//                if(((productRS.resultDictionary() as NSDictionary).value(forKey: "count(equipmentId)") as! Int) > 0){
//                    return true
//                }else{
//                    return false
//                }
//                }
//            }else {
//            print("select failure: \(String(describing: db1?.lastErrorMessage()))")
//            return false
//        }
        return false
    }
    
    func checkItemEquipmentHasTicketOrNot(_ productId:String) -> Bool {
        let fileURL = DBManager.shareInstance.getPath()
        let db1 = FMDatabase(path: fileURL)
        let product = self.productList[selectedIndex] as? NSDictionary
        let tickets: NSDictionary = [:]
        db1?.open()
        if let productRS = db1?.executeQuery("select * from ticketHistory where productId like (?) and modelNo != '' and serialNo != '' and progressStatus == 'Dispatched' OR progressStatus == 'DispatchRejected' OR progressStatus == 'MaterialPending'  OR progressStatus == 'Queued' OR progressStatus == 'WorkStarted' OR progressStatus == 'Allocated' OR progressStatus == 'DispatchAccepted' OR progressStatus == 'InWork'", withArgumentsIn: [product?.value(forKey: "productId") as! String]) {
            while productRS.next() {
               //print("Got ticket like this")
                return true
            }
        }else {
            //print("didnt get Ticket Like this")
            print("select failure: \(String(describing: db1?.lastErrorMessage()))")
            return false
        }
        return false
    }
    
    
    @objc func followUpTicket() {
        //call on call center
        makeaCall()
        
        /*
         if NetworkChecker.isConnectedToNetwork() {
         showPlaceHolderView()
         var values: Dictionary<String, AnyObject> = [:]
         values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
         values["ticketNumber"] = ticketNumber
         values["platform"] = platform
         values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
         DataManager.shareInstance.getDataFromWebService(followTicketURL, dataDictionary:values) { (result, error) -> Void in
         if error == nil {
         dispatch_async(dispatch_get_main_queue()) {
         self.hidePlaceHolderView()
         FollowTicketModel.shareInstance.parseResponseObject(result)
         let message = FollowTicketModel.shareInstance.errorMessage!
         let status = FollowTicketModel.shareInstance.status!
         if status == "error" {
         DataManager.shareInstance.showAlert(self, title: messageTitle, message: message)
         } else {
         //                            let controller:TicketViewController = self.storyboard!.instantiateViewControllerWithIdentifier("TicketView") as! TicketViewController
         //                            self.navigationController?.pushViewController(controller, animated: true)
         //                            controller.productName = FollowTicketModel.shareInstance.productName!
         //                            if let val = productsData[GenerateTicketModel.shareInstance.productId!] {
         //                                controller.productName = val["productDisplayName"]
         //                            }
         //                            controller.ticketNumber = FollowTicketModel.shareInstance.ticketNumber!
         //                            self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.zzz"
         //                            let date = self.dateFormatter.dateFromString(FollowTicketModel.shareInstance.updatedOn!)
         //                            self.dateFormatter.dateFormat = "dd-MM-yyyy"
         //                            controller.date = self.dateFormatter.stringFromDate(date!)
         //                            controller.status = FollowTicketModel.shareInstance.progressStatus!
         DataManager.shareInstance.showAlert(self, title: "", message: "Your request has been registered successfully. Blue Star customer service will get in touch with you shortly")
         self.getTicketStatus()
         }
         }
         } else {
         dispatch_async(dispatch_get_main_queue()) {
         self.hidePlaceHolderView()
         if error.code != -999 {
         DataManager.shareInstance.showAlert(self, title: errorTitle, message: errorMessage)
         }
         }
         }
         }
         } else {
         DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
         }
         */
    }
    
    @objc func refreshProductList() {
        getProductList()
        //showLessProducts()
    }
   //==================================================Ticket Status API=======================================================>
    
//    func getTicketStatus(){
//        
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
//                            //self.sortTicketHistoryList()
//                            if self.ticketHistoryList.count == 0 {
//                                //DataManager.shareInstance.showAlert(self, title: "", message: "No ticket history found.")
//                                self.ticketStatusButton.isHidden = true
//                                
//                            } else {
//                                self.ticketStatusButton.isHidden = false
//                                self.collectionView.reloadData()
//                                //  self.tableView.reloadData()
//                            }
//                            
//                        } else {
//                            // DataManager.shareInstance.showAlert(self, title: errorTitle, message: errorMessage)
//                        }
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        self.hidePlaceHolderView()
//                        if error?.code != -999 {
//                            // DataManager.shareInstance.showAlert(self, title: errorTitle, message: errorMessage)
//                        }
//                    }
//                }
//            }
//        } else {
//            self.hidePlaceHolderView()
//            DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
//        }
//    }
    
    @objc func moveToSafetyTipView() {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "SafetyTipView") as! SafetyTipViewController
        navigationController?.pushViewController(next, animated: true)
    }
    
    @objc func moveToMyAccountView() {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "MyAccountView") as! MyAccountViewController
        navigationController?.pushViewController(next, animated: true)
    }
    @objc func moveToMyAccountAddressView() {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "MyAccountView") as! MyAccountViewController
        next.gotoAddress = true
        navigationController?.pushViewController(next, animated: true)
    }
    @objc func moveToTermAndConditionView() {
        let vc : StatcScreenVC =  StatcScreenVC(nibName: "StatcScreenVC", bundle: nil)
        vc.isPrivacy = false
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func moveToPrivacyPolicy() {
        let vc : StatcScreenVC =  StatcScreenVC(nibName: "StatcScreenVC", bundle: nil)
        vc.isPrivacy = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func moveToAboutUsScreen() {
        let vc : AboutUsVC =  AboutUsVC(nibName: "AboutUsVC", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
        //let next = self.storyboard?.instantiateViewController(withIdentifier: "AboutUs") as! AboutUsVC
        //navigationController?.pushViewController(next, animated: true)
    }
    
    @objc func moveToContactUsScreen() {
        let vc : ContactUsVC =  ContactUsVC(nibName: "ContactUsVC", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func moveToTrainingVideoScreen() {
        ///let vc : self.storyboard?.instantiateViewController(withIdentifier: "TrainingVideoViewController") as! TrainingVideoViewController
        let next = self.storyboard?.instantiateViewController(withIdentifier: "TrainingVideoView") as! TrainingVideoViewController
        navigationController?.pushViewController(next, animated: true)
    }
    @objc func moveToRegisterDeviceScreen() {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "RegisteredDeviceView") as! RegisteredDeviceViewController
        next.isComingFromDashbord = false
        navigationController?.pushViewController(next, animated: true)
    }
    
    func skipButtonPressed() {
        if(self.checkTicketAlreadyRegisteredOrNot()){
            self.isAlreadyGenerated = true
        }else{
            self.isAlreadyGenerated = false
        }
        if(self.isAlreadyGenerated){
        self.doGenerateTicket()
        }else{
            self.presentNatureOfProblemView()
        }
    }
    
    @objc func presentNatureOfProblemView(){
        
        let data = self.productList[selectedIndex] as? NSDictionary
        let natureOfProblemViewController =  self.storyboard?.instantiateViewController(withIdentifier: "NatureOfProblemViewController") as! NatureOfProblemViewController
        if(self.isAlreadyGenerated){
            natureOfProblemViewController.isForcefullyGenerated = "true" as AnyObject?
        }else{
            natureOfProblemViewController.isForcefullyGenerated = "false" as AnyObject?
        }
        
        natureOfProblemViewController.selectedProductDetails = data
        natureOfProblemViewController.isComingFromDashbord = true
        //natureOfProblemViewController.selectedProductNatureOfProblemDetails = data?.value(forKey: "natureOfProblemDetails") as! NSArray
        let mtArray = NSMutableArray(array: data?.value(forKey: "natureOfProblemDetails") as! NSArray)
        natureOfProblemViewController.selectedProductNatureOfProblemDetails =  mtArray
        self.present(natureOfProblemViewController, animated: true, completion: nil)
        
    }
    
    func showFeedbackView() {
        //        self.popupWindow = UIWindow(frame: UfreIScreen.mainScreen().bounds)
        //        let controller:FeedbackViewController = self.storyboard!.instantiateViewControllerWithIdentifier("FeedbackView") as! FeedbackViewController
        //        controller.view.frame = self.popupWindow!.bounds
        //        controller.view.backgroundColor = UIColor(white: 0.1, alpha: 0.65)
        //        self.popupWindow!.rootViewController = controller
        //        self.popupWindow!.makeKeyAndVisible()
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.slideMenuController()?.removeLeftGestures()
        let controller:FeedbackViewController = self.storyboard!.instantiateViewController(withIdentifier: "FeedbackView") as! FeedbackViewController
        controller.view.frame = self.view.bounds;
        controller.view.backgroundColor = UIColor(white: 0.1, alpha: 0.65)
        controller.willMove(toParent: self)
        self.view.addSubview(controller.view)
        self.addChild(controller)
        controller.didMove(toParent: self)
    }
    
    @objc func feedbackViewDidRemove() {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        self.slideMenuController()?.addLeftGestures()
        //        self.popupWindow?.removeFromSuperview()
        //        self.popupWindow?.rootViewController = nil
        //        self.popupWindow?.resignKeyWindow()
        //        self.popupWindow = nil
    }
    
    //==============================================Get Product List Database======================================================>
    func getProductList() {
        let fileURL = DBManager.shareInstance.getPath()
        let db1 = FMDatabase(path: fileURL)
        let products: NSMutableArray = []
        let selectedProducts: NSMutableDictionary = [:]
        let user: Dictionary<String, AnyObject> = PlistManager.sharedInstance.getValueForKey("user") as! Dictionary<String, AnyObject>
        let pid = user["registeredProductsIds"] as! NSString
        //let productIds : NSArray = pid.components(separatedBy: ",")
        
        db1?.open()
        if let productRS = db1?.executeQuery("select * from productList", withArgumentsIn: nil) {
            //            for i in 0..<productIds.count {
            //let productId = productIds.value
            //let productId = productIds.object(at: i) as! String
            
            //            }
            while productRS.next() {
                //                products.addObjects(from: [rs.resultDictionary() as Any])
                //products.addEntries(from: [rs.resultDictionary()])\
                var natureOfProblem: NSMutableArray = []
                let prod = productRS.resultDictionary() as NSDictionary
                
                
                let id = productRS.string(forColumn: "productId") as! String
                //print(id)
                if let natureRS = db1?.executeQuery("select natureId,natureOfProblem,natureOfProblemImage from natureOfProblem where productId like (?)", withArgumentsIn: [id]){
                    //print(natureRS.string(forColumn: "natureId"))
                    while natureRS.next() {
                        natureOfProblem.add(natureRS.resultDictionary())
                        
                    }
                    var mutdict = NSMutableDictionary()
                    mutdict = prod.mutableCopy() as! NSMutableDictionary
                    mutdict.setValue(natureOfProblem, forKey: "natureOfProblemDetails")
                    
                    //  prod.setValue(natureOfProblem, forKey: "natureOfProblemDetails")
                    products.add(mutdict)
                    
                    
                } else {
                    print("Database failure: \(db1?.lastErrorMessage())")
                }
                
            }
            //            print(productRS)
            //            print(products)
            //            print(products.value(forKey: "productId"))
            selectedProducts.setValue(products, forKey: "products")
            //
            //            print(selectedProducts)
            //            print(selectedProducts.value(forKey: "productId"))
            
            ProductListModel.shareInstance.parseResponseObject(selectedProducts)
            self.productList = ProductListModel.shareInstance.products
            self.allProductList = ProductListModel.shareInstance.allProducts
            self.collectionView.reloadData()
            //self.getTicketStatus()
          //  self.registerDeviceToken()
        }else {
            print("select failure: \(String(describing: db1?.lastErrorMessage()))")
        }
        
    }

    func checkTicketAlreadyRegisteredOrNot() ->Bool{
        let fileURL = DBManager.shareInstance.getPath()
        let db1 = FMDatabase(path: fileURL)
        let product = self.productList[selectedIndex] as? NSDictionary
        let tickets: NSDictionary = [:]
        db1?.open()
        /*select * from ticketHistory
        where productId = "F1200"
        and modeNo != "" and serialNo != "" and progressStatus != "Dispatched"
        and progressStatus != "DispatchRejected" and progressStatus != "MaterialPending"
        and progressStatus != "Queued" and progressStatus != "WorkStarted"
        and progressStatus != "Allocated" and progressStatus != "DispatchAccepted"
        and progressStatus != "InWork"*/
        if let productRS = db1?.executeQuery("select * from ticketHistory where (progressStatus == 'Dispatched' OR progressStatus == 'DispatchRejected' OR progressStatus == 'MaterialPending'  OR progressStatus == 'Queued' OR progressStatus == 'WorkStarted' OR progressStatus == 'Allocated' OR progressStatus == 'DispatchAccepted' OR progressStatus == 'InWork') And productId like (?) and modelNo == '' and serialNo == ''", withArgumentsIn: [product?.value(forKey: "productId") as! String]) {
            while productRS.next() {
                //print("Got ticket like this")
                return true
            }
        }else {
            //print("didnt get Ticket Like this")
            print("select failure: \(String(describing: db1?.lastErrorMessage()))")
            return false
        }
        return false
    }
    
    func checkTicketAlreadyRegisteredOrNotForProduct(productID : String) ->Bool{
        let fileURL = DBManager.shareInstance.getPath()
        let db1 = FMDatabase(path: fileURL)
//        let product = self.productList[selectedIndex] as? NSDictionary
        let tickets: NSDictionary = [:]
        db1?.open()
        /*select * from ticketHistory
         where productId = "F1200"
         and modeNo != "" and serialNo != "" and progressStatus != "Dispatched"
         and progressStatus != "DispatchRejected" and progressStatus != "MaterialPending"
         and progressStatus != "Queued" and progressStatus != "WorkStarted"
         and progressStatus != "Allocated" and progressStatus != "DispatchAccepted"
         and progressStatus != "InWork"*/
        if let productRS = db1?.executeQuery("select * from ticketHistory where (progressStatus == 'Dispatched' OR progressStatus == 'DispatchRejected' OR progressStatus == 'MaterialPending'  OR progressStatus == 'Queued' OR progressStatus == 'WorkStarted' OR progressStatus == 'Allocated' OR progressStatus == 'DispatchAccepted' OR progressStatus == 'InWork') And productId like (?) and modelNo == '' and serialNo == ''", withArgumentsIn: [productID]) {
            while productRS.next() {
                //print("Got ticket like this")
                return true
            }
        }else {
            //print("didnt get Ticket Like this")
            print("select failure: \(String(describing: db1?.lastErrorMessage()))")
            return false
        }
        return false
    }
    
    //==================================================Get Product List API===========================================================>
//    func getProductList() {
//        self.showPlaceHolderView()
//        if NetworkChecker.isConnectedToNetwork() {
//            var values: Dictionary<String, AnyObject> = [:]
//            values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
//            values["platform"] = platform as AnyObject?
//            values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
//            DataManager.shareInstance.getDataFromWebService(productListURL, dataDictionary:values as NSDictionary) { (result, error) -> Void in
//                if error == nil {
//                    DispatchQueue.main.async {
//                        self.hidePlaceHolderView()
//                        
//                        
//                        if let responseDictionary: NSDictionary = result as? NSDictionary {
//                            
//                            if let responseStatus : String = (responseDictionary.object(forKey: KEY_Status) as? String)! {
//                                if responseStatus == "success"{
//                                    
//                                    ProductListModel.shareInstance.parseResponseObject(result)
//                                    self.productList = ProductListModel.shareInstance.products!
//                                    self.allProductList = ProductListModel.shareInstance.allProducts!
//                                    //self.sortProductList()
//                                    self.collectionView.reloadData()
//                                    self.getTicketStatus()
//                                    ProductBL.shareInstance.resultProductData =  responseDictionary
//                                    
//                                    //                                    ProductBL.shareInstance.selectedProducts.removeAllObjects()
//                                    //                                    ProductBL.shareInstance.products.removeAllObjects()
//                                    //                                    ProductBL.shareInstance.parseProductDataWithUserAlreadySelectedProducts(result)
//                                    
//                                    
//                                    //                                    self.productList = ProductBL.shareInstance.selectedProducts
//                                    //                                    self.allProductList = ProductBL.shareInstance.products
//                                    //                                    self.sortProductList()
//                                    //                                    self.collectionView.reloadData()
//                                    
//                                }else{
//                                    if let responseError : String = (responseDictionary.object(forKey: "errorMessage") as? String)!
//                                    {
//                                        DataManager.shareInstance.showAlert(self, title: errorTitle, message: responseError)
//                                    }
//                                }
//                                
//                                
//                            }
//                        }
//                        
//                        
//                        //                        ProductListModel.shareInstance.parseResponseObject(result)
//                        //                        let status: String = ProductListModel.shareInstance.status!
//                        //                        if status == "success" {
//                        //                            self.productList = ProductListModel.shareInstance.products!
//                        //                            self.allProductList = ProductListModel.shareInstance.allProducts!
//                        //                            //self.refactorData()
//                        //                            self.sortProductList()
//                        //                            self.collectionView.reloadData()
//                        //                        } else {
//                        //                            DataManager.shareInstance.showAlert(self, title: errorTitle, message: errorMessage)
//                        //                        }
//                        
//                        self.registerDeviceToken()
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
    /*
     func refactorData() {
     let localProductList : NSMutableArray! = []
     let localAllProductList : NSMutableArray! = []
     for apiProduct in productList {
     var newProduct = apiProduct as! Dictionary<String, String>
     var isDispay = "no"
     if let val = productsData[apiProduct["productId"] as! String] {
     newProduct["productname"] = val["productDisplayName"]
     newProduct["displayOnHomeScreen"] = val["displayOnHomeScreen"]
     isDispay = val["displayOnHomeScreen"]!
     }
     if isDispay == "yes" {
     localProductList.addObject(newProduct)
     }
     localAllProductList.addObject(newProduct)
     }
     productList = localProductList
     limitedProductList = localProductList
     allProductList = localAllProductList
     sortProductList()
     collectionView.reloadData()
     }
     */
    
    //MARK:-
    //MARK:- Custom Methods
    
    func sortProductList() {
        self.productList = self.productList.sorted{
            (($0 as! Dictionary<String, String>)["productDisplayName"]) < (($1 as! Dictionary<String, String>)["productDisplayName"])
            } as NSArray!
        //        self.limitedProductList = self.limitedProductList.sort{
        //            (($0 as! Dictionary<String, String>)["productname"]) < (($1 as! Dictionary<String, String>)["productname"])
        //        }
        //        self.allProductList = self.allProductList.sort{
        //            (($0 as! Dictionary<String, String>)["productname"]) < (($1 as! Dictionary<String, String>)["productname"])
        //        }
    }
    
    /*
     func filterContentForSearchText(searchText:NSString) -> NSDictionary
     {
     var filterProductStatusInfo = NSDictionary()
     
     let resultPredicate : NSPredicate = NSPredicate(format: "productId = %@",searchText)
     if let ticketStatus: NSArray = TicketHistoryModel.shareInstance.tickets{
     
     if ticketStatus.count>0 {
     let searchResults = ticketStatus.filteredArrayUsingPredicate(resultPredicate)
     if searchResults.count>0 {
     
     //if any ticket is running for selected product id then show progress strip
     for (index, value) in searchResults.enumerate() {
     
     var product: Dictionary<String, AnyObject> = value as! Dictionary<String, AnyObject>
     
     let productStatus = product["progressStatus"] as! String
     
     if (productStatus.trim().caseInsensitiveCompare(statusWorkCompleted) == NSComparisonResult.OrderedSame ||  productStatus.trim().caseInsensitiveCompare(statusClosed) == NSComparisonResult.OrderedSame || productStatus.trim().caseInsensitiveCompare(statusCallCancelled) == NSComparisonResult.OrderedSame){
     
     filterProductStatusInfo = product
     
     }else{
     filterProductStatusInfo = product;//searchResults.first as! NSDictionary
     break;
     
     }
     }
     
     //filterProductStatusInfo = searchResults.first as! NSDictionary
     }
     }
     }
     return filterProductStatusInfo
     }
     */
    
    @objc func showAllProducts() {
        //        productList = allProductList
        productList = ProductListModel.shareInstance.allProducts
        // sortProductList()
        collectionView.reloadData()
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "FavouriteStar"), for: UIControl.State())
        //rightButton.setTitle("Show Less", forState: .Normal)
        rightButton.titleLabel!.font = UIFont(name: fontQuicksandBookRegular, size: 16)
        rightButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        rightButton.addTarget(self, action: #selector(showLessProducts), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func showLessProducts() {
        //        productList = limitedProductList
        productList = ProductListModel.shareInstance.products
        // sortProductList()
        collectionView.reloadData()
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "Grid"), for: UIControl.State())
        //rightButton.setTitle("Show All", forState: .Normal)
        rightButton.titleLabel!.font = UIFont(name: fontQuicksandBookRegular, size: 16)
        rightButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        rightButton.addTarget(self, action: #selector(showAllProducts), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    //MARK:-
    //MARK:- Rignt Navigation Button Methods
    @objc func makeaCall() {
        let phone = "18002091177"
        if let phoneCallURL:URL = URL(string: "tel://\(phone)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
            }
        }
    }
    
    @objc func openTicketStatus() {
        moveToHistoryView()
    }
    
    @objc func openAddProducts() {
        
        if  ProductBL.shareInstance.resultProductData.allKeys.count > 0{
            ProductBL.shareInstance.selectedProducts.removeAllObjects()
            ProductBL.shareInstance.products.removeAllObjects()
            ProductBL.shareInstance.parseProductDataWithUserAlreadySelectedProducts(ProductBL.shareInstance.resultProductData)
        }
        
        let vc : ProductListPickerVC =  ProductListPickerVC(nibName: "ProductListPickerVC", bundle: nil)
        vc.isFromDashboard = true
        self.present(vc, animated: true, completion: nil)
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
    
//    func doGenerateTicket() {
//        let data = self.productList[selectedIndex] as? NSDictionary
//        if NetworkChecker.isConnectedToNetwork() {
//            self.showPlaceHolderView()
//            var values: Dictionary<String, AnyObject> = [:]
//            values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
//            values["productId"] = data?["productId"] as AnyObject?
//            values["isForcefullyGenerated"] = "true" as AnyObject?
//            values["platform"] = platform as AnyObject?
//            values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
//            var user: Dictionary<String, AnyObject> = PlistManager.sharedInstance.getValueForKey("user") as! Dictionary<String, AnyObject>
//           // values["ibaseNumber"] = user["ibaseNumber"]
//            //values["addressid"] = user["addressid"]
//            // print(user["addressid"])
//            DataManager.shareInstance.getDataFromMizeWebService(generateTicketURLMize, dataDictionary:values as NSDictionary) { (result, error) -> Void in
//                if error == nil {
//                    DispatchQueue.main.async {
//                        self.hidePlaceHolderView()
//                        GenerateTicketModel.shareInstance.parseResponseObject(result)
//                        let message = GenerateTicketModel.shareInstance.errorMessage!
//                        let status = GenerateTicketModel.shareInstance.status!
//                        if status == "error" {
//                            DataManager.shareInstance.showAlert(self, title: messageTitle, message: message)
//                        } else {
//                            self.isAlreadyGenerated = GenerateTicketModel.shareInstance.isAlreadyGenerated!
//                            if self.isAlreadyGenerated {
//                                let controller:FollowupPopupViewController = self.storyboard!.instantiateViewController(withIdentifier: "FollowupPopupView") as! FollowupPopupViewController
//                                controller.view.frame = self.view.bounds;
//                                controller.view.backgroundColor = UIColor(white: 0.1, alpha: 0.65)
//                                controller.willMove(toParentViewController: self)
//                                self.view.addSubview(controller.view)
//                                self.addChildViewController(controller)
//                                controller.didMove(toParentViewController: self)
//                                self.productName = GenerateTicketModel.shareInstance.productName!
//                                //                                if let val = productsData[GenerateTicketModel.shareInstance.productId!] {
//                                //                                    self.productName = val["productDisplayName"]
//                                //                                }
//                                self.productId = GenerateTicketModel.shareInstance.productId!
//                                self.ticketNumber = GenerateTicketModel.shareInstance.ticketNumber!
//                                self.date = GenerateTicketModel.shareInstance.updatedOn!
//                                self.status = GenerateTicketModel.shareInstance.progressStatus!
//                            } else {
////                                let controller:TicketViewController = self.storyboard!.instantiateViewController(withIdentifier: "TicketView") as! TicketViewController
////                                self.navigationController?.pushViewController(controller, animated: true)
////                                controller.productName = GenerateTicketModel.shareInstance.productName!
////                                //                                if let val = productsData[GenerateTicketModel.shareInstance.productId!] {
////                                //                                    controller.productName = val["productDisplayName"]
////                                //                                }
////                                controller.ticketNumber = GenerateTicketModel.shareInstance.ticketNumber!
////                                controller.date = GenerateTicketModel.shareInstance.updatedOn!
////                                controller.status = GenerateTicketModel.shareInstance.progressStatus!
//                                let data = self.productList[self.selectedIndex] as? NSDictionary
//                                let natureOfProblemViewController =  self.storyboard?.instantiateViewController(withIdentifier: "NatureOfProblemViewController") as! NatureOfProblemViewController
//                                if(self.isAlreadyGenerated){
//                                    natureOfProblemViewController.isForcefullyGenerated = "true" as AnyObject?
//                                }else{
//                                    natureOfProblemViewController.isForcefullyGenerated = "false" as AnyObject?
//                                }
//
//                                natureOfProblemViewController.selectedProductDetails = data
//                                natureOfProblemViewController.isComingFromDashbord = true
//                                natureOfProblemViewController.selectedProductNatureOfProblemDetails = data?.value(forKey: "natureOfProblemDetails") as! NSArray
//                                self.present(natureOfProblemViewController, animated: true, completion: nil)
//                            }
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
//            DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
//        }
//    }
    
    
    
    
    @objc func doGenerateTicket(){
        let data = self.productList[selectedIndex] as? NSDictionary
                    //self.productName = GenerateTicketModel.shareInstance.productName!
                    //                                if let val = productsData[GenerateTicketModel.shareInstance.productId!] {
                    //                                    self.productName = val["productDisplayName"]
                    //                                }
                   // self.productId = GenerateTicketModel.shareInstance.productId!
                    //self.ticketNumber = GenerateTicketModel.shareInstance.ticketNumber!
                    //self.date = GenerateTicketModel.shareInstance.updatedOn!
                    //self.status = GenerateTicketModel.shareInstance.progressStatus!
        self.productName = data?.value(forKey: "productDisplayName") as! String
        self.productId = data?.value(forKey: "productId") as! String
        self.isAlreadyGenerated = true
        if self.isAlreadyGenerated {
            let controller:FollowupPopupViewController = self.storyboard!.instantiateViewController(withIdentifier: "FollowupPopupView") as! FollowupPopupViewController
            controller.view.frame = self.view.bounds;
            controller.view.backgroundColor = UIColor(white: 0.1, alpha: 0.65)
            controller.willMove(toParent: self)
            self.view.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)
//            self.productName = GenerateTicketModel.shareInstance.productName!
//            //                                if let val = productsData[GenerateTicketModel.shareInstance.productId!] {
//            //                                    self.productName = val["productDisplayName"]
//            //                                }
//            self.productId = GenerateTicketModel.shareInstance.productId!
//            self.ticketNumber = GenerateTicketModel.shareInstance.ticketNumber!
//            self.date = GenerateTicketModel.shareInstance.updatedOn!
//            self.status = GenerateTicketModel.shareInstance.progressStatus!
        }
    }
    
    func registerDeviceToken() {
        let deviceToken = PlistManager.sharedInstance.getValueForKey("deviceToken") as? String
        if deviceToken != nil {
            if NetworkChecker.isConnectedToNetwork() {
                var values: Dictionary<String, AnyObject> = [:]
                values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
                values["platform"] = platform as AnyObject?
                values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
                values["deviceToken"] = deviceToken as AnyObject?
                DataManager.shareInstance.getDataFromWebService(registerDeviceTokenURL, dataDictionary:values as NSDictionary) { (result, error) -> Void in
                    if error == nil {
                        DispatchQueue.main.async {
                            RegisterDeviceTokenModel.shareInstance.parseResponseObject(result)
                            let status = RegisterDeviceTokenModel.shareInstance.status!
                            if status != "error" {
                                PlistManager.sharedInstance.saveValue(true as AnyObject, forKey: "deviceTokenRegistered")
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func displayTicketView(notification: NSNotification){
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "TicketView") as! TicketViewController
        controller.productName = GenerateTicketModel.shareInstance.productName!
        controller.ticketNumber = GenerateTicketModel.shareInstance.ticketNumber!
        controller.date = GenerateTicketModel.shareInstance.updatedOn!
        controller.status = GenerateTicketModel.shareInstance.progressStatus!
        controller.productId = GenerateTicketModel.shareInstance.productId!
        controller.isAlreadyGenerated = GenerateTicketModel.shareInstance.isAlreadyGenerated!
        if(GenerateTicketModel.shareInstance.modelNo != "" || GenerateTicketModel.shareInstance.modelNo != ""){
            controller.modelNo = GenerateTicketModel.shareInstance.modelNo!
            controller.serialNo = GenerateTicketModel.shareInstance.serialNo!
        }
        controller.productImage = self.productImage as String?
        
        //controller.updatedOn = GenerateTicketModel.shareInstance.updates!
        let dict = notification.object as! NSDictionary
        controller.displayAddress = dict
        //self.present(controller, animated: true, completion: nil)
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
