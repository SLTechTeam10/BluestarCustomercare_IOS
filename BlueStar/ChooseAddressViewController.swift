//
//  ChooseAddressViewController.swift
//  BlueStar
//
//  Created by tarun.kapil on 23/09/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit

class ChooseAddressViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var closePopupButton: UIButton!
    @IBOutlet weak var chooseAddressLabel: UILabel!
    @IBOutlet weak var chooseAddressLineLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    var selectedProductDetails : NSDictionary! = [:]
    var selectedProductNatureOfProblemDetails : NSArray! = []
    var presentationController1: PresentationController?
    var isForcefullyGenerated : AnyObject?
    var problem: String!
//    @IBOutlet weak var okButton: UIButton!
    var isComingFromDashbord:Bool?
    var userData: NSDictionary!
    var addresses: NSArray!
    var addressids: NSArray!
    var addressid: Any! = nil
    var ibaseNo:Any! = nil
    var addressesView = AddressesView()
    var address: Dictionary<String, Any>!
    var selectedAddress: NSDictionary!
    var totalHeight: Float = 0
    var ticketNumber: String?
    var progressStatus: String?
    var lastUpdatedDate: String?
    var prodId: String?
    var productImage: String?
    var prodName: String?
//    var natureHeight: Float = 0
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        presentationController1 = PresentationController(presentedViewController: presented, presenting: presenting)
        return presentationController1!
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        popupView.layer.cornerRadius = 12
        chooseAddressLineLabel.backgroundColor = UIColor(netHex: 0xDEDFE0)
//        okButton.setPreferences()
        userData = PlistManager.sharedInstance.getValueForKey("user") as! NSDictionary
        //print(userData)
       // addresses = userData["addresses"] as! NSArray
        
        addresses = UserAddressesDatabaseModel.shareInstance.getUserAddrress(PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String)
        tableView.delegate = self
        addressids = addresses.value(forKey: "addressid") as! NSArray
        //presentationController1?.height = CGFloat(addresses.count * 65 + 30);
        tableView.isScrollEnabled = false
        //tableView.frame.size.height = 250
       // tableView.frame.size.height  = 230
        tableView.dataSource = self
    
//        print(userData)
//        print(addressids.object(at: 0))
//        print(addressids.object(at: 1))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell : ChooseAddressTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "ChooseAddressCell", for: indexPath) as? ChooseAddressTableViewCell)!
        address = addresses[indexPath.row] as! Dictionary<String, AnyObject>
        cell.addressBgView.backgroundColor =  UIColor(netHex: 0xF5F5F5)
        cell.addressBgView.layer.cornerRadius = 3
        cell.addressBgView.layer.borderColor = UIColor(netHex: 0xF1F1F2).cgColor
        var city = ""
        if let local = address["city"] {
            city = local as! String
        }
        cell.addressLine1Label.text = "\(address["address1"]!), \(address["address2"]!)"
        cell.addressLine2Label.text = "\(address["locality"]!) \(city)"
        cell.addressLine3Label.text = "\(address["state"]!) - \(address["pinCode"]!)"
        cell.addressLine1Label.textColor = UIColor(netHex: 0x666666)
        cell.addressLine2Label.textColor = UIColor(netHex: 0x666666)
        cell.addressLine3Label.textColor = UIColor(netHex: 0x666666)
        totalHeight += Float(cell.frame.height)
//
        if(totalHeight > Float(tableView.frame.height))
        {
            tableView.isScrollEnabled = true
//            if(tableView.frame.size.height > CGFloat(natureHeight))
//            {
                //tableView.frame.size.height  = 230
//            }
//            else{
//                tableView.frame.size.height  = 330
//            }
        }
//        }else if(totalHeight < Float(tableView.frame.height)){
//            tableView.frame.size.height = CGFloat(totalHeight + 20)
//        }
        
//        if address["isPrimaryAddress"] as! String == "true" {
//            cell.enableSwitch.on = true
//        } else {
//            cell.enableSwitch.on = false
//        }
//        cell.enableSwitch.onTintColor = UIColor(netHex: 0x00A98A)
//        cell.enableSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75)
//        cell.enableSwitch.tag = 3456+indexPath.row
//        cell.enableSwitch.addTarget(self, action: #selector(switchIsChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
//        print("Totat height is:-\(totalHeight)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
       //        nc.post(name: Notification.Name(rawValue: "ticketGenerate"), object: nil)
        selectedAddress = addresses.object(at: indexPath.row) as! NSDictionary
        //print(selectedAddress)
        //print(selectedAddress.value(forKey: "addressid"))
        addressid = selectedAddress.value(forKey: "customerId") as AnyObject
        ibaseNo = selectedAddress.value(forKey: "ibaseno")
        if(isComingFromDashbord)!{
        //self.doGenerateTicket(problem)
            self.generateTicket(problem)
        }else{
            //dogenerateTicketForEquipment
        }
        
        //        self.showPlaceHolderView()
        //print(addressid)
