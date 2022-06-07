//
//  RegisteredDeviceViewController.swift
//  BlueStar
//
//  Created by aditya.chitaliya on 23/10/18.
//  Copyright © 2018 BlueStar. All rights reserved.
//

import UIKit
import FirebaseAnalytics
protocol EquipmentListViewControllerDelegate{
        func skipButtonPressed()
}

class RegisteredDeviceViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var registeredDeviceTableView: UITableView!
    var productList : NSDictionary? = [:]
    var customerIdList: NSArray? = []
    var isComingFromDashbord: Bool? = false
    var isForcefullyGenerated:AnyObject? = "false" as AnyObject
    var selectedProductDetail: NSDictionary? = [:]
    var delegate: EquipmentListViewControllerDelegate?
    
    var selectedIndex : IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //DatabaseMigrate.shareInstance.createEquipmentsTabel()
                self.title = "Equipment"
        registeredDeviceTableView.register(UINib(nibName: "RegisteredDeviceTableViewCell", bundle: nil), forCellReuseIdentifier: "RegisteredDeviceCell")
                registeredDeviceTableView.separatorStyle = .none
        if(isComingFromDashbord)!{
            self.setupSkipButtonInNavigationBar()
//            self.getEquipmentForProduct()
//            self.getProduct()   // This method gives equipments for registered products
        }else{
//            self.getProduct()
        }
        registeredDeviceTableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        registeredDeviceTableView.tableFooterView = UIView.init(frame: CGRect.zero)
        // Do any additional setup after loading the view.
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(presentNatureOfProblemView), name: NSNotification.Name(rawValue: "GenNewBookTicket"), object: nil)
        
    }
    // todo
    @objc func presentNatureOfProblemView(){
        
        let data = (self.productList?.object(forKey: self.customerIdList?.object(at: selectedIndex.section) as! String) as! NSArray).object(at: selectedIndex.row) as! NSDictionary
        
        print("Data in Present Problem View: \(data)")
        
        let prodCount =  data.value(forKey: "natureOfProblemDetails") as! NSArray
        
        if prodCount.count > 0{
            UserDefaults.standard.removeObject(forKey: "AddCooling")
        }
        else
        {
            UserDefaults.standard.setValue("AddCooling", forKey: "AddCooling")
        }
        
        let natureOfProblemViewController =  self.storyboard?.instantiateViewController(withIdentifier: "NatureOfProblemViewController") as! NatureOfProblemViewController
            natureOfProblemViewController.isForcefullyGenerated = "false" as AnyObject?

        natureOfProblemViewController.selectedProductDetails = data
        natureOfProblemViewController.isComingFromDashbord = true
        //natureOfProblemViewController.selectedProductNatureOfProblemDetails = data.value(forKey: "natureOfProblemDetails") as! NSArray
        natureOfProblemViewController.selectedProductNatureOfProblemDetails = data.value(forKey: "natureOfProblemDetails") as! NSMutableArray
        self.present(natureOfProblemViewController, animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        let screenClass = self.classForCoder.description()
        Analytics.setScreenName("Equipment Screen", screenClass: screenClass)
        Analytics.logEvent("page_view",parameters: ["page":"Equipment Screen"])
        self.refreshGetEquipmentList()
        
    }
    
    func refreshGetEquipmentList() {
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
            
            DispatchQueue.main.async {
                self.showPlaceHolderView()
            }
        
            DataManager.shareInstance.getDataFromMizeWebService(equipmentListURLMize, dataDictionary:values as NSDictionary) { (result, error) -> Void in
                self.hidePlaceHolderView()
                if error == nil {
                    DispatchQueue.main.async {
                        if let responseDictionary: NSDictionary = result as? NSDictionary {
                            if let responseStatus : String = (responseDictionary.object(forKey: KEY_Status) as? String) {
                                if responseStatus == "success"{
                                    EquipmentListModel.shareInstance.parseResponseObject(result)
                                    equipmentList = EquipmentListModel.shareInstance.allEquipment
                                    EquipmentListDatabaseModel.shareInstance.addProducts(equipmentList)
                                    if(equipmentList.count>0){
                                        self.getProduct()
                                    }else{
                                        self.getProduct()
                                    }
                                }else{
                                    self.getProduct()
                                    if let responseError : String = (responseDictionary.object(forKey: "errorMessage") as? String)
                                    {
                                        //DataManager.shareInstance.showAlert(self, title: errorTitle, message: responseError)
                                    }
                                }
                            }
                        }
                    }
                } else {
                    self.getProduct()
                    if error?.code != -999 {
                        //DataManager.shareInstance.showAlert(self, title: errorTitle, message: errorMessage)
                    }
                }
            }
        } else {
            //            DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.customerIdList!.count)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.productList?.object(forKey: self.customerIdList?.object(at: section)) as! NSArray).count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 85
        return 110
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //var header = EquipmentHeader()
        //var views = TextFieldwithInfoView()
        var headerView = EquimentListHeaderView()
            headerView = Bundle.main.loadNibNamed("EquipmentListHeader", owner: self, options: nil)?[0] as! EquimentListHeaderView
        let strval = String(describing:self.customerIdList!.object(at: section))
        headerView.LblCustomerId.text = String(describing:self.customerIdList!.object(at: section))
        print("RDVC Headers: \(strval)")
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegisteredDeviceCell", for: indexPath) as! RegisteredDeviceTableViewCell
        let data = (self.productList?.object(forKey: self.customerIdList?.object(at: indexPath.section) as! String) as! NSArray).object(at: indexPath.row) as! NSDictionary
        if((self.productList?.object(forKey: self.customerIdList?.object(at: indexPath.section) as! String) as! NSArray).lastObject as! NSDictionary == data){
            cell.saperatorView.isHidden = true
        }else{
            cell.saperatorView.isHidden = true
        }
       // let data = self.productList![indexPath.row] as? NSDictionary
        cell.leftImageView.layer.cornerRadius = cell.leftImageView.layer.frame.width/2
        cell.leftImageView.layer.borderWidth = 1
        cell.leftImageView.layer.borderColor = UIColor(netHex: 0xDEDFE0).cgColor
        
        var image : String = ""
        if isComingFromDashbord! {
            if checkKeyExist("productImage", dictionary: self.selectedProductDetail!) {
                image = self.selectedProductDetail!.object(forKey: "productImage") as! String
            }
        } else {
            if checkKeyExist("productImage", dictionary: data) {
                image = data.value(forKey: "productImage") as! String
            }
        }
//        let image = isComingFromDashbord! ? self.selectedProductDetail!.object(forKey: "productImage") as! String : data.value(forKey: "productImage") as! String
        
        if let imageUrl = URL(string: image){
            cell.equipmentImage.af_setImage(withURL: imageUrl, placeholderImage: placeholderImage)
        }
       
        cell.LblDeviceName.text = "Product             : "+String(describing: data.value(forKey: "equipmentName")!)
        cell.LblModelName.text = data.value(forKey: "modelName") as? String
        cell.LblSerialNo.text = data.value(forKey:"serialNo") as? String
       // cell.LblModelNo.text =  data.value(forKey: "modelNo") as? String
        //cell.LblRegNo.text = data.value(forKey:"equipmentRegNo") as? String
        //cell.LblSrNo.text = data.value(forKey:"serialNo") as? String
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       //Generate Ticket Functionality
        selectedIndex = indexPath
        self.generateTicket(indexPath)
    }
    
    func generateTicket(_ indexPath: IndexPath) {
            self.generateNewTicket(indexPath)
    }
    
   func generateNewTicket(_ indexPath: IndexPath){
        
        UserDefaults.standard.setValue("Register", forKey: "Register")
    
    let data = (self.productList?.object(forKey: self.customerIdList?.object(at: selectedIndex.section) as! String) as! NSArray).object(at: selectedIndex.row) as! NSDictionary
    
    print("Data in Present Problem View: \(data)")
    
    let prodCount =  data.value(forKey: "natureOfProblemDetails") as! NSArray
    
    let natureOfProblemViewController =  self.storyboard?.instantiateViewController(withIdentifier: "NatureOfProblemViewController") as! NatureOfProblemViewController
        natureOfProblemViewController.isForcefullyGenerated = "false" as AnyObject?

    natureOfProblemViewController.selectedProductDetails = data
    natureOfProblemViewController.isComingFromDashbord = false
    //natureOfProblemViewController.isComingFromDashbord = true
    //natureOfProblemViewController.selectedProductNatureOfProblemDetails = data.value(forKey: "natureOfProblemDetails") as! NSArray
    natureOfProblemViewController.selectedProductNatureOfProblemDetails = data.value(forKey: "natureOfProblemDetails") as! NSMutableArray
    
    
    if prodCount.count > 0{
        UserDefaults.standard.removeObject(forKey: "AddCooling")
    }
    else
    {
        UserDefaults.standard.setValue("AddCooling", forKey: "AddCooling")
        //UserDefaults.standard.setValue("other", forKey: "other")
        let  otherDict = ["natureOfProblem": "Not Cooling", "natureId": 4, "natureOfProblemImage":"http://bluestar-uat.s3.amazonaws.com/CCAPP/images/NotCooling.png"] as [String : Any]
        
        let  notCoollingDict = ["natureOfProblem": "Others", "natureId": 3, "natureOfProblemImage":"http://bluestar-uat.s3.amazonaws.com/CCAPP/images/Others.png"] as [String : Any]
        
        natureOfProblemViewController.selectedProductNatureOfProblemDetails.add(otherDict)
        natureOfProblemViewController.selectedProductNatureOfProblemDetails.add(notCoollingDict)
        
        /*
         {
             natureId = 3;
             natureOfProblem = Others;
             natureOfProblemImage = "http://bluestar-uat.s3.amazonaws.com/CCAPP/images/Others.png";
         }

         {
             natureId = 4;
             natureOfProblem = "Not Cooling";
             natureOfProblemImage = "http://bluestar-uat.s3.amazonaws.com/CCAPP/images/NotCooling.png";
         }
         */
        
    }
    
    
    self.present(natureOfProblemViewController, animated: true, completion: nil)
    
           /* let controller:FollowupPopupViewController = self.storyboard!.instantiateViewController(withIdentifier: "FollowupPopupView") as! FollowupPopupViewController
            controller.view.frame = self.view.bounds;
        controller.isComingFromReg = true
            controller.view.backgroundColor = UIColor(white: 0.1, alpha: 0.65)
            controller.willMove(toParent: self)
            self.view.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)*/
    
    }
    
    
    
    
    
//    func generateNewTicket(_ indexPath: IndexPath) {
//
//        if NetworkChecker.isConnectedToNetwork() {
//
//            DispatchQueue.main.async {
//                self.showPlaceHolderView()
//            }
//
//            var values: Dictionary<String, AnyObject> = [:]
//            values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
//            /*       values["productId"] = 101 as AnyObject?                               Static Data Used    */
//            let getProdId = (self.productList?.object(forKey: self.customerIdList?.object(at: indexPath.section) as! String) as! NSArray).object(at: indexPath.row) as! NSDictionary
//            let productID = getProdId.value(forKey: "productId")
//            //values["isForcefullyGenerated"] = "true" as AnyObject?
//            values["productId"] = productID as AnyObject?
//            values["platform"] = platform as AnyObject?
//            values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
//
//            var user: Dictionary<String, AnyObject> = PlistManager.sharedInstance.getValueForKey("user") as! Dictionary<String, AnyObject>
//            values["ibaseNumber"] = user["ibaseNumber"]
//            self.hidePlaceHolderView()
//            let data = (self.productList?.object(forKey: self.customerIdList?.object(at: indexPath.section) as! String) as! NSArray).object(at: indexPath.row) as! NSDictionary
//            let natureOfProblemViewController = self.storyboard?.instantiateViewController(withIdentifier: "NatureOfProblemViewController") as! NatureOfProblemViewController
//            //            if(isForcefullyGenerated as! String == "true"){
//            //                natureOfProblemViewController.isForcefullyGenerated = "true" as AnyObject?
//            //            }else{
//            natureOfProblemViewController.isForcefullyGenerated = self.isForcefullyGenerated
//            //"false" as AnyObject?
//            //            }
//            natureOfProblemViewController.selectedProductDetails = self.selectedProductDetail
//            natureOfProblemViewController.selectedEquipmentDetails = data
//            natureOfProblemViewController.selectedProductNatureOfProblemDetails = isComingFromDashbord! ? self.selectedProductDetail?.value(forKey: "natureOfProblemDetails") as! NSArray : data.value(forKey: "natureOfProblemDetails") as! NSArray
//            natureOfProblemViewController.isComingFromDashbord = isComingFromDashbord
//            self.present(natureOfProblemViewController, animated: true, completion: nil)
//        } else {
//            DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
//        }
//    }
    
    
    func getProduct() {
        
//        self.showPlaceHolderView()
        DispatchQueue.main.async {
            self.showPlaceHolderView()
            
            let fileURL = DBManager.shareInstance.getPath()
            let db1 = FMDatabase(path: fileURL)
            var list:NSArray
            var products:NSMutableArray = []
           // var totalrecord:NSMutableArray = []
            db1?.open()
        
            /*************************** OLD LOGIC TO FETCH ALL EQUIPMENTS ****************************/
            
//            if let rs = db1?.executeQuery("select * from registeredDevice order by productId desc", withArgumentsIn:nil) {
////                while rs.next() {
////                    products.addObjects(from: [rs.resultDictionary() as Any])
////                }
//                while rs.next() {
//                    var natureOfProblem: NSMutableArray = []
//                    let prod = rs.resultDictionary() as NSDictionary
//                    var id = rs.string(forColumn: "productId") as! String
//                    //remove hardcoded value
//                    //id = "1371"
//
//
//
//                    if let natureRS = db1?.executeQuery("select natureId,natureOfProblem,natureOfProblemImage from natureOfProblem where productId like (?)", withArgumentsIn: [id]){
//                        while natureRS.next() {
//                            natureOfProblem.add(natureRS.resultDictionary())
//                        }
//                        var mutdict = NSMutableDictionary()
//                        mutdict = prod.mutableCopy() as! NSMutableDictionary
//                        mutdict.setValue(natureOfProblem, forKey: "natureOfProblemDetails")
//                        if let equipmentImage = db1?.executeQuery("select productDisplayName,productImage from productList where productId like (?)", withArgumentsIn: [id]){
//                                                    print(equipmentImage.string(forColumn: "productImage"))
//                            while equipmentImage.next() {
//                                //mutdict.setDictionary(equipmentImage.resultDictionary())
//                                mutdict.setValue(equipmentImage.string(forColumn: "productImage"), forKey: "productImage")
//                                mutdict.setValue(equipmentImage.string(forColumn: "productDisplayName"), forKey: "productName")
//                            }
//                        }
//                        products.add(mutdict)
//                    } else {
//                        print("Database failure: \(String(describing: db1?.lastErrorMessage()))")
//                    }
//                }
//                list = products as NSArray
//                if list.count == 0 {
//                    self.hidePlaceHolderView()
//                    DataManager.shareInstance.showAlert(self, title: "", message: "No Equipments found.")
//                } else {
//                    self.hidePlaceHolderView()
//                    self.setupData(list)
//                }
//            }else {
//                self.hidePlaceHolderView()
//                print("select failure: \(String(describing: db1?.lastErrorMessage()))")
//            }
            
           
            
            /*************************** NEW LOGIC TO FETCH EQUIPMENTS ONLY FOR ACTIVE ADDRESSES ****************************/

            var activeAddresses = UserAddressesDatabaseModel.shareInstance.getUserAddrress(PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String)
            var customerID = "M3280502140835559"

            var queryString : String
            var queryString2 = ""

            for case let dict as NSDictionary in activeAddresses {
                // do something with button
                customerID = dict.value(forKey: "customerId") as! String
                queryString = "'" + customerID + "'" + ","
                queryString2.append(queryString)
            }
            if !queryString2.isEmpty {
                queryString2.removeLast()
            }
            
            
//            let Query = "select * from registeredDevice where customerId in '" + customerID + "'"
            let Query = "select * from registeredDevice where customerId in (" + queryString2 + ")"

            print(Query)
            if let rs = db1?.executeQuery(Query, withArgumentsIn: nil) {
                //                while rs.next() {
                //                    products.addObjects(from: [rs.resultDictionary() as Any])
                //                }
                while rs.next() {
                    var natureOfProblem: NSMutableArray = []
                    let prod = rs.resultDictionary() as NSDictionary
                    var id = rs.string(forColumn: "productId") as! String
                    //remove hardcoded value
                    //id = "1371"
                    
                    
                    
                    if let natureRS = db1?.executeQuery("select natureId,natureOfProblem,natureOfProblemImage from natureOfProblem where productId like (?)", withArgumentsIn: [id]){
                        while natureRS.next() {
                            natureOfProblem.add(natureRS.resultDictionary())
                        }
                        var mutdict = NSMutableDictionary()
                        mutdict = prod.mutableCopy() as! NSMutableDictionary
                        mutdict.setValue(natureOfProblem, forKey: "natureOfProblemDetails")
                        if let equipmentImage = db1?.executeQuery("select productDisplayName,productImage from productList where productId like (?)", withArgumentsIn: [id]){
                            print(equipmentImage.string(forColumn: "productImage"))
                            while equipmentImage.next() {
                                //mutdict.setDictionary(equipmentImage.resultDictionary())
                                mutdict.setValue(equipmentImage.string(forColumn: "productImage"), forKey: "productImage")
                                mutdict.setValue(equipmentImage.string(forColumn: "productDisplayName"), forKey: "productName")
                            }
                        }
                        products.add(mutdict)
                    } else {
                        print("Database failure: \(String(describing: db1?.lastErrorMessage()))")
                    }
                }
                list = products as NSArray
                if list.count == 0 {
                    self.hidePlaceHolderView()
                    DataManager.shareInstance.showAlert(self, title: "", message: "No Equipment found.")
                    self.lblInfo.isHidden = true
                } else {
                    self.hidePlaceHolderView()
                    self.setupData(list)
                }
            }else {
                self.hidePlaceHolderView()
                print("select failure: \(String(describing: db1?.lastErrorMessage()))")
            }

        }
    }
    
    func getEquipmentForProduct(){
//        self.showPlaceHolderView()
        DispatchQueue.main.async {
            self.showPlaceHolderView()
            let fileURL = DBManager.shareInstance.getPath()
            let db1 = FMDatabase(path: fileURL)
            var list:NSArray
            var products:NSMutableArray = []
             var mutdict = NSMutableDictionary()
            db1?.open()
            
          
            if let rs = db1?.executeQuery("select * from registeredDevice where productId like (?)", withArgumentsIn:[self.selectedProductDetail!.object(forKey: "productId") as! String]) {
                while rs.next() {
                    products.addObjects(from: [rs.resultDictionary() as Any])
                }
                
                list = products as NSArray
                if list.count == 0 {
                    self.hidePlaceHolderView()
                    DataManager.shareInstance.showAlert(self, title: "", message: "No Products found.")
                } else {
                    self.hidePlaceHolderView()
                    self.setupData(list)
                }
            }else {
                self.hidePlaceHolderView()
                print("select failure: \(String(describing: db1?.lastErrorMessage()))")
            }
        }
    }
    
    func setupData(_ list:NSArray){
         //self.productList
        let temp : NSMutableDictionary = NSMutableDictionary()
        for i in 0..<list.count{
            let productId = list[i] as! NSDictionary
            if((temp.object(forKey: productId["productFamilyName"] as Any)) != nil){
                //var idArray: NSMutableArray = tem
                let tempDict: NSMutableArray = temp.object(forKey: productId["productFamilyName"] as! String) as! NSMutableArray
                tempDict.add(list[i])
                temp.setObject(tempDict, forKey: productId["productFamilyName"] as! String as NSCopying)
            }else{
                let tempDict : NSMutableArray = NSMutableArray()
                tempDict.add(list[i] as! NSDictionary)
                temp.setObject(tempDict, forKey: productId["productFamilyName"] as! String as NSCopying)
            }
        }
       // temp.setObject(self.selectedProductDetail!.object(forKey: "productName") as! String, forKey: "productName" as NSCopying)

        self.productList = temp.mutableCopy() as? NSDictionary
        print(temp)
        print(self.productList)
        customerIdList = self.productList?.allKeys as! NSArray
        
         self.registeredDeviceTableView.reloadData()
        
    }

    func setupSkipButtonInNavigationBar(){
        let newBtn = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(self.skipButtonPressed))
        //self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.rightBarButtonItem = newBtn
    }
    
    @objc func skipButtonPressed(){
         self.navigationController?.popViewController(animated: true)
         delegate?.skipButtonPressed()
        
       

    }
    
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
        
        DispatchQueue.main.async {
            if let viewWithTag = self.view.viewWithTag(100)
            {
                viewWithTag.removeFromSuperview()
            }
        }
        
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
