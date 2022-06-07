 //
//  AppDelegate.swift
//  BlueStar
//
//  Created by tarun.kapil on 18/07/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import BRYXBanner
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import IQKeyboardManagerSwift
import FirebaseInAppMessaging
 import Foundation
 import SystemConfiguration

@UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {
    
    var window: UIWindow?
    var storyboard : UIStoryboard?
    var applications :UIApplication?
    var ticketHistoryList : NSArray! = []
    let gcmMessageIDKey = "gcm.message_id"
    var reachability = Reachability()
    var alert = UIAlertController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        // analytic already included
        FirebaseApp.configure()

        Messaging.messaging().delegate = self
        Analytics.setAnalyticsCollectionEnabled(true)
//       UIApplication.shared.applicationIconBadgeNumber = 0
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
                NotificationCenter.default.addObserver(self, selector: #selector(self.refreshToken(notification:)), name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
        
       // registerForPushNotifications(application)
        PlistManager.sharedInstance.startPlistManager()
        DBManager.shareInstance.startDBManager()
        //        UserDefaults.standard.setValue(nil, forKey: "LastSynced")
        //        UserDefaults.standard.synchronize()
        applications = application
        
        
        let registered = PlistManager.sharedInstance.getValueForKey("registered") as! Bool
        let user = PlistManager.sharedInstance.getValueForKey("user") as? NSDictionary
        self.storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let isTicket : Bool
        //        DispatchQueue.main.async(execute: self.getProductList())
        //DispatchQueue.main.async {
        //    self.getProductList()
        // }
        
        if registered {
            //            if let pin = user!["pin"] {
            //                if pin as! String != "" {
            //                    self.window?.rootViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EnterPinView")
            //                } else {
            //                    let mainVC = self.storyboard?.instantiateViewControllerWithIdentifier("DashboardView")
            //                    let SideBarVC = self.storyboard?.instantiateViewControllerWithIdentifier("SidebarMenu")
            //
            //                    let nvc: UINavigationController = UINavigationController(rootViewController: mainVC!)
            //
            //                    let slideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: SideBarVC!)
            //                    self.window?.rootViewController = slideMenuController
            //                    self.window?.makeKeyAndVisible()
            //                }
            //            } else {
            
            //                let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardView")
            //                let SideBarVC = self.storyboard?.instantiateViewController(withIdentifier: "SidebarMenu")
            //
            //                let nvc: UINavigationController = UINavigationController(rootViewController: mainVC!)
            //
            //                let slideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: SideBarVC!)
            //                self.window?.rootViewController = slideMenuController
            //                self.window?.makeKeyAndVisible()
            isTicket = true
            self.dispDashOrNumberView()

            self.getProductList(isTicket)
            //self.getTicketHistory()
            //            }
        } else{

            let SideBarVC = self.storyboard?.instantiateViewController(withIdentifier: "EnterNumberView")
            self.window?.rootViewController = SideBarVC
            self.window?.makeKeyAndVisible()
            
        }
        
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        
        if let notification = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: AnyObject] {
           // print(notification)
            //let aps = notification["aps"] as! [String: AnyObject]
            //print(aps)
            saveNotification(notification)
        }
        
        //sleep(2)
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
//        do {
//            try reachability = Reachability();
//            try reachability?.startNotifier()
//        } catch {
//            print("could not start reachability notifier")
//        }
//            let timer = Timer.scheduledTimer(timeInterval: 3.5, target: self, selector: #selector(self.checkConnection), userInfo: nil, repeats: true)
        
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 3.0, execute: {
            self.checkConnection()
        })
    }
        
        
    func checkConnection() {
        if #available(iOS 10, *) {
            var net = self.isInternetAvailableNew()
            if net {
                print("INTERNET AVAILABLE")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    self.alert.dismiss(animated: true, completion: nil)
                })
                forceUpdateApp()
                //alert.dismiss(animated: true, completion: nil)
                //UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
                //UIApplication.shared.keyWindow?.rootViewController?.dismiss
                //UIApplication.shared.keyWindow?.remo
            } else {
                DispatchQueue.main.async {
                    print("NO INTERNET")
                    self.alert = UIAlertController(title: "No internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertController.Style.alert)
                    UIApplication.shared.keyWindow?.rootViewController?.present(self.alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func reachabilityChanged(_ note: Notification) {
        let reachability = note.object as! Reachability
        if reachability.isReachable{
            print("NET AVAILABLE")
        } else {
            print("NET NOT AVAILABLE")
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != UIUserNotificationType() {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
//        var tokenString = ""
//        for i in 0..<deviceToken.count {
//            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
//        }
//                 Messaging.messaging().apnsToken = deviceToken
//        print("Device Token:", tokenString)
//        PlistManager.sharedInstance.saveValue(tokenString as AnyObject, forKey: "deviceToken")
//        let deviceTokenRegistered = PlistManager.sharedInstance.getValueForKey("deviceTokenRegistered") as! Bool
//        let userRegistered = PlistManager.sharedInstance.getValueForKey("registered") as! Bool
//        if !deviceTokenRegistered && userRegistered {
//            if NetworkChecker.isConnectedToNetwork() {
//                var values: Dictionary<String, AnyObject> = [:]
//                values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
//                values["platform"] = platform as AnyObject?
//                values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
//                values["deviceToken"] = tokenString as AnyObject?
//                DataManager.shareInstance.getDataFromWebService(registerDeviceTokenURL, dataDictionary:values as NSDictionary) { (result, error) -> Void in
//                    if error == nil {
//                        DispatchQueue.main.async {
//                            RegisterDeviceTokenModel.shareInstance.parseResponseObject(result)
//                            let status = RegisterDeviceTokenModel.shareInstance.status!
//                            if status != "error" {
//                                PlistManager.sharedInstance.saveValue(true as AnyObject, forKey: "deviceTokenRegistered")
//                            }
//                        }
//                    }
//                }
//            }
//        }
    }
    //======================================Ticket Status Api=====================================================>
    func getTicketHistory() {
        let fileURL = DBManager.shareInstance.getPath()
        let db1 = FMDatabase(path: fileURL)
        //                        UserDefaults.standard.set("", forKey: "LastSynced")
        //                        UserDefaults.standard.synchronize()
        //         print(UserDefaults.standard.value(forKey: "LastSynced"))
        //       UserDefaults.standard.setValue(nil, forKey: "LastSynced")
        //        UserDefaults.standard.synchronize()
        //        if(UserDefaults.standard.value(forKey: "LastSynced") == nil){
        //               print("UserDefault nil")
        //        }
        let last = UserDefaults.standard.value(forKey: "LastSynced")
        let startTime = Date()
        if NetworkChecker.isConnectedToNetwork() {
            
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
            
            //            if(UserDefaults.standard.value(forKey: "LastSynced") == nil ){
            //                print("UserDefault nil")
            //            }
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
                            //                            if self.ticketHistoryList.count > 0 {
                            //                                var totalTicket = self.ticketHistoryList.count
                            //                               // print("sdbsvbd\(totalTicket)")
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
                            //                                    db1?.open()
                            //                                    if let rs = db1?.executeQuery("select * from ticketHistory where ticketNumber like '?'  ", withArgumentsIn:[ticketNumber]) {
                            //                                        if(rs.next())
                            //                                        {
                            //                                             let isupdated = db1?.executeUpdate("update ticketHistory set lastUpdatedDate = ? ,productImage  = ? ,dealerName = ? ,productId = ? ,dealerMobile = ? ,progressStatus = ? ,productName = ? where ticketNumber = ?", withArgumentsIn: [lastUpdatedDate,prodImage,dealername,prodId,contact,progressStatus,productName,ticketNumber])
                            //                                                if (!isupdated!){
                            //                                                    print("Ticket Number\(ticketNumber) is not updated. Update failure: \(db1?.lastErrorMessage())")
                            //                                                }
                            //                                        } else{
                            //                                            let isinserted = db1?.executeUpdate("INSERT INTO ticketHistory (ticketNumber,lastUpdatedDate,productImage,dealerName,productId,dealerMobile,progressStatus,productName) VALUES (?,?,?,?,?,?,?,?)", withArgumentsIn: [ticketNumber,lastUpdatedDate,prodImage,dealername,prodId,contact,progressStatus,productName])
                            //                                            if(!isinserted!){
                            //                                                print("Database failure: \(db1?.lastErrorMessage())")
                            //                                            }
                            //                                        }
                            //                                    }
                            //                                }
                            //                                //DataManager.shareInstance.showAlert(self, title: "", message: "No ticket history found.")
                            //                            }
                            //lastsyncresponse
                        } else {
                            
                            print("Status Error.")
                            //lastsyncresponse
                            //DataManager.shareInstance.showAlert(self, title: errorTitle, message: errorMessage)
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
                DispatchQueue.main.async {
                    //self.dispDashBoradView()
                    let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardView")
                    let SideBarVC = self.storyboard?.instantiateViewController(withIdentifier: "SidebarMenu")
                    
                    let nvc: UINavigationController = UINavigationController(rootViewController: mainVC!)
                    
                    let slideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: SideBarVC!)
                    self.window?.rootViewController = slideMenuController
                    self.window?.makeKeyAndVisible()
                }
            }
        } else {
            print("No Internet")
            DispatchQueue.main.async {
                //self.dispDashBoradView()
                let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardView")
                let SideBarVC = self.storyboard?.instantiateViewController(withIdentifier: "SidebarMenu")
                
                let nvc: UINavigationController = UINavigationController(rootViewController: mainVC!)
                
                let slideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: SideBarVC!)
                self.window?.rootViewController = slideMenuController
                self.window?.makeKeyAndVisible()
            }
            // DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
        }
        db1?.close()
    }
    
    func dispDashBoradView(){
        let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardView")
        let SideBarVC = self.storyboard?.instantiateViewController(withIdentifier: "SidebarMenu")
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainVC!)
        
        let slideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: SideBarVC!)
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
        
    }
    
    //======================================Product List Api=====================================================>
    func getProductList(_ isTicket: Bool) {
        let fileURL = DBManager.shareInstance.getPath()
        let db1 = FMDatabase(path: fileURL)
        var allProductList : NSArray! = []
        var productList : NSArray! = []
        if NetworkChecker.isConnectedToNetwork() {
            let startTime = Date()
            print("================================== GET PRODUCT LIST START ::: \(startTime)")
            var values: Dictionary<String, AnyObject> = [:]
            values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
            values["platform"] = platform as AnyObject?
            values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
            DataManager.shareInstance.getDataFromWebService(productListURLMize, dataDictionary:values as NSDictionary) { (result, error) -> Void in
                print("================================== GET PRODUCT LIST RESPONSE RECEIVED ::: \(Date().timeIntervalSince(startTime))")
                if error == nil {
                    //       DispatchQueue.main.async {
                    if let responseDictionary: NSDictionary = result as? NSDictionary {
                        if let responseStatus : String = (responseDictionary.object(forKey: KEY_Status) as? String) {
                            if responseStatus == "success"{
                                
                                ProductListModel.shareInstance.parseResponseObject(result)
                                productList = ProductListModel.shareInstance.products!
                                allProductList = ProductListModel.shareInstance.allProducts!
                                ProductBL.shareInstance.resultProductData =  responseDictionary
                                print(productList.value(forKey: "productId"))
                                db1?.open()
                                ProductListDatabaseModel.shareInstance.addProducts(allProductList)
                                
                                ProductBL.shareInstance.parseResponseObject(responseDictionary)
                                print("================================== GET PRODUCT LIST RESPONSE SAVED ::: \(Date().timeIntervalSince(startTime))")
                            }else{
//                                if let responseError : String = (responseDictionary.object(forKey: "errorMessage") as? String)!
//                                {
//                                    //                                        DataManager.shareInstance.showAlert(self, title: errorTitle, message: responseError)
//                                }
                            }
                        }
                    }
                    
                //    self.registerDeviceToken()
                    //             }
                } else {
                    if error?.code != -999 {
                        //                            DataManager.shareInstance.showAlert(self, title: errorTitle, message: errorMessage)
                    }
                }
                
//                self.dispDashOrNumberView()
                
                /*
                if(isTicket == true)
                {
                    self.getTicketHistory()
                }else {
                    DispatchQueue.main.async {
                        // self.dispDashOrNumberView()
//                        let registered = PlistManager.sharedInstance.getValueForKey("registered") as! Bool
//                        if registered {
//                            let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardView")
//                            let SideBarVC = self.storyboard?.instantiateViewController(withIdentifier: "SidebarMenu")
//
//                            let nvc: UINavigationController = UINavigationController(rootViewController: mainVC!)
//
//                            let slideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: SideBarVC!)
//                            self.window?.rootViewController = slideMenuController
//                            self.window?.makeKeyAndVisible()
//                        } else {
                            let SideBarVC = self.storyboard?.instantiateViewController(withIdentifier: "EnterNumberView")

                            // let nvc: UINavigationController = UINavigationController(rootViewController: mainVC!)
                            //  let slideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: SideBarVC!)
                            self.window?.rootViewController = SideBarVC
                            self.window?.makeKeyAndVisible() // ZYZZ
                        
//                            let controller:RegistrationViewController = self.storyboard!.instantiateViewController(withIdentifier: "RegistrationView") as! RegistrationViewController
//                            self.window?.rootViewController = controller
//                            self.window?.makeKeyAndVisible()

//                        }
                        
                    }
                    
                }
                
            */
            }
            print("================================== GET PRODUCT LIST END :::\(Date().timeIntervalSince(startTime))")
        } else {
            /************************* NO INTERNET CONNECTION  ***********************/
            DispatchQueue.main.async {
                let registered = PlistManager.sharedInstance.getValueForKey("registered") as! Bool
                if registered {
                    let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardView")
                    let SideBarVC = self.storyboard?.instantiateViewController(withIdentifier: "SidebarMenu")
                    
                    let nvc: UINavigationController = UINavigationController(rootViewController: mainVC!)
                    
                    let slideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: SideBarVC!)
                    self.window?.rootViewController = slideMenuController
                    self.window?.makeKeyAndVisible()
                } else {
                    let SideBarVC = self.storyboard?.instantiateViewController(withIdentifier: "EnterNumberView")
                    
                    // let nvc: UINavigationController = UINavigationController(rootViewController: mainVC!)
                    
                    //  let slideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: SideBarVC!)
                    self.window?.rootViewController = SideBarVC
                    self.window?.makeKeyAndVisible()
                }
            }
            //            DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
        }
        
    }
    
    func dispDashOrNumberView(){
        DispatchQueue.main.async {
            let startTime = Date()
            print("================================== DISPLAY PRODUCT LIST START ::: \(startTime)")
            let registered = PlistManager.sharedInstance.getValueForKey("registered") as! Bool
            if registered {
                let user = PlistManager.sharedInstance.getValueForKey("user") as? NSDictionary
                print(user)
                var gend = ""
                if let gender = user?.value(forKey: "gender"){
                    gend = gender as! String
                }
                var age = ""
                if let ageGrp = user?.value(forKey: "age"){
                    age = ageGrp as! String
                }
                if(gend.count <= 0 || age.count <= 0){
                    let SideBarVC = self.storyboard?.instantiateViewController(withIdentifier: "EnterNumberView")
                    
                    // let nvc: UINavigationController = UINavigationController(rootViewController: mainVC!)
                    
                    //  let slideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: SideBarVC!)
                    self.window?.rootViewController = SideBarVC
                    self.window?.makeKeyAndVisible()
                    let controller:RegistrationViewController = self.storyboard!.instantiateViewController(withIdentifier: "RegistrationView") as! RegistrationViewController
                    controller.isFirtTimeHide = true
                    controller.view.frame = (self.window?.rootViewController?.view.bounds)!;
                    controller.willMove(toParent: self.window?.rootViewController)
                    self.window?.rootViewController?.view.addSubview(controller.view)
                    self.window?.rootViewController?.addChild(controller)
                    controller.didMove(toParent: self.window?.rootViewController)
                }else{
                    let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardView")
                    let SideBarVC = self.storyboard?.instantiateViewController(withIdentifier: "SidebarMenu")
                    
                    let nvc: UINavigationController = UINavigationController(rootViewController: mainVC!)
                    
                    let slideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: SideBarVC!)
                    self.window?.rootViewController = slideMenuController
                    self.window?.makeKeyAndVisible()
                }
            } else {
                let SideBarVC = self.storyboard?.instantiateViewController(withIdentifier: "EnterNumberView")
                
                // let nvc: UINavigationController = UINavigationController(rootViewController: mainVC!)
                
                //  let slideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: SideBarVC!)
                self.window?.rootViewController = SideBarVC
                self.window?.makeKeyAndVisible()
            }
            print("================================== DISPLAY PRODUCT LIST END ::: \(Date().timeIntervalSince(startTime))")
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
    
    @objc func refreshToken(notification: NSNotification) {
        _ = notification.object//InstanceID.instanceID().token()!
        print("*****\(notification)*****")
        
        fbHandler()
    }
    
    func fbHandler(){
        // Messaging.messaging().shouldEstablishDirectChannel = true
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:", error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print(userInfo)
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        let notification = userInfo as? [String: AnyObject]
        let aps = userInfo["aps"] as! [String: AnyObject]
        let message = aps["alert"] as? String
        //print(aps)
        saveNotification(notification!)
        let banner = Banner(title: "", subtitle: message!, image: nil, backgroundColor: UIColor(netHex: 0x246cb0))
        banner.dismissesOnTap = true
        banner.show(duration: 3.0)
    }
    
    func saveNotification(_ notification: [String: AnyObject]) {
        let ticketStatus = notification["ticketStatus"] as? String
        let ticketNumber = notification["ticketNumber"] as? String
        if ticketStatus != nil && ticketStatus != "" && ticketStatus?.lowercased() == "resolved" {
            if ticketNumber != nil && ticketNumber != "" {
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMMM hh:mm a"
                let newNotification = ["ticketNumber":ticketNumber!, "ticketStatus":ticketStatus!, "date":dateFormatter.string(from: date)]
                let notificationsList = PlistManager.sharedInstance.getValueForKey("notificationList") as! NSMutableArray
                notificationsList.add(newNotification)
                PlistManager.sharedInstance.saveValue(true as AnyObject, forKey: "showFeedback")
                PlistManager.sharedInstance.saveValue(notificationsList, forKey: "notificationList")
            }
        }
    }
    
    func logoutFromApp() {
        PlistManager.sharedInstance.removeItemForKey("authKey")
        PlistManager.sharedInstance.removeItemForKey("mobileNumber")
        PlistManager.sharedInstance.saveValue(false as AnyObject, forKey: "alreadyRegisteredUser")
        PlistManager.sharedInstance.saveValue(false as AnyObject, forKey: "deviceTokenRegistered")
        PlistManager.sharedInstance.saveValue(false as AnyObject, forKey: "registered")
        PlistManager.sharedInstance.saveValue(false as AnyObject, forKey: "showFeedback")
        ProductBL.shareInstance.selectedProducts.removeAllObjects()
        ProductBL.shareInstance.products.removeAllObjects()
        TicketHistoryModel.shareInstance.tickets = nil
        TicketListModel.shareInstance.clearDB()
        verifyOTPModel.shareInstance.user = nil
        UserDefaults.standard.setValue(nil, forKey: "LastSynced")
        UserDefaults.standard.synchronize()
        PlistManager.sharedInstance.removeItemForKey("user")
        TicketListModel.shareInstance.clearDBTickets()
        let notificationsList: NSArray = []
        PlistManager.sharedInstance.saveValue(notificationsList, forKey: "notificationList")
        self.window?.rootViewController = nil
        self.storyboard = UIStoryboard(name: "Main", bundle: Bundle.main);
        self.window?.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "EnterNumberView");
        applications?.unregisterForRemoteNotifications()
    }
    
    func registerForPushNotifications(_ application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(types: [.sound, .alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    func unRegisterForPushNotifications(_ application: UIApplication) {
        //   application.cancelAllLocalNotifications()
        //application.unRegisterForPushNotifications
    }
    
    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
    func forceUpdateApp() {
        if NetworkChecker.isConnectedToNetwork() {
            let startTime = Date()
            print("================================== FORCE UPDATE START ::: \(startTime)")
            var values: Dictionary<String, AnyObject> = [:]
            values["platform"] = platform as AnyObject?
//            values["platform"] = "abc" as AnyObject

            
            DataManager.shareInstance.forceupdateAPI(forceUpdateURL, dataDictionary:values as NSDictionary) { (result, error) -> Void in
                if error == nil {
                    DispatchQueue.main.async {
                        var status : String?
                        if let responseDictionary: NSDictionary = result as? NSDictionary {
                            if(checkKeyExist(KEY_Status, dictionary: responseDictionary)) {
                                let responseStatus : String = (responseDictionary.object(forKey: KEY_Status) as! String)
                                status = responseStatus
                                if status == "success" {
                                    if(checkKeyExist(KEY_CurrentVersion, dictionary: responseDictionary)) {
                                        let currentVersion : String = (responseDictionary.object(forKey: KEY_CurrentVersion) as? String)!
                                        print(currentVersion)
                                        
                                        let currentVersionOnServer: Float = (currentVersion as NSString).floatValue
                                        var currentVersionOnServerInt:Int = Int(currentVersionOnServer)
                                        print(currentVersionOnServerInt)
                                        // IMP - FOR TESTING ONLY
//                                        currentVersionOnServerInt = 1
                                        
                                        // Get app verison and convert to int for comparison with version on sever
                                        let currentAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                                        let currentAppVersionFloat = (currentAppVersion! as NSString).floatValue
                                        print(currentAppVersion!)
                                        let currentAppVersionInt:Int = Int(currentAppVersionFloat)
                                        print(currentAppVersionInt)
                                        
                                        if currentVersionOnServer > currentAppVersionFloat {

                                        let alertController = UIAlertController(title: "Update", message: "Update app to proceed.", preferredStyle: .alert)
                                        let action1 = UIAlertAction(title: "Update", style: .cancel) { (action:UIAlertAction) in
                                            //itms-apps://itunes.apple.com/app/bars/id706081574
                                            //https://itunes.apple.com/in/app/customer-care/id1192675631?mt=8
                                            UIApplication.shared.openURL(NSURL(string: "https://itunes.apple.com/in/app/customer-care/id1192675631?mt=8")! as URL)
                                        }
                                        
                                        // Add Cancel button only for soft updates
                                        if currentVersionOnServerInt <= currentAppVersionInt  {
                                            let action2 = UIAlertAction(title: "Skip", style: .default) { (action:UIAlertAction) in
                                                
                                            }
                                            alertController.addAction(action2)
                                        }
                                        alertController.addAction(action1)
                                        //                                        self.present(alertController, animated: true, completion: nil)
                                        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                                    }
                                }
                                }
                                
                            } else {
                                print("FORCE UPDATE API FAILED")
                            }
                        }
                    }
                }
            }
            print("================================== FORCE UPDATE END ::: \(Date().timeIntervalSince(startTime))")
        }
    }
    
}

 @available(iOS 10, *)
 extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([.alert, .badge, .sound])
    }
    
    //    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
    //
    //    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        completionHandler()
    }
    
    func isInternetAvailableNew() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
 }

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
        /**
         Use this to know the current view controller
         if let topController = UIApplication.topViewController() {
             print("The view controller you're looking at is: \(topController)")
         }
         */
    }
}