//        if NetworkChecker.isConnectedToNetwork() {
//            showPlaceHolderView()
//            var values: Dictionary<String, AnyObject> = [:]
//            var user: Dictionary<String, AnyObject> = PlistManager.sharedInstance.getValueForKey("user") as! Dictionary<String, AnyObject>
//            let addressIndex = indexPath.row
//            let addresses = user["addresses"] as! NSMutableArray
//            if addresses.count > 1 {
//                let newAddresses: NSMutableArray = []
//                for (index, value) in addresses.enumerated() {
//                    var address: Dictionary<String, AnyObject> = value as! Dictionary<String, AnyObject>
//                    if index == addressIndex {
//                        address["isPrimaryAddress"] = "true" as AnyObject?
//                    } else {
//                        address["isPrimaryAddress"] = "false" as AnyObject?
//                    }
//                    newAddresses.add(address)
//                }
//                user["addresses"] = newAddresses
//                values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
//                values["user"] = user as AnyObject?
//                values["platform"] = platform as AnyObject?
//                values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
//                DataManager.shareInstance.getDataFromWebService(registerUserURL, dataDictionary:values as NSDictionary) { (result, error) -> Void in
//                    if error == nil {
//                        DispatchQueue.main.async {
//                            self.hidePlaceHolderView()
//                            RegisterUserModel.shareInstance.parseResponseObject(result)
//                            let message = RegisterUserModel.shareInstance.errorMessage!
//                            let status = RegisterUserModel.shareInstance.status!
//                            if status == "error" {
//                                if message.lowercased().range(of: "index") != nil {
//                                    DataManager.shareInstance.showAlert(self, title: primaryAddressTitle, message: onePrimaryAddressMessage)
//                                } else {
//                                    DataManager.shareInstance.showAlert(self, title: messageTitle, message: message)
//                                }
//                                self.tableView.reloadData()
//                            } else {
//                                PlistManager.sharedInstance.saveValue(user as AnyObject, forKey: "user")
////                                self.addresses = newAddresses
////                                self.tableView.reloadData()
//                                self.willMove(toParentViewController: nil)
//                                self.view.removeFromSuperview()
//                                self.removeFromParentViewController()
//                                let nc = NotificationCenter.default
//                                nc.post(name: Notification.Name(rawValue: "ticketGenerate"), object: nil)
//                            }
//                        }
//                    } else {
//                        DispatchQueue.main.async {
//                            self.hidePlaceHolderView()
//                            self.tableView.reloadData()
//                            if error?.code != -999 {
//                                DataManager.shareInstance.showAlert(self, title: errorTitle, message: errorMessage)
//                            }
//                        }
//                    }
//                }
//            } else {
//                self.hidePlaceHolderView()
//                self.tableView.reloadData()
//                DataManager.shareInstance.showAlert(self, title: primaryAddressTitle, message: onePrimaryAddressMessage)
//            }
//        } else {
//            self.tableView.reloadData()
//            DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
//        }
    }
    
