//
//  PopUpViewController.swift
//  BlueStar
//
//  Created by tarun.kapil on 18/07/16.
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


class PopUpViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var process: UIActivityIndicatorView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timerMessageLabel: UILabel!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var OTPBackgroundView: UIView!
    @IBOutlet weak var OTPTextField: UITextField!
    @IBOutlet weak var regenerateOTPButton: UIButton!
    @IBOutlet weak var popupButton: UIButton!
    @IBOutlet weak var popupCloseButton: UIButton!
    var  counter = 30
    var myTimer:Timer!
    var status: String!
    var ticketHistoryList : NSArray! = []
    
    override func viewDidLoad() {
        popupView.layer.cornerRadius = 12
        OTPTextField.delegate = self
        messageLabel.textColor = UIColor(netHex: 0x4F90D9)
        self.setTimer()
        
        let nc = NotificationCenter.default
        if #available(iOS 12.0, *) {
//            OTPTextField.textContentType = .pass
            OTPTextField.textContentType = UITextContentType.oneTimeCode
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.OTPTextField.becomeFirstResponder()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let screenClass = self.classForCoder.description()
        Analytics.setScreenName("Enter OTP Screen", screenClass: screenClass)
        Analytics.logEvent("page_view",parameters: ["page":"Enter OTP Screen"])
    }
    func navigateToRegistration() {
        DispatchQueue.main.async {
            PlistManager.sharedInstance.saveValue(false as AnyObject, forKey: "alreadyRegisteredUser")
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name(rawValue: "showRegistrationView"), object: nil)
        }
    }
    func setTimer() -> Void {
        process.startAnimating()
        regenerateOTPButton.tintColor=UIColor.lightGray
        regenerateOTPButton.isEnabled = false
        regenerateOTPButton.isHidden=true
        timeLabel.isHidden=false
        myTimer=Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(PopUpViewController.enableButton), userInfo: nil, repeats: true)
    }
    override func viewDidLayoutSubviews() {
        //counter=30
        OTPTextField.textColor = UIColor(netHex: 0x666666)
        OTPTextField.attributedPlaceholder = NSAttributedString(string:"OTP", attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(netHex: 0x666666)]))
        OTPTextField.backgroundColor = UIColor(netHex: 0xF1F1F2)
        OTPBackgroundView.backgroundColor = UIColor(netHex: 0xF1F1F2)
        
        //regenerateOTPButton.tintColor = UIColor(netHex: 0x4F90D9)
        regenerateOTPButton.layer.cornerRadius = 2
        regenerateOTPButton.layer.borderWidth = 0
        regenerateOTPButton.layer.borderColor = UIColor(netHex: 0x4F90D9).cgColor
        OTPBackgroundView.layer.cornerRadius = 5
        popupButton.setPreferences()
        //timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeout), userInfo: nil, repeats: true)
        
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 6
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= maxLength
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func RegenerateOTPButtonAction(_ sender: AnyObject) {
        counter=30
        timerMessageLabel.text = "Waiting for OTP"
        myTimer.invalidate()
        regenerateOTPButton.isHidden=true
        OTPTextField.text = ""
        if NetworkChecker.isConnectedToNetwork() {
            showPlaceHolderView()
            var values: Dictionary<String, AnyObject> = [:]
            values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String as AnyObject?
            values["platform"] = platform as AnyObject?
            DataManager.shareInstance.getDataFromWebService(requestOTPURLMize, dataDictionary:values as NSDictionary) { (result, error) -> Void in
                if error == nil {
                    DispatchQueue.main.async {
                        self.hidePlaceHolderView()
                        DataManager.shareInstance.showAlert(self, title: messageTitle, message: OTPSentMessage)
                        self.regenerateOTPButton.isEnabled = false
                        self.timeLabel.isHidden=false
                        self.setTimer()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.hidePlaceHolderView()
                        if error?.code != -999 {
//                            DataManager.shareInstance.showAlert(self, title: errorTitle, message: errorMessage)
                            DataManager.shareInstance.showAlert(self, title: (error?.domain)!, message: (error?.localizedDescription)!)
                        }
                    }
                }
            }
        } else {
            DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
        }
        
        
    }
    
    @objc func enableButton()->Void{
        counter -= 1
        timeLabel .text = "\(counter)"
        if(counter==0)
        {
            
            process.stopAnimating()
            timeLabel.isHidden=true
            timerMessageLabel.text = "Not received your OTP?"
            myTimer.invalidate()
            // regenerateOTPButton.isEnabled = true
            regenerateOTPButton.tintColor = UIColor(netHex: 0x4F90D9)
            //status = RequestOTPModel.shareInstance.status!
            //                if(status == "success")
            //                {
            //                    print("\(status)")
            //                    regenerateOTPButton.isEnabled = false
            //                    regenerateOTPButton.isHidden=true
            //                }
            //                else
            //                {
            regenerateOTPButton.isEnabled = true
            regenerateOTPButton.isHidden=false
            //                }
        }
    }
    
    
    @IBAction func popupCloseButtonAction(_ sender: AnyObject) {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    @IBAction func popUpButtonAction(_ sender: AnyObject) {
        if sender as! UIButton == popupButton {
            self.view.endEditing(true)
            if NetworkChecker.isConnectedToNetwork() {
                if validateFields() {
                    showPlaceHolderView()
                    var values: Dictionary<String, AnyObject> = [:]
                    values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String as AnyObject?
                    values["otpNumber"] = (OTPTextField.text?.trim())! as AnyObject?
                    values["platform"] = platform as AnyObject?
                    values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
                    
                    DataManager.shareInstance.getDataFromWebService(verifyOTPURLMize, dataDictionary:values as NSDictionary) { (result, error) -> Void in
                        if error == nil {
                            DispatchQueue.main.async {
                                //                                self.hidePlaceHolderView()
                                verifyOTPModel.shareInstance.parseResponseObject(result)
                                let status: String = verifyOTPModel.shareInstance.status!
                                if(status == "error") {
                                    self.hidePlaceHolderView()
                                    DataManager.shareInstance.showAlert(self, title: "", message: regenerateOTPMessage)
                                } else if(status == "success") {
                                    
                                    /***************************************** NEW LOGIC **************************************/
//                                    print("OTP Success: \(result)")
                                    let responseDictionary: NSDictionary = (result as? NSDictionary)!
                                    print("Response Dictionary Success: \(responseDictionary)")
                                    let user = UserDetailsDatabaseModel.shareInstance.getUserDetails(PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String)
                                    
                                    print(user)
                                    if user.count > 1 {
                                        var user : Dictionary<String, AnyObject>
                                        user = verifyOTPModel.shareInstance.user!
                                        user.removeValue(forKey: "tickethistory")
                                        
                                            UserAddressesDatabaseModel.shareInstance.addUserAddress((PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String?)!, responseDictionary.value(forKeyPath: "user.addresses") as! NSArray, active: "")
                                        
                                        if !self.isNotNull(user["pin"]) {
                                            user["pin"] = "" as AnyObject?
                                        }
                                        if !self.isNotNull(user["alternatemobilenumber"]) {
                                            user["alternatemobilenumber"] = "" as AnyObject?
                                        }
                                        if !self.isNotNull(user["ibaseNumber"]) {
                                            user["ibaseNumber"] = "" as AnyObject?
                                        }
                                        if !self.isNotNull(user["alternateNoPreference"]) {
                                            user["alternateNoPreference"] = "" as AnyObject?
                                        }
                                        if !self.isNotNull(user["preferedCallingNumber"]) {
                                            user["preferedCallingNumber"] = "" as AnyObject?
                                        }
                                        self.hidePlaceHolderView()
                                        if let val = user["registeredProductsIds"] {
                                            PlistManager.sharedInstance.saveValue(user as AnyObject, forKey: "user")
                                            PlistManager.sharedInstance.saveValue(true as AnyObject, forKey: "registered")
                                            PlistManager.sharedInstance.saveValue(true as AnyObject, forKey: "alreadyRegisteredUser")
//                                            self.getEquipmentList()
                                            self.getProductList(true)
                                        } else {
                                            user["registeredProductsIds"] = "" as AnyObject?
                                            PlistManager.sharedInstance.saveValue(user as AnyObject, forKey: "user")
                                            self.getProductList(false)
                                            self.hidePlaceHolderView()
                                            PlistManager.sharedInstance.saveValue(false as AnyObject, forKey: "alreadyRegisteredUser")
                                        }
                                    } else {
                                        /******************* USER NOT FOUND *******************/
                                        
                                        if result?.value(forKey: "user") != nil {
                                            print ("user exists but not registered locally")
//                                            (result["user"]?["addresses"]?)
                                            UserAddressesDatabaseModel.shareInstance.addUserAddress((PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String?)!, responseDictionary.value(forKeyPath: "user.addresses") as! NSArray, active: "")
                                            var user : Dictionary<String, AnyObject>
                                            user = verifyOTPModel.shareInstance.user!
                                            user.removeValue(forKey: "tickethistory")
                                            if !self.isNotNull(user["pin"]) {
                                                user["pin"] = "" as AnyObject?
                                            }
                                            if !self.isNotNull(user["alternatemobilenumber"]) {
                                                user["alternatemobilenumber"] = "" as AnyObject?
                                            }
                                            if !self.isNotNull(user["ibaseNumber"]) {
                                                user["ibaseNumber"] = "" as AnyObject?
                                            }
                                            if !self.isNotNull(user["alternateNoPreference"]) {
                                                user["alternateNoPreference"] = "" as AnyObject?
                                            }
                                            if !self.isNotNull(user["preferedCallingNumber"]) {
                                                user["preferedCallingNumber"] = "" as AnyObject?
                                            }
                                            self.hidePlaceHolderView()
                                            if let val = user["registeredProductsIds"] {
                                                PlistManager.sharedInstance.saveValue(user as AnyObject, forKey: "user")
                                                PlistManager.sharedInstance.saveValue(false as AnyObject, forKey: "registered")
                                                PlistManager.sharedInstance.saveValue(false as AnyObject, forKey: "alreadyRegisteredUser")
                                                
//                                                self.getEquipmentList()
                                                self.getProductList(true)
                                            } else {
                                                user["registeredProductsIds"] = "" as AnyObject?
                                                PlistManager.sharedInstance.saveValue(user as AnyObject, forKey: "user")
                                                self.getProductList(false)
                                                self.hidePlaceHolderView()
                                                PlistManager.sharedInstance.saveValue(false as AnyObject, forKey: "alreadyRegisteredUser")
                                                PlistManager.sharedInstance.saveValue(false as AnyObject, forKey: "registered")

                                            }
                                        } else {
                                            print ("user is not registered on the system as well as the app")
                                            var user : Dictionary<String, AnyObject>
                                            user = [:]
                                            user["alternateNoPreference"] = "" as AnyObject?
                                            user["pin"] = "" as AnyObject?
                                            user["preferedCallingNumber"] = "" as AnyObject?
                                            user["ibaseNumber"] = "" as AnyObject?
                                            user["alternatemobilenumber"] = "" as AnyObject?
                                            user["registeredProductsIds"] = "" as AnyObject?
                                            var addrArr = [AnyObject]()
                                            user["addresses"] = addrArr as AnyObject?
                                            
                                            user["mobileNumber"] = "" as AnyObject?
                                            user["firstName"] = "" as AnyObject?
                                            user["ibaseNumber"] = "" as AnyObject?
                                            user["lastName"] = "" as AnyObject?
                                            user["prefferedTimingFrom"] = "" as AnyObject?
                                            user["prefferedTimingTo"] = "" as AnyObject?
                                            user["platform"] = "" as AnyObject?
                                            
                                            PlistManager.sharedInstance.saveValue(user as AnyObject, forKey: "user")
                                            PlistManager.sharedInstance.saveValue(false as AnyObject, forKey: "registered")
                                            PlistManager.sharedInstance.saveValue(false as AnyObject, forKey: "alreadyRegisteredUser")
                                            self.getProductList(false)
                                            self.hidePlaceHolderView()
                                            
                                        }
//                                        PlistManager.sharedInstance.saveValue(false as AnyObject, forKey: "alreadyRegisteredUser")
//                                        self.willMove(toParentViewController: nil)
//                                        self.view.removeFromSuperview()
//                                        self.removeFromParentViewController()
//                                        let nc = NotificationCenter.default
//                                        nc.post(name: Notification.Name(rawValue: "showRegistrationView"), object: nil)
                                        
                                    }
                                    
                                    
                                    
                                    
                                    /***************************************** OLD LOGIC **************************************/
                                    
                                    //                                    var user = verifyOTPModel.shareInstance.user!
//                                    //                                    var user
//                                    if verifyOTPModel.shareInstance.user != nil {
//                                        //                                        user = verifyOTPModel.shareInstance.user!
//                                        var user : Dictionary<String, AnyObject>
//                                        user = verifyOTPModel.shareInstance.user!
//                                        user.removeValue(forKey: "tickethistory")
//                                        if !self.isNotNull(user["pin"]) {
//                                            user["pin"] = "" as AnyObject?
//                                        }
//                                        if !self.isNotNull(user["alternatemobilenumber"]) {
//                                            user["alternatemobilenumber"] = "" as AnyObject?
//                                        }
//                                        if !self.isNotNull(user["ibaseNumber"]) {
//                                            user["ibaseNumber"] = "" as AnyObject?
//                                        }
//                                        if !self.isNotNull(user["alternateNoPreference"]) {
//                                            user["alternateNoPreference"] = "" as AnyObject?
//                                        }
//                                        if !self.isNotNull(user["preferedCallingNumber"]) {
//                                            user["preferedCallingNumber"] = "" as AnyObject?
//                                        }
//                                        self.hidePlaceHolderView()
//                                        if let val = user["registeredProductsIds"] {
//                                            PlistManager.sharedInstance.saveValue(user as AnyObject, forKey: "user")
//                                            PlistManager.sharedInstance.saveValue(true as AnyObject, forKey: "registered")
//                                            PlistManager.sharedInstance.saveValue(false as AnyObject, forKey: "alreadyRegisteredUser")
//                                            self.getEquipmentList()
//                                            self.getProductList(true)
//                                        } else {
//                                            user["registeredProductsIds"] = "" as AnyObject?
//                                            PlistManager.sharedInstance.saveValue(user as AnyObject, forKey: "user")
//                                            self.getProductList(false)
//                                            self.hidePlaceHolderView()
//                                            PlistManager.sharedInstance.saveValue(false as AnyObject, forKey: "alreadyRegisteredUser")
//                                            //                                            self.willMove(toParentViewController: nil)
//                                            //                                            self.view.removeFromSuperview()
//                                            //                                            self.removeFromParentViewController()
//                                            //                                            let nc = NotificationCenter.default
//                                            //                                            nc.post(name: Notification.Name(rawValue: "showRegistrationView"), object: nil)
//                                        }
//
//                                    } else {
//                                        //                                         user = [:]
//                                        var user : Dictionary<String, AnyObject>
//                                        user = [:]
//                                        user["alternateNoPreference"] = "" as AnyObject?
//                                        user["pin"] = "" as AnyObject?
//                                        user["preferedCallingNumber"] = "" as AnyObject?
//                                        user["ibaseNumber"] = "" as AnyObject?
//                                        user["alternatemobilenumber"] = "" as AnyObject?
//                                        user["registeredProductsIds"] = "" as AnyObject?
//                                        var addrArr = [AnyObject]()
//                                        user["addresses"] = addrArr as AnyObject?
//
//                                        user["mobileNumber"] = "" as AnyObject?
//                                        user["firstName"] = "" as AnyObject?
//                                        user["ibaseNumber"] = "" as AnyObject?
//                                        user["lastName"] = "" as AnyObject?
//                                        user["prefferedTimingFrom"] = "" as AnyObject?
//                                        user["prefferedTimingTo"] = "" as AnyObject?
//                                        user["platform"] = "" as AnyObject?
//
//                                        PlistManager.sharedInstance.saveValue(user as AnyObject, forKey: "user")
//
//                                        self.getProductList(false)
//                                        self.hidePlaceHolderView()
//                                        PlistManager.sharedInstance.saveValue(false as AnyObject, forKey: "alreadyRegisteredUser")
//                                        self.willMove(toParentViewController: nil)
//                                        self.view.removeFromSuperview()
//                                        self.removeFromParentViewController()
//                                        let nc = NotificationCenter.default
//                                        nc.post(name: Notification.Name(rawValue: "showRegistrationView"), object: nil)
//                                    }
//
//                                    //                                    self.willMove(toParentViewController: nil)
//                                    //                                    self.view.removeFromSuperview()
//                                    //                                    self.removeFromParentViewController()
//                                    //                                    let nc = NotificationCenter.default
//                                    //                                    nc.post(name: Notification.Name(rawValue: "showRegistrationView"), object: nil)
//                                    // ZYZZ 29/10
//                                    //
//                                    //                                    //                                    if user.count > 0 {
//                                    //                                    if self.isNotNull(user["registeredProductsIds"]) {
//                                    //
//                                    //                                        //                                        user.removeValueForKey("tickethistory")
//                                    //                                        //                                        if !self.isNotNull(user["pin"]) {
//                                    //                                        //                                            user["pin"] = ""
//                                    //                                        //                                        }
//                                    //                                        //                                        if !self.isNotNull(user["alternatemobilenumber"]) {
//                                    //                                        //                                            user["alternatemobilenumber"] = ""
//                                    //                                        //                                        }
//                                    //                                        //                                        if !self.isNotNull(user["ibaseNumber"]) {
//                                    //                                        //                                            user["ibaseNumber"] = ""
//                                    //                                        //                                        }
//                                    //                                        //
//                                    //                                        //                                        PlistManager.sharedInstance.saveValue(user, forKey: "user")
//                                    //
//                                    //
//                                    //
//                                    //                                        //comment below code because of change in flow--- if user is already registered user then navigate to dashboard after otp verification
//                                    //                                        /*
//                                    //                                         if self.isNotNull(user["firstName"]) && self.isNotNull(user["securityQuestionId"]) && self.isNotNull(user["securityQuestionAnswer"]) {
//                                    //                                         PlistManager.sharedInstance.saveValue(true, forKey: "alreadyRegisteredUser")
//                                    //                                         self.willMoveToParentViewController(nil)
//                                    //                                         self.view.removeFromSuperview()
//                                    //                                         self.removeFromParentViewController()
//                                    //                                         let nc = NSNotificationCenter.defaultCenter()
//                                    //                                         nc.postNotificationName("showAlreadyRegisteredView", object: nil)
//                                    //                                         } else {
//                                    //                                         PlistManager.sharedInstance.saveValue(false, forKey: "alreadyRegisteredUser")
//                                    //                                         self.willMoveToParentViewController(nil)
//                                    //                                         self.view.removeFromSuperview()
//                                    //                                         self.removeFromParentViewController()
//                                    //                                         let nc = NSNotificationCenter.defaultCenter()
//                                    //                                         nc.postNotificationName("showRegistrationView", object: nil)
//                                    //                                         }
//                                    //                                         */
//                                    //
//                                    //                                        // Added below lines of code
//                                    //                                        PlistManager.sharedInstance.saveValue(true as AnyObject, forKey: "registered")
//                                    //                                        PlistManager.sharedInstance.saveValue(false as AnyObject, forKey: "alreadyRegisteredUser")
//                                    //                                        //                                        let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardView") as! DashboardViewController
//                                    //                                        //                                        let SideBarVC = self.storyboard?.instantiateViewController(withIdentifier: "SidebarMenu") as! SideBarMenuVC
//                                    //                                        //                                        let nvc: UINavigationController = UINavigationController(rootViewController: mainVC)
//                                    //                                        //
//                                    //                                        //                                        let slideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: SideBarVC)
//                                    //                                        //                                        UIApplication.shared.keyWindow?.rootViewController = slideMenuController
//                                    //                                        self.getEquipmentList()
//                                    //                                        self.getProductList(true)
//                                    //
//                                    //                                        self.hidePlaceHolderView()
//                                    //
//                                    //                                    }
//                                    //                                    else {
//                                    //                                        // ZYZZ 28/10
//                                    //
//                                    ////                                        self.getProductList(false)
//                                    ////                                        self.hidePlaceHolderView()
//                                    ////                                        PlistManager.sharedInstance.saveValue(false as AnyObject, forKey: "alreadyRegisteredUser")
//                                    ////                                        self.willMove(toParentViewController: nil)
//                                    ////                                        self.view.removeFromSuperview()
//                                    ////                                        self.removeFromParentViewController()
//                                    ////                                        let nc = NotificationCenter.default
//                                    ////                                        nc.post(name: Notification.Name(rawValue: "showRegistrationView"), object: nil)
//                                    //                                    }
//                                    // ZYZZ 29/10
//
                                    /***************************************** OLD LOGIC END **************************************/

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
                }
            } else {
                DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
            }
        }
    }
    

    //======================================Get Equipment List Api=====================================================>
    func getEquipmentList(){
        let fileURL = DBManager.shareInstance.getPath()
        let db1 = FMDatabase(path: fileURL)
        var equipmentList : NSArray! = []
        //var equipmentList : NSArray! = []
        if NetworkChecker.isConnectedToNetwork() {
           // self.showPlaceHolderView()
            var values: Dictionary<String, String> = [:]
            values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber") as? String
            values["platform"] = platform
            values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey") as? String
            DataManager.shareInstance.getDataFromMizeWebService(equipmentListURLMize, dataDictionary:values as NSDictionary) { (result, error) -> Void in
                if error == nil {
                    //self.hidePlaceHolderView()
                    //       DispatchQueue.main.async {
                    if let responseDictionary: NSDictionary = result as? NSDictionary {
                        db1?.open()
                       
                        if let responseStatus : String = (responseDictionary.object(forKey: KEY_Status) as? String) {
                            if responseStatus == "success"{
                                EquipmentListModel.shareInstance.parseResponseObject(result)
                                equipmentList = EquipmentListModel.shareInstance.allEquipment
                                  EquipmentListDatabaseModel.shareInstance.addProducts(equipmentList)
                                if(equipmentList.count>0){
//                                    db1?.open()
//                                    EquipmentListDatabaseModel.shareInstance.addProducts(equipmentList)
                                }
                                //EquipmentListDatabaseModel.shareInstance.addProduct(equipmentList)
//                                ProductListDatabaseModel.shareInstance.addProducts(allProductList)
                            }else{
                                if let responseError : String = (responseDictionary.object(forKey: "errorMessage") as? String)
                                {
                                    //DataManager.shareInstance.showAlert(self, title: errorTitle, message: responseError)
                                    //Handle like android
                                    print(responseError)
                                }
                            }
                        }
                    }
                    //             }
                } else {
                    if error?.code != -999 {
                        //DataManager.shareInstance.showAlert(self, title: errorTitle, message: errorMessage)
                        //Handle like android
                        print(error?.description ?? "")
                    }
                }
            }
        } else {
            //            DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
        }
    }
    //======================================Product List Api=====================================================>
    func getProductList(_ isTicket: Bool) {
        let fileURL = DBManager.shareInstance.getPath()
        let db1 = FMDatabase(path: fileURL)
        var allProductList : NSArray! = []
        var productList : NSArray! = []
        if NetworkChecker.isConnectedToNetwork() {
            self.showPlaceHolderView()
            var values: Dictionary<String, AnyObject> = [:]
            values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
            values["platform"] = platform as AnyObject?
            values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
            DataManager.shareInstance.getDataFromWebService(productListURLMize, dataDictionary:values as NSDictionary) { (result, error) -> Void in
                if error == nil {
                    self.hidePlaceHolderView()
                    //       DispatchQueue.main.async {
                    if let responseDictionary: NSDictionary = result as? NSDictionary {
                        print(responseDictionary)
                        if let responseStatus : String = (responseDictionary.object(forKey: KEY_Status) as? String) {
                            if responseStatus == "success"{
                                ProductListModel.shareInstance.parseResponseObject(result)
                                productList = ProductListModel.shareInstance.products!
                                allProductList = ProductListModel.shareInstance.allProducts!
                                ProductBL.shareInstance.resultProductData =  responseDictionary
                                ProductBL.shareInstance.products.removeAllObjects()
                                if(productList.count > 0){
                                    ProductBL.shareInstance.selectedProducts.removeAllObjects()
                                    ProductBL.shareInstance.parseProductDataWithUserAlreadySelectedProducts(responseDictionary)
                                }else{
                                    ProductBL.shareInstance.parseResponseObject(responseDictionary)
                                }
                                print(productList.value(forKey: "productId"))
                                db1?.open()
                                ProductListDatabaseModel.shareInstance.addProducts(allProductList)
                                
                              //  self.navigateToRegistration()
                            }else{
                                if let responseError : String = (responseDictionary.object(forKey: "errorMessage") as? String)
                                {
                                    
                                    //DataManager.shareInstance.showAlert(self, title: errorTitle, message: responseError)
                                }
                            }
                        }
                    }
                    
                 //   self.registerDeviceToken()
                    //             }
                } else {
                    if error?.code != -999 {
                        //DataManager.shareInstance.showAlert(self, title: errorTitle, message: errorMessage)
                    }
                }
                if(isTicket == true)
                {
                    self.getTicketHistory()
                } else {
                    self.navigateToRegistration()
                }
            }
        } else {
            //            DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
        }
        
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
        if NetworkChecker.isConnectedToNetwork() {
            self.showPlaceHolderView()
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
            //values["lastSynced"] = UserDefaults.standard.value(forKey: "LastSynced") as AnyObject?
            DataManager.shareInstance.getDataFromWebService(ticketHistoryURLMize, dataDictionary:values as NSDictionary) { (result, error) -> Void in
                
                if error == nil {
                    DispatchQueue.main.async {
                        self.hidePlaceHolderView()
                        TicketHistoryModel.shareInstance.parseResponseObject(result)
                        let status: String = TicketHistoryModel.shareInstance.status!
                        
                        if status == "success" {
                            self.ticketHistoryList = TicketHistoryModel.shareInstance.tickets!
                            let lastSynced: String = TicketHistoryModel.shareInstance.lastSynced!
                            UserDefaults.standard.setValue(lastSynced, forKey: "LastSynced")
                            UserDefaults.standard.synchronize()
                            // self.sortTicketHistoryList()
                            TicketListModel.shareInstance.addTickets(self.ticketHistoryList)
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
                // ZYZZ 19/11 Commented below code.
                do {
                
                     let user = try UserDetailsDatabaseModel.shareInstance.getUserDetails(PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String)
                        
                    if user.count > 1 { //removed 1
                        DispatchQueue.main.async {
                            let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardView")
                            let SideBarVC = self.storyboard?.instantiateViewController(withIdentifier: "SidebarMenu")
                            
                            let nvc: UINavigationController = UINavigationController(rootViewController: mainVC!)
                            
                            let slideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: SideBarVC!)
                            UIApplication.shared.keyWindow?.rootViewController = slideMenuController
                            
                        }
                    } else {
                        self.navigateToRegistration()
                    }
                
                } catch let error as NSError {
                    print("[PlistManager] Unable to copy file. ERROR: \(error.localizedDescription)")
                }
            }
        } else {
            print("No Internet")
            // DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
        }
        db1?.close()
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
    
    func validateFields() -> Bool {
        if (OTPTextField.text?.trim() == "" || OTPTextField.text?.trim().characters.count < 6) {
            DataManager.shareInstance.showAlert(self, title: invalidOTPTitle, message: invalidOTPMessage)
            return false
        }
        return true
    }
    
    func showPlaceHolderView() {
        DispatchQueue.main.async {
            let controller:UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "PlaceHolderView")
            controller.view.frame = self.view.bounds;
            controller.view.tag = 100
            controller.view.backgroundColor = UIColor(white: 0.1, alpha: 0.65)
            controller.willMove(toParent: self)
            self.view.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)
        }
        
    }
    
    func hidePlaceHolderView() {
         DispatchQueue.main.async {
            if let viewWithTag = self.view.viewWithTag(100) {
                viewWithTag.removeFromSuperview()
            }
        }
    }
    
    func isNotNull(_ object:AnyObject?) -> Bool {
        guard let object = object else {
            return false
        }
        return (isNotNSNull(object) && isNotStringNull(object))
    }
    
    func isNotNSNull(_ object:AnyObject) -> Bool {
        return object.classForCoder != NSNull.classForCoder()
    }
    
    func isNotStringNull(_ object:AnyObject) -> Bool {
        if let object = object as? String, object.uppercased() == "NULL" {
            return false
        }
        if let object = object as? String, object.uppercased() == "" {
            return false
        }
        return true
    }
    // 16/11 ZYZZ
//    UserDetailsDatabaseModel.shareInstance.addUserDetails(PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String? ?? "", PlistManager.sharedInstance.getValueForKey("user") as! Dictionary<String, AnyObject>)
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
