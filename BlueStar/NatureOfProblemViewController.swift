//
//  NatureOfProblemViewController.swift
//  Blue Star
//
//  Created by Aditya Chitaliya on 03/03/17.
//  Copyright © 2017 BlueStar. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class NatureOfProblemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate,UITextViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var selectedProductDetails : NSDictionary! = [:]
    var mutableSelectedProductDetails : NSMutableDictionary! = [:]
    var selectedEquipmentDetails : NSDictionary! = [:]
    //var selectedProductNatureOfProblemDetails : NSArray! = []
    var selectedProductNatureOfProblemDetails : NSMutableArray! = []
    var presentationController1: PresentationController?
    var isForcefullyGenerated : AnyObject?
    var ticketNumber: String?
    var modelNo: String? = ""
    var serialNo: String? = ""
    var progressStatus: String?
    var lastUpdatedDate: String?
    var prodId: String?
    var productImage: String?
    var prodName: String?
    var isComingFromDashbord:Bool?
    var problemDesc : ProblemDescriptionView?
    let prodIdForOtherOnly = "F1200"
    //var updatedOn: String?
    //let nav = self.navigationController?.navigationBar
    // MARK: - UIViewControllerTransitioningDelegate
    var totalHeight: Float = 0
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        presentationController1 = PresentationController(presentedViewController: presented, presenting: presenting)
        return presentationController1!
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        //if self.responds(to: #selector(self.setTransitioningDelegate)) {
        
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
        //}
    }
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let combinedData:NSMutableDictionary = NSMutableDictionary()
        
        if(selectedProductDetails.count > 0){
            for key in selectedProductDetails.allKeys{
                combinedData.setValue(selectedProductDetails.value(forKey: key as! String), forKey: key as! String)
            }
            combinedData.setValue(selectedProductDetails.value(forKey: "productDisplayName"), forKey: "productName")
        }
        if(selectedEquipmentDetails.count>0){
            for key in selectedEquipmentDetails.allKeys{
                combinedData.setValue(selectedEquipmentDetails.value(forKey: key as! String), forKey: key as! String)
            }
        }
        
        selectedProductDetails = combinedData.mutableCopy() as! NSDictionary
        
         let nc = NotificationCenter.default
         nc.addObserver(self, selector: #selector(doGenerateTicket), name: NSNotification.Name(rawValue: "ticketDoGenerate"), object: nil)
        nc.addObserver(self, selector: #selector(selfdismiss), name: NSNotification.Name(rawValue: "dismissView"), object: nil)
        nc.addObserver(self, selector: #selector(selfdismiss), name: NSNotification.Name(rawValue: "dismissNatureOfProblem"), object: nil)
        

        /*if let addOthers = UserDefaults.standard.value(forKey: "AddCooling"){
            presentationController1?.height = CGFloat(selectedProductNatureOfProblemDetails.count * 65 + 125);
        }
        else
        {
            presentationController1?.height = CGFloat(selectedProductNatureOfProblemDetails.count * 65 + 50);
        }*/
        
        presentationController1?.height = CGFloat(selectedProductNatureOfProblemDetails.count * 65 + 50);
        
        tableView.isScrollEnabled = false
        
        self.showPlaceHolderView()
        
        if (presentationController1?.height)! > (UIScreen.main.bounds.size.height - 80) {
            
            presentationController1?.height = (UIScreen.main.bounds.size.height - 80)
            tableView.isScrollEnabled = true
        }

        presentationController1?.presentationTransitionWillBegin()
        
        if(isComingFromDashbord)!{
            if(isForcefullyGenerated?.isEqual(to: ""))!
            {
                isForcefullyGenerated = "false" as AnyObject?
            }
        }
        //print(isForcefullyGenerated)
        self.hidePlaceHolderView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let screenClass = self.classForCoder.description()
        print("NOPVC : nature of problems - \(selectedProductNatureOfProblemDetails)")
        print("NOPVC : product detail - \(selectedProductDetails)")
        
        mutableSelectedProductDetails =  (selectedProductDetails.mutableCopy() as! NSMutableDictionary)
        
        Analytics.setScreenName("Nature of Problem Screen", screenClass: screenClass)
        Analytics.logEvent("page_view",parameters: ["page":"Nature of Problem Screen"])
    }
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    @objc func selfdismiss(){
             self.dismiss(animated: true, completion: nil)
    }
    
    func getAddressForCustomerId(_ customerId: String) -> Dictionary<String, AnyObject>{
        var address :Dictionary<String, AnyObject> = [:]
        var user: Dictionary<String, AnyObject> = PlistManager.sharedInstance.getValueForKey("user") as! Dictionary<String, AnyObject>
        let add = user["addresses"] as! NSArray
        for i in 0..<add.count{
            let addr:Dictionary<String, AnyObject> = add[i] as! Dictionary<String, AnyObject>
            if addr["customerId"] as! String == customerId{
                address = addr
            }
        }
        return address
    }
    
    // MARK: - UITableView Delegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 65
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 65
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        /*if let addOthers = UserDefaults.standard.value(forKey: "AddCooling")
        {
            return 1
        }
        else
        {
            return selectedProductNatureOfProblemDetails.count
        }*/
       return selectedProductNatureOfProblemDetails.count
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        let cell : NatureOfProblemTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "natureOfProblemTableViewCell") as! NatureOfProblemTableViewCell!
        
        /*if let addOthers = UserDefaults.standard.value(forKey: "AddCooling"){
            cell.problemListLbl.text = "Not Cooling"
            cell.problemListImg.image = UIImage(named: "fan")
            cell.problemListImg.contentMode = .scaleAspectFit
        }
        
        else
        {
            let natureOfProblem = (selectedProductNatureOfProblemDetails.object(at: indexPath.row) as! NSDictionary)
            let Problem = natureOfProblem .value(forKey: "natureOfProblem") as! String?
            let natureOfProblemImage = natureOfProblem .value(forKey: "natureOfProblemImage") as! String?
            let natureOfProblemImageUrl = URL(string: natureOfProblemImage!)
            
            if (natureOfProblemImageUrl != nil) {
                cell.problemListImg.af_setImage(withURL: natureOfProblemImageUrl!, placeholderImage: placeholderImage)
                cell.problemListImg.contentMode = .scaleAspectFit
            }
            else {
                cell.problemListImg.contentMode = .scaleAspectFit
                cell.problemListImg.image = UIImage(named: "other.png")
            }

            cell.problemListLbl.text = natureOfProblem .value(forKey: "natureOfProblem") as! String?
            //var natureOfProblemString = natureOfProblem .value(forKey: "natureOfProblem") as! String?
            //cell.problemListLbl.text = natureOfProblemString?.lowercased().capitalizingFirstLetter()
            cell.contentView.backgroundColor = UIColor(patternImage: UIImage(named: "GradientBg.png")!)
            totalHeight += Float(cell.frame.height)
        }*/
        
        // old functions start
        
        
        
        let natureOfProblem = (selectedProductNatureOfProblemDetails.object(at: indexPath.row) as! NSDictionary)
        let Problem = natureOfProblem .value(forKey: "natureOfProblem") as! String?
        let natureOfProblemImage = natureOfProblem .value(forKey: "natureOfProblemImage") as! String?
        let natureOfProblemImageUrl = URL(string: natureOfProblemImage!)
        
        if (natureOfProblemImageUrl != nil) {
            cell.problemListImg.af_setImage(withURL: natureOfProblemImageUrl!, placeholderImage: placeholderImage)
            cell.problemListImg.contentMode = .scaleAspectFit
        }
        else {
            cell.problemListImg.contentMode = .scaleAspectFit
            cell.problemListImg.image = UIImage(named: "other.png")
        }

        cell.problemListLbl.text = natureOfProblem .value(forKey: "natureOfProblem") as! String?
        //var natureOfProblemString = natureOfProblem .value(forKey: "natureOfProblem") as! String?
        //cell.problemListLbl.text = natureOfProblemString?.lowercased().capitalizingFirstLetter()
        cell.contentView.backgroundColor = UIColor(patternImage: UIImage(named: "GradientBg.png")!)
        totalHeight += Float(cell.frame.height)
        
        // old function end
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.showPlaceHolderView()
        
        if let addOthers = UserDefaults.standard.value(forKey: "AddCooling"){
//            self.ticketGenerationProcess(problemType: "Not Cooling")
            
            if NetworkChecker.isConnectedToNetwork() {
                self.showPlaceHolderView()
                
                let natureOfProblem = (selectedProductNatureOfProblemDetails.object(at: indexPath.row) as! NSDictionary)
                let selectedProblem = natureOfProblem .value(forKey: "natureOfProblem") as! String
                
                let addressDb = UserAddressesDatabaseModel.shareInstance.getUserAddrress(PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String)
                 let address = addressDb .object(at: 0) as! NSDictionary
                
                isForcefullyGenerated = true as AnyObject
                var values: Dictionary<String, AnyObject> = [:]
                values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
                values["isForcefullyGenerated"] = self.isForcefullyGenerated as AnyObject?
                values["platform"] = platform as AnyObject?
                values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
                
                let prodID = "F1200"
                values["productId"] = prodID as AnyObject
                
                values["customerId"] = address .value(forKey: "customerId") as AnyObject
    //                .value(forKey: "customerId") as AnyObject
                //let selectedProblem = "Not Cooling"
               
                values["natureOfProblem"] = selectedProblem as AnyObject?
                
                self.productImage = ""
                self.prodId = prodID
                self.prodName = ""
                self.modelNo = ""
                self.serialNo = ""
                
                let addresses = address
                
                print(values)
                
                if(selectedProblem == "Others"){
                    self.addProblemDescription()
                }else{
                    DataManager.shareInstance.getDataFromWebService(generateTicketURLMize, dataDictionary:values as NSDictionary) { (result, error) -> Void in
                        if error == nil {
                            DispatchQueue.main.async {
                                self.problemDesc?.removeFromSuperview()
                                self.hidePlaceHolderView()
                                GenerateTicketModel.shareInstance.parseResponseObject(result)
                                
                                let status = GenerateTicketModel.shareInstance.status!
                                
                                //self.updatedOn = GenerateTicketModel.shareInstance.updates!
                                if status == "error" {
                                    let message = GenerateTicketModel.shareInstance.errorMessage!
                                    DataManager.shareInstance.showAlert(self, title: messageTitle, message: message)
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
                                self.problemDesc?.removeFromSuperview()
                                self.hidePlaceHolderView()
                                if error?.code != -999 {
                                    DataManager.shareInstance.showAlert(self, title: (error?.domain)!, message: (error?.localizedDescription)!)
                                }
                            }
                        }
                    }
                }
               
            }
            else {
                DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
            }
        }
        else
        {
            let natureOfProblem = (selectedProductNatureOfProblemDetails.object(at: indexPath.row) as! NSDictionary)
            let selectedProblem = natureOfProblem .value(forKey: "natureOfProblem") as! String
            
            if(selectedProblem == "Others"){
                self.addProblemDescription()
            }else{
                self.ticketGenerationProcess(problemType: selectedProblem)
            }
        }
        //Show choose Address
        
    }
    func addProblemDescription() {
        print("Showing description view...")
        problemDesc = Bundle.main.loadNibNamed("ProblemDescriptionView", owner: self, options: nil)?.first as? ProblemDescriptionView

        problemDesc!.pdCancelButton.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
        problemDesc!.pdOkButton.addTarget(self, action: #selector(okButtonClicked), for: .touchUpInside)

        
        problemDesc!.contentView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(problemDesc!.contentView)
            NSLayoutConstraint.activate([
                problemDesc!.contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                problemDesc!.contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//                problemDesc!.contentView.heightAnchor.constraint(equalToConstant: 50),
//                problemDesc!.contentView.widthAnchor.constraint(equalToConstant: 50)
            ])
        
//        self.view.addSubview(problemDesc!.contentView)
    }
    // MARK: - Helper Methods
    @objc func cancelButtonClicked() {
        print("cancel button clicked")
        problemDesc?.removeFromSuperview()
        self.hidePlaceHolderView()
        self.presentationController1?.dimmingViewClicked(self)
    }
    
    @objc func okButtonClicked() {
        print("ok button clicked")
        print("Problem description",problemDesc?.descriptionTextview.text as! String)
        var probDescription = problemDesc?.descriptionTextview.text
        if((probDescription?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count)! > 0){
            print("Description added. Send ",probDescription)
        }else{
            print("Blank description. Send Other as description")
            probDescription = "Others"
        }
         self.ticketGenerationProcess(problemType: probDescription!)
        // remove extra UI component
        /*
         logic need to shift to response
         problemDesc?.removeFromSuperview()
        self.hidePlaceHolderView()
        self.presentationController1?.dimmingViewClicked(self)*/
    }
    
    func ticketGenerationProcess(problemType: String){
        /// NOTES :
        ///used in non other options
        
        let addresses = UserAddressesDatabaseModel.shareInstance.getUserAddrress(PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String)
        //userData["addresses"] as! NSArray
        self.hidePlaceHolderView()
        if(isComingFromDashbord)!{
            if(self.selectedEquipmentDetails.allKeys.count > 0){
                self.doGenerateTicketForEquipment(problemType)
                //integrate Direct ticket generation api
            }else{
                if addresses.count > 1 {
                    let controller:RegisterAddressViewController = self.storyboard!.instantiateViewController(withIdentifier: "RegisterAddressView") as! RegisterAddressViewController
                    
                    controller.problem = problemType
                    controller.selectedProductDetails = self.selectedProductDetails
                    controller.isForcefullyGenerated = self.isForcefullyGenerated
                    controller.isComingFromDashbord = true
                    controller.view.frame = self.view.bounds
                    controller.view.backgroundColor = UIColor(white: 0.1, alpha: 0.65)
                    controller.willMove(toParent: self)
                    self.view.addSubview(controller.view)
                    self.addChild(controller)
                    controller.didMove(toParent: self)
                } else {
                    problemDesc?.removeFromSuperview()
                    self.hidePlaceHolderView()
                    self.doGenerateTicket(problemType)
                }
            }
        }else{
            // changing order or execution of below method
            //self.doGenerateTicketForEquipment(problemType)
            //problemDesc?.removeFromSuperview()
            //self.hidePlaceHolderView()
            problemDesc?.removeFromSuperview()
            self.hidePlaceHolderView()
            self.doGenerateTicketForEquipment(problemType)
        }
        
    }
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count // for Swift use count(newText)
        return numberOfChars <= 1000;
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
    
    @objc func doGenerateTicket(_ selectedProblem: String) {
        
        if NetworkChecker.isConnectedToNetwork() {
            self.showPlaceHolderView()
            
            let addressDb = UserAddressesDatabaseModel.shareInstance.getUserAddrress(PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String)
            if addressDb.count == 0 {
                print("empty array")
                self.problemDesc?.removeFromSuperview()
                self.hidePlaceHolderView()
            }
            else {
                print(" non empty array")
                let address = addressDb .object(at: 0) as! NSDictionary
                var values: Dictionary<String, AnyObject> = [:]
                values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
                values["isForcefullyGenerated"] = self.isForcefullyGenerated as AnyObject?
                values["platform"] = platform as AnyObject?
                values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
                values["productId"] = selectedProductDetails.value(forKey: "productId") as AnyObject?
                values["customerId"] = address .value(forKey: "customerId") as AnyObject
    //                .value(forKey: "customerId") as AnyObject
                
                values["natureOfProblem"] = selectedProblem as AnyObject?
                print("Values")
                print(values)
                self.productImage = self.selectedProductDetails.value(forKey: "productImage") as? String
                self.prodId = self.selectedProductDetails.value(forKey: "productId") as? String
                self.prodName = self.selectedProductDetails.value(forKey: "productDisplayName") as? String
                self.modelNo = ""
                self.serialNo = ""
                
                let addresses = address
                
                print(values)
                
                DataManager.shareInstance.getDataFromWebService(generateTicketURLMize, dataDictionary:values as NSDictionary) { (result, error) -> Void in
                    if error == nil {
                        DispatchQueue.main.async {
                            self.problemDesc?.removeFromSuperview()
                            self.hidePlaceHolderView()
                            GenerateTicketModel.shareInstance.parseResponseObject(result)
                            
                            let status = GenerateTicketModel.shareInstance.status!
                            
                            //self.updatedOn = GenerateTicketModel.shareInstance.updates!
                            if status == "error" {
                                let message = GenerateTicketModel.shareInstance.errorMessage!
                                DataManager.shareInstance.showAlert(self, title: messageTitle, message: message)
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
                            self.problemDesc?.removeFromSuperview()
                            self.hidePlaceHolderView()
                            if error?.code != -999 {
                                DataManager.shareInstance.showAlert(self, title: (error?.domain)!, message: (error?.localizedDescription)!)
                            }
                        }
                    }
                }
            }
        }
        else {
            DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
        }
    }
    
    
    func doGenerateTicketForEquipment(_ selectedProblem: String) {
        
        if NetworkChecker.isConnectedToNetwork() {
            self.showPlaceHolderView()
            var values: Dictionary<String, AnyObject> = [:]
            values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
            values["platform"] = platform as AnyObject?
            values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey") as AnyObject
            values["natureOfProblem"] = selectedProblem as AnyObject?
            values["isForcefullyGenerated"] = self.isForcefullyGenerated as AnyObject?
            if let addOthers = UserDefaults.standard.value(forKey: "AddCooling"){
                values["productId"] = self.prodIdForOtherOnly as AnyObject
                self.prodId = self.prodIdForOtherOnly as? String
            }else{
                values["productId"] = selectedProductDetails.value(forKey: "productId") as AnyObject?
                self.prodId = self.selectedProductDetails.value(forKey: "productId") as? String
            }
            
            values["model"] = selectedProductDetails.object(forKey: "modelNo") as AnyObject?
            values["serialNumber"] = selectedProductDetails.object(forKey: "serialNo") as AnyObject?
            values["customerId"] = selectedProductDetails.object(forKey: "customerId") as AnyObject?
            //isForcefullyGenerated
            self.productImage = self.selectedProductDetails.value(forKey: "productImage") as? String
            
            self.prodName = self.selectedProductDetails.value(forKey: "productName") as? String
            self.modelNo = self.selectedProductDetails.value(forKey: "modelNo") as? String
            self.serialNo = self.selectedProductDetails.value(forKey: "serialNo") as? String

            values["natureOfProblem"] = selectedProblem as AnyObject?
            
            print("NOPVC : param values \(values)")
            
            if selectedEquipmentDetails == nil || (selectedEquipmentDetails.object(forKey: "customerId") == nil) {
                // only if found the selectedEquipmentDetails is nil, so updating with selected product, to get updated customerId
                self.selectedEquipmentDetails = self.selectedProductDetails
            }
            
            let addresses = self.getAddressForCustomerId(selectedEquipmentDetails.object(forKey: "customerId") as! String)
            DataManager.shareInstance.getDataFromMizeWebService(generateTicketURLMize, dataDictionary:values as NSDictionary) { (result, error) -> Void in
                if error == nil {
                    DispatchQueue.main.async {
                        self.problemDesc?.removeFromSuperview()
                        self.hidePlaceHolderView()
                        GenerateTicketModel.shareInstance.parseResponseObject(result)
                       
                        let status = GenerateTicketModel.shareInstance.status!
                        
                        //self.updatedOn = GenerateTicketModel.shareInstance.updates!
                        if status == "error" {
                             let message = GenerateTicketModel.shareInstance.errorMessage
                            DataManager.shareInstance.showAlert(self, title: messageTitle, message: message!)
                        }
                        else {
                            //GenerateTicketModel.shareInstance.modelNo = self.selectedEquipmentDetails.object(forKey: "modelNo") as! String?
                            //GenerateTicketModel.shareInstance.serialNo = self.selectedEquipmentDetails.object(forKey: "serialNo") as! String?
                            // extra non functional
                            let message = GenerateTicketModel.shareInstance.message
                           DataManager.shareInstance.showAlert(self, title: messageTitle, message: message!)
                            
                            // extra message
                            self.ticketNumber = GenerateTicketModel.shareInstance.ticketNumber!
                            self.lastUpdatedDate = GenerateTicketModel.shareInstance.updatedOn!
                            self.progressStatus = GenerateTicketModel.shareInstance.progressStatus!
                            self.modelNo = GenerateTicketModel.shareInstance.modelNo!
                            self.serialNo = GenerateTicketModel.shareInstance.serialNo!
                            self.hidePlaceHolderView()
                            self.presentationController1?.dimmingViewClicked(self)
                            //self.addTicketToDB()
                            let tkt = LocalTicket()
                            tkt.number = GenerateTicketModel.shareInstance.ticketNumber!
                            tkt.lastUpdateDate = GenerateTicketModel.shareInstance.updatedOn!
                            tkt.productId = values["productId"] as! String
                            tkt.productSerialNo = GenerateTicketModel.shareInstance.serialNo!
                            tkt.productModelNo = GenerateTicketModel.shareInstance.modelNo!
                            tkt.progressStatus = GenerateTicketModel.shareInstance.progressStatus!
                            tkt.productName = GenerateTicketModel.shareInstance.productName!
                            //tkt.productImage = self.selectedProductDetails.value(forKey: "productImage") as? String ?? "http://bluestar-uat.s3.amazonaws.com/CCAPP/images/F1200.png"
                            
                            tkt.productImage = self.selectedProductDetails.value(forKey: "productImage") as? String ?? ""
                            self.addTicketToDBWithParams(tktForLocal: tkt)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ticketGeneratedRefreshView"), object: nil)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "displayTicketView"), object: addresses)
                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.problemDesc?.removeFromSuperview()
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
    
    
    // this function is killing all logic need to be carefull, making new for further uses with parameteres
    func addTicketToDB() {
        let fileURL = DBManager.shareInstance.getPath()
        let db1 = FMDatabase(path: fileURL)
        db1?.open()
        //        if(date.trim() == "" ){
        //            date = ""
        //        } else if(status.trim() == "") {
        //            status = ""
        //        }
        let check = "INSERT or replace into ticketHistory (ticketNumber,lastUpdatedDate,productImage,productId,progressStatus,productName,modelNo,serialNo) VALUES ('\(ticketNumber!)','\(lastUpdatedDate!)','\(productImage ?? "")','\(prodId!)','\(progressStatus!)','\(prodName!)','\(modelNo!)','\(serialNo!)')"
        //print(check)
        let isinserted = db1?.executeUpdate(check, withArgumentsIn: nil)
        
        if(!isinserted!){
            print("Database failure: \(String(describing: db1?.lastErrorMessage()))")
        }
//        let isinserted = db1?.executeUpdate("INSERT INTO ticketHistory (ticketNumber,lastUpdatedDate,productId,progressStatus,productName,productImage) VALUES (?,?,?,?,?,?)", withArgumentsIn: [ticketNumber,lastUpdatedDate,prodId,progressStatus,prodName,productImage])
//        
//        if(!isinserted!){
//            print("Database failure: \(db1?.lastErrorMessage())")
//        }
        
        db1?.close()
        
        
    }
    
    func addTicketToDBWithParams(tktForLocal : LocalTicket) {
        let fileURL = DBManager.shareInstance.getPath()
        let db1 = FMDatabase(path: fileURL)
        db1?.open()
     
        /*let check = "INSERT or replace into ticketHistory (ticketNumber,lastUpdatedDate,productImage,productId,progressStatus,productName,modelNo,serialNo) VALUES ('\(ticketNumber!)','\(lastUpdatedDate!)','\(productImage ?? "")','\(prodId!)','\(progressStatus!)','\(prodName!)','\(modelNo!)','\(serialNo!)')"*/
        let check = "INSERT or replace into ticketHistory (ticketNumber,lastUpdatedDate,productImage,productId,progressStatus,productName,modelNo,serialNo) VALUES ('\(tktForLocal.number)','\(tktForLocal.lastUpdateDate)','\(tktForLocal.productImage)','\(tktForLocal.productId)','\(tktForLocal.progressStatus)','\(tktForLocal.productName)','\(tktForLocal.productModelNo)','\(tktForLocal.productSerialNo)')"
       
        let isinserted = db1?.executeUpdate(check, withArgumentsIn: nil)
        if(!isinserted!){
            print("Database failure: \(String(describing: db1?.lastErrorMessage()))")
        }
        db1?.close()
    }
}
class LocalTicket{
    var number : String = ""
    var lastUpdateDate : String = ""
    var productImage : String = ""
    var productId : String = ""
    var progressStatus : String = ""
    var productName : String = ""
    var productModelNo : String = ""
    var productSerialNo : String = ""
}