//    @IBAction func okButtonAction(sender: AnyObject) {
//        self.willMoveToParentViewController(nil)
//        self.view.removeFromSuperview()
//        self.removeFromParentViewController()
//        let nc = NSNotificationCenter.defaultCenter()
//        nc.postNotificationName("doGenerateTicket", object: nil)
//    }
    
    @IBAction func closePopupButtonAction(_ sender: AnyObject) {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
//        let nc = NotificationCenter.default
//         nc.post(name: Notification.Name(rawValue: "dismissNatureOfProblem"), object: nil)
//          self.dismiss(animated: true, completion: nil)
        
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
    func doGenerateTicket(_ selectedProblem: String) {
        
        if NetworkChecker.isConnectedToNetwork() {
            
            self.showPlaceHolderView()
            var values: Dictionary<String, AnyObject> = [:]
            values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
            values["productId"] = selectedProductDetails.value(forKey: "productId") as AnyObject?
            values["isForcefullyGenerated"] = isForcefullyGenerated
            values["platform"] = platform as AnyObject?
            values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
            
            values["natureOfProblem"] = selectedProblem as AnyObject?
            if (addressid != nil) {
                values["customerId"] = addressid as AnyObject?
            }
            else{
                values["addressid"] = "" as AnyObject?
            }
            DataManager.shareInstance.getDataFromWebService(generateTicketURL, dataDictionary:values as NSDictionary) { (result, error) -> Void in
                if error == nil {
                    DispatchQueue.main.async {
                        
                        self.hidePlaceHolderView()
                        GenerateTicketModel.shareInstance.parseResponseObject(result)
                        let message = GenerateTicketModel.shareInstance.errorMessage!
                        let status = GenerateTicketModel.shareInstance.status!
                       
                        if status == "error" {
                            DataManager.shareInstance.showAlert(self, title: messageTitle, message: message)
                        }
                        else {
                            self.ticketNumber = GenerateTicketModel.shareInstance.ticketNumber!
                            self.progressStatus = GenerateTicketModel.shareInstance.progressStatus!
                            self.lastUpdatedDate = GenerateTicketModel.shareInstance.updatedOn!
                            self.productImage = self.selectedProductDetails.value(forKey: "productImage") as? String
                            self.prodId = self.selectedProductDetails.value(forKey: "productId") as! String
                            self.prodName = self.selectedProductDetails.value(forKey: "productDisplayName") as! String
                            self.willMove(toParent: nil)
                            self.view.removeFromSuperview()
                            self.removeFromParent()
                            let nc = NotificationCenter.default
                            nc.post(name: Notification.Name(rawValue: "dismissView"), object: nil)
                            self.addTicketToDB()
                            self.hidePlaceHolderView()
                            self.presentationController1?.dimmingViewClicked(self)
                            //print(self.selectedAddress)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "displayTicketView"), object: self.selectedAddress)
                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.hidePlaceHolderView()
                        if error?.code != -999 {
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
    
    
    func generateTicket(_ selectedProblem: String){
        
        if NetworkChecker.isConnectedToNetwork() {
            self.showPlaceHolderView()
            var values: Dictionary<String, AnyObject> = [:]
            values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
            values["platform"] = platform as AnyObject?
            values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
            values["natureOfProblem"] = selectedProblem as AnyObject?
            
           // var user: Dictionary<String, AnyObject> = PlistManager.sharedInstance.getValueForKey("user") as! Dictionary<String, AnyObject>
            
            if(isComingFromDashbord)!{
                self.productImage = self.selectedProductDetails.value(forKey: "productImage") as? String
                self.prodId = self.selectedProductDetails.value(forKey: "productId") as? String
                self.prodName = self.selectedProductDetails.value(forKey: "productDisplayName") as? String
                values["productId"] = selectedProductDetails.value(forKey: "productId") as AnyObject?
                values["isForcefullyGenerated"] = isForcefullyGenerated
                values["customerId"] = addressid as AnyObject?
            }
           
          //  let address = user["addresses"] as! NSArray
            let addresses = selectedAddress as! Dictionary<String, AnyObject>
            DataManager.shareInstance.getDataFromMizeWebService(generateTicketURLMize, dataDictionary:values as NSDictionary) { (result, error) -> Void in
                if error == nil {
                    DispatchQueue.main.async {
                        
                        self.hidePlaceHolderView()
                        GenerateTicketModel.shareInstance.parseResponseObject(result)
                        
                        let status = GenerateTicketModel.shareInstance.status!
                        
                        //self.updatedOn = GenerateTicketModel.shareInstance.updates!
                        if status == "error" {
                            let message = GenerateTicketModel.shareInstance.errorMessage
                            DataManager.shareInstance.showAlert(self, title: messageTitle, message: message!)
                        }
                        else {
                            self.ticketNumber = GenerateTicketModel.shareInstance.ticketNumber!
                            self.lastUpdatedDate = GenerateTicketModel.shareInstance.updatedOn!
                            self.progressStatus = GenerateTicketModel.shareInstance.progressStatus!
                            self.hidePlaceHolderView()
                            self.presentationController1?.dimmingViewClicked(self)
                            self.addTicketToDB()
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ticketGeneratedRefreshView"), object: nil)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "displayTicketView"), object: addresses)
                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.hidePlaceHolderView()
                        if error?.code != -999 {
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
    
    func addTicketToDB(){
        let fileURL = DBManager.shareInstance.getPath()
        let db1 = FMDatabase(path: fileURL)
        db1?.open()
        
        let isinserted = db1?.executeUpdate("INSERT INTO ticketHistory (ticketNumber,lastUpdatedDate,productId,progressStatus,productName,productImage,modelNo,serialNo) VALUES (?,?,?,?,?,?,?,?)", withArgumentsIn: [ticketNumber,lastUpdatedDate,prodId,progressStatus,prodName,productImage,"",""])
        
        
        if(!isinserted!){
            print("Database failure: \(String(describing: db1?.lastErrorMessage()))")
        }
        
        db1?.close()
        
    }



}
