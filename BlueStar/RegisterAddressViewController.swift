//
//  RegisterAddressViewController.swift
//  BlueStar
//
//  Created by aditya.chitaliya on 16/11/18.
//  Copyright © 2018 BlueStar. All rights reserved.
//

import UIKit
import FirebaseAnalytics

//protocol registerAddressDelegate{
//    func getSelectedRegisterAddress(address: Dictionary<String, Any>)
//}

class RegisterAddressViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddressActionProtocol   {
   
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var closePopupButton: UIButton!
    @IBOutlet weak var chooseAddressLabel: UILabel!
    @IBOutlet weak var chooseAddressLineLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var popUpViewHeightConstraint: NSLayoutConstraint!
    
   // var delegate: registerAddressDelegate?
    var presentationController1: PresentationController?
//    var addresses: NSArray? = []
    var addresses: NSArray!
    var address: Dictionary<String, Any>!
    var selectedAddress: Dictionary<String, Any>!
    var totalHeight: Float = 0
    
    /******************* VARIABLES FOR TICKET GENERATION ****************/
    var selectedProductDetails : NSDictionary! = [:]
    var selectedProductNatureOfProblemDetails : NSArray! = []
//    var presentationController1: PresentationController?
    var isForcefullyGenerated : AnyObject?
    var problem: String!
    //    @IBOutlet weak var okButton: UIButton!
    var isComingFromDashbord:Bool?
    var userData: NSDictionary!
    var addressids: NSArray!
    var addressid: Any! = nil
    var ibaseNo:Any! = nil
    var addressesView = AddressesView()
//    var address: Dictionary<String, Any>!
    var selectedAddresss: NSDictionary!
//    var totalHeight: Float = 0
    var ticketNumber: String?
    var progressStatus: String?
    var lastUpdatedDate: String?
    var prodId: String?
    var productImage: String?
    var prodName: String?
    var addressProtocol1 : AddressActionProtocol?
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        presentationController1 = PresentationController(presentedViewController: presented, presenting: presenting)
        return presentationController1!
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let screenClass = self.classForCoder.description()
        Analytics.setScreenName("Select Address Screen", screenClass: screenClass)
        Analytics.logEvent("page_view",parameters: ["page":"Select Address Screen"])

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if (isComingFromDashbord != nil  && !isComingFromDashbord!) {
            print("All user address list update from When viewDidLoad")
//            addresses = UserAddressesDatabaseModel.shareInstance.getUserAddrress(PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String)
            addresses = (PlistManager.sharedInstance.getValueForKey("user") as? NSDictionary)?.value(forKey: "addresses") as? NSArray
        }
        
        let nib = UINib(nibName: "AddNewAddressCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier:"AddNewAddressCell")
        
        let registerCompanyAddressCellNib = UINib(nibName: "registerCompanyAddressCell", bundle: nil)
        self.tableView.register(registerCompanyAddressCellNib, forCellReuseIdentifier:"registerCompanyAddressCell")
        
    }
    

    // MARK:- On new address selection
    func onAddNewAddress() {
        
    }
    override func viewDidLayoutSubviews() {
        DispatchQueue.main.async {
      
            if self.addresses.count == 0 {
                self.popUpViewHeightConstraint.constant = 90
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //if !isComingFromDashbord! {
            if (isComingFromDashbord != nil  && !isComingFromDashbord!) {
            return addresses!.count+1
        } else {
            return addresses!.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //var header = EquipmentHeader()
        //var views = TextFieldwithInfoView()
        //if !isComingFromDashbord! {
        if (isComingFromDashbord != nil  && !isComingFromDashbord!) {
            if section == 0 {
                return nil
            }
            var headerView = EquimentListHeaderView()
            let add = addresses![section-1] as! Dictionary<String, AnyObject>
            headerView = Bundle.main.loadNibNamed("EquipmentListHeader", owner: self, options: nil)?[0] as! EquimentListHeaderView
            //        headerView.LblCustomerId.text = "Customer Id:  "+String(describing:add["customerId"]!)
            print("headers for address")
            print(add)
            headerView.LblCustomerId.text = add["customerId"] as? String
            //headerView.LblCustomerId.text = add["customerId"]! as! String
            return headerView
        } else {
            var headerView = EquimentListHeaderView()
            var add = addresses![section] as! Dictionary<String, AnyObject>
            headerView = Bundle.main.loadNibNamed("EquipmentListHeader", owner: self, options: nil)?[0] as! EquimentListHeaderView
            //        headerView.LblCustomerId.text = "Customer Id:  "+String(describing:add["customerId"]!)
            headerView.LblCustomerId.text = add["customerId"]! as! String
            
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //if !isComingFromDashbord! {
        if (isComingFromDashbord != nil  && !isComingFromDashbord!) {
            if section == 0 {
                return 0
            }
            return 30
        } else {
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        //if !isComingFromDashbord! {
        if (isComingFromDashbord != nil  && !isComingFromDashbord!) {
            if indexPath.section == 0 {
      
                let cell : AddNewAddressCellTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "AddNewAddressCell", for: indexPath) as? AddNewAddressCellTableViewCell)!
                return cell
            }
            address = addresses![indexPath.section-1] as! Dictionary<String, AnyObject>
        } else {
            address = addresses![indexPath.section] as! Dictionary<String, AnyObject>
        }
        
        if address["companyName"] != nil {
            if address["companyName"] as? String != "" {
                let cell : registerCompanyAddressCell = (tableView.dequeueReusableCell(withIdentifier: "registerCompanyAddressCell", for: indexPath) as? registerCompanyAddressCell)!
                cell.companyNameLabel.text = address["companyName"] as! String
//                cell.addressLine1Label.font = UIFont.systemFont(ofSize: 15)
                cell.addressLine2Label.isHidden = false
                cell.addressLine3Label.isHidden = false
                
                cell.addressBgView.backgroundColor =  UIColor(netHex: 0xF5F5F5)
                cell.addressBgView.layer.cornerRadius = 3
                cell.addressBgView.layer.borderColor = UIColor(netHex: 0xF1F1F2).cgColor
                if(address["address2"] != nil){
                    if  !((address["address2"] as! String) == ""){
                        cell.addressLine1Label.text = "\(address["address1"]!), \(address["address2"]!)"
                    } else{
                        cell.addressLine1Label.text = "\(address["address1"]!)"
                    }
                }else{
                    cell.addressLine1Label.text = "\(address["address1"]!)"
                }
                
                var city = ""
                if let local = address["city"] {
                    city = local as! String
                }
                if(address["locality"] != nil){
                    if  !((address["locality"] as! String) == ""){
                        
                        if(city.count>0){
                            cell.addressLine2Label.text = "\(address["locality"]!), \(address["city"]!)"
                        }else{
                            cell.addressLine2Label.text = "\(address["locality"]!)"
                        }
                    } else {
                        cell.addressLine2Label.text = city
                    }
                }else {
                    cell.addressLine2Label.text = city
                }
                
                //        cell.addressLine2Label.text = "\(address["locality"]) \(address["city"]!)"
                cell.addressLine3Label.text = "\(address["state"]!) - \(address["pinCode"]!)"
                cell.addressLine1Label.textColor = UIColor(netHex: 0x666666)
                cell.addressLine2Label.textColor = UIColor(netHex: 0x666666)
                cell.addressLine3Label.textColor = UIColor(netHex: 0x666666)
                
                if let subType = address["subTypeCode"]{
                    if(subType as! String == "Residential"){
                        
                        if let resConfig = address["residentialConfiguration"]{
//                            print(resConfig)
                            if(resConfigs.contains(resConfig as! String)){
                                cell.companyNameLabel.text = "Residential Configuration: " + (resConfig as! String)
                            }else{
                                cell.companyNameLabel.text = "Residential Configuration:"
                            }
                            
                        }else{
                            cell.companyNameLabel.text = "Residential Configuration:"
                        }
                    }
                }
                
                totalHeight += Float(cell.frame.height)
                if(totalHeight > Float(tableView.frame.height))
                {
                    tableView.isScrollEnabled = true
                }
                return cell
            }
        } else {
            
        }
        
        let cell : RegisterAddressTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "registerAddressCell", for: indexPath) as? RegisterAddressTableViewCell)!

        cell.addressLine1Label.font = UIFont.systemFont(ofSize: 15)
        cell.addressLine2Label.isHidden = false
        cell.addressLine3Label.isHidden = false
        
        cell.addressBgView.backgroundColor =  UIColor(netHex: 0xF5F5F5)
        cell.addressBgView.layer.cornerRadius = 3
        cell.addressBgView.layer.borderColor = UIColor(netHex: 0xF1F1F2).cgColor
        if(address["address2"] != nil){
            if  !((address["address2"] as! String) == ""){
                cell.addressLine1Label.text = "\(address["address1"]!), \(address["address2"]!)"
            } else{
                cell.addressLine1Label.text = "\(address["address1"]!)"
            }
        } else{
            cell.addressLine1Label.text = "\(address["address1"]!)"
        }
        var city = ""
        if let local = address["city"] {
            city = local as! String
        }
        if(address["locality"] != nil){
            cell.addressLine2Label.text = "\(address["locality"]!) \(city)"
        } else {
            cell.addressLine2Label.text = "\(city)"
        }
        
        //        cell.addressLine2Label.text = "\(address["locality"]) \(address["city"]!)"
        cell.addressLine3Label.text = "\(address["state"]!) - \(address["pinCode"]!)"
        cell.addressLine1Label.textColor = UIColor(netHex: 0x666666)
        cell.addressLine2Label.textColor = UIColor(netHex: 0x666666)
        cell.addressLine3Label.textColor = UIColor(netHex: 0x666666)
        totalHeight += Float(cell.frame.height)
        if(totalHeight > Float(tableView.frame.height))
        {
            tableView.isScrollEnabled = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //if !isComingFromDashbord! {
            if (isComingFromDashbord != nil  && !isComingFromDashbord!) {
            if indexPath.section == 0 {
                return 40
            }
            address = addresses![indexPath.section-1] as! Dictionary<String, AnyObject>
            if address["companyName"] != nil {
                if address["companyName"] as? String != "" {
                    return 110
                }
                return 110
            }
        } else {
            address = addresses![indexPath.section] as! Dictionary<String, AnyObject>
            if address["companyName"] != nil {
                if address["companyName"] as? String != "" {
                    return 110
                }
                return 110
            }
        }
        return UITableView.automaticDimension
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //nc.post(name: Notification.Name(rawValue: "ticketGenerate"), object: nil)
        //if !isComingFromDashbord! {
            if (isComingFromDashbord != nil  && !isComingFromDashbord!) {
            if indexPath.section == 0 {
            print("ADDING NEW ADDRESS")
                // rest old functionality

                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "clearAllTextFields"), object: nil, userInfo: nil)
                // for add new intercept
                addressProtocol1?.onAddNewAddress()
                // imp to dismiss else data will not update
                self.willMove(toParent: nil)
                self.view.removeFromSuperview()
                self.removeFromParent()
                dismiss(animated: true, completion: nil)
            } else {
                selectedAddress = addresses?.object(at: indexPath.section-1) as! NSDictionary as! Dictionary<String, Any>
                //self.delegate?.getSelectedRegisterAddress(address: selectedAddress)
                let next = self.storyboard?.instantiateViewController(withIdentifier: "GlobalAddNewAddressViewController") as! GlobalAddNewAddressViewController
                self.present(next, animated: true, completion: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addressSelected"), object: nil, userInfo: selectedAddress)
            }
                
//            self.willMove(toParent: nil)
//            self.view.removeFromSuperview()
//            self.removeFromParent()
                
            //addressid = selectedAddress.value(forKey: "customerId") as AnyObject
            //ibaseNo = selectedAddress.value(forKey: "ibaseno")
        } else {
            selectedAddresss = addresses?.object(at: indexPath.section) as! NSDictionary
            var getResConfig = ""
            var custType = ""
            
            if let cuss = selectedAddresss["subTypeCode"]{
                custType = cuss as! String
            }
            
            if(custType == "Residential"){
                if let ress = selectedAddresss["residentialConfiguration"]{
                    getResConfig = ress as! String
                }
                if(resConfigs.contains(getResConfig)){
                    addressid = selectedAddresss.value(forKey: "customerId") as AnyObject
                    ibaseNo = selectedAddresss.value(forKey: "ibaseno")
                    self.generateTicket(problem)
                }
                else {
                    DispatchQueue.main.async
                        {
                            let alert = UIAlertController(title:"", message:"Please update your address to proceed", preferredStyle: .alert)
                            alert.view.frame = UIScreen.main.applicationFrame
                            let action = UIAlertAction(title:oKey, style: .default)
                            { _ in
                                self.closePopupButtonAction(UIButton.init())
                                let nc = NotificationCenter.default
                                nc.post(name: Notification.Name(rawValue: "dismissNatureOfProblem"), object: nil)
                                
                                nc.post(name: Notification.Name(rawValue: "showMyAccountAddressView"), object: nil)
                            }
                            alert.addAction(action)
                            self.present(alert, animated: true)
                            {}
                    }
                }
            }
            else{
                addressid = selectedAddresss.value(forKey: "customerId") as AnyObject
                ibaseNo = selectedAddresss.value(forKey: "ibaseno")
                self.generateTicket(problem)
            }
            
            
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
            
            //if(isComingFromDashbord)!{
            if (isComingFromDashbord != nil  && isComingFromDashbord!) {
                self.productImage = self.selectedProductDetails.value(forKey: "productImage") as? String
                self.prodId = self.selectedProductDetails.value(forKey: "productId") as? String
                self.prodName = self.selectedProductDetails.value(forKey: "productDisplayName") as? String
                values["productId"] = selectedProductDetails.value(forKey: "productId") as AnyObject?
                values["isForcefullyGenerated"] = isForcefullyGenerated
                values["customerId"] = addressid as AnyObject?
            }
            
            //  let address = user["addresses"] as! NSArray
            let addresses = selectedAddresss as! Dictionary<String, AnyObject>
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
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "displayTicketView"), object: addresses)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ticketGeneratedRefreshView"), object: nil)
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
    
    func showPlaceHolderView() {
        let controller:UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "PlaceHolderView")
//        controller.view.frame = self.view.bounds;
        let screenSize = UIScreen.main.bounds
        controller.view.frame = CGRect(x: screenSize.origin.x, y: screenSize.origin.y, width: screenSize.width, height: screenSize.height)
//        controller.view.frame = (self.parent?.view.frame)!

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
    
    @IBAction func closePopupButtonAction(_ sender: AnyObject) {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
        //        let nc = NotificationCenter.default
        //         nc.post(name: Notification.Name(rawValue: "dismissNatureOfProblem"), object: nil)
        //          self.dismiss(animated: true, completion: nil)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

