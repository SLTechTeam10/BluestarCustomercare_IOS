//
//  ProductListPickerVC.swift
//  Blue Star
//
//  Created by Kamlesh on 11/10/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit
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


class ProductListPickerVC: UIViewController ,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buttonDoneSave: UIButton!

    let arrayProductList : NSArray = ProductBL.shareInstance.products
    let arraySelectedProductList : NSMutableArray = []
    
    var isFromDashboard :Bool = false
    var isFromRegistration :Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        if isFromDashboard {
            buttonDoneSave.setTitle("Save", for:UIControl.State())
        }else{
            buttonDoneSave.setTitle("Done", for:UIControl.State())
        }
        // Do any additional setup after loading the view.
        arraySelectedProductList.addObjects(from: ProductBL.shareInstance.selectedProducts as [AnyObject])
        
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        let nibName=UINib(nibName: "ProductCell", bundle:nil)
        self.collectionView.register(nibName, forCellWithReuseIdentifier: "ProductCell")
        collectionView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let screenClass = self.classForCoder.description()
        Analytics.setScreenName("Select Product List Screen", screenClass: screenClass)
        Analytics.logEvent("page_view",parameters: ["page":"Select Product Screen"])
        // additional signup event add
        Analytics.logEvent(AnalyticsEventSignUp, parameters: [
            AnalyticsParameterMethod:"SIGN_UP"
        ])
    }
    @IBAction func backButtonAction(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion:{
            
        })
    }
    @IBAction func doneButtonAction(_ sender: AnyObject) {

        if isFromDashboard {
            saveUserData()
        }else{
            ProductBL.shareInstance.selectedProducts = arraySelectedProductList
            self.dismiss(animated: true, completion:{
                let nc = NotificationCenter.default
                nc.post(name: Notification.Name(rawValue: "updateProductSelection"), object: nil)
                
            })
        }
    }
    
    // MARK:- Collection view delegates
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var numOfSections: Int = 0
        collectionView.backgroundView = nil
        numOfSections = 1
        return numOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return  arrayProductList.count
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
        let cell : ProductCell = (collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell)!
        let product  = arrayProductList.object(at: indexPath.row) as! ProductData

        cell.labelProductName.text = product.productDisplayName
        //cell.imageViewProduct.imageFromUrl(product.productImageUrl!)

        let imageUrl = URL(string: product.productImageUrl!)
        
        cell.imageViewProduct.af_setImage(withURL: imageUrl!, placeholderImage: placeholderImage)


        if (arraySelectedProductList.contains(product)) {
            cell.imageViewCheckMark.isHidden = false
        }else{
            cell.imageViewCheckMark.isHidden = true
        }

        let lineViewBottom = UIView(frame: CGRect(x: 0, y: cell.frame.size.height-1, width: cell.frame.size.width, height: 1))
        lineViewBottom.backgroundColor = UIColor(netHex: 0xDEDFE0)
        let lineViewRight = UIView(frame: CGRect(x: cell.frame.size.width-1, y: 0, width: 1, height: cell.frame.size.height))
        lineViewRight.backgroundColor = UIColor(netHex: 0xDEDFE0)
        cell.addSubview(lineViewBottom)
        cell.addSubview(lineViewRight)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! ProductCell
        let option = self.arrayProductList.object(at: indexPath.row) as! ProductData
        
        if arraySelectedProductList.contains(option) {
            if !isFromRegistration {
                if (TicketHistoryModel.shareInstance.tickets?.count)! >= 0 {
                    //check if any added product status is running for service
                    let productInfo = TicketHistoryModel.shareInstance.productStatus(option.productId! as NSString)
                    if productInfo.allKeys.count>0 {
                        
                        let productStatus = productInfo["progressStatus"] as! String
                        
                        //if (productStatus.trim().caseInsensitiveCompare(statusWorkCompleted) == ComparisonResult.orderedSame ||  productStatus.trim().caseInsensitiveCompare(statusClosed) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusCallCancelled) == ComparisonResult.orderedSame  || productStatus.trim().caseInsensitiveCompare(statusAppointmentFixedForWorkCompletion) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusCallOnHoldObligationDispute) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusCallOnHoldAwaitingCustomerClearance) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusCallAttendedPendingForMaterial) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusWorkStartedAtSite) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusWorkInProcess) == ComparisonResult.orderedSame){
                        if(productStatus.trim().caseInsensitiveCompare(statusDispatchedMize) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusDispatchRejectedMize) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusMaterialPendingMize) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusQueuedMize) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusWorkStartedMize) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusAllocatedMize) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusDispatchAcceptedMize) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusInWorkMize) == ComparisonResult.orderedSame){
                            //DataManager.shareInstance.showAlert(self, title:"Warning", message:unRegisterProductMessage)
                            let message = "You cannot remove " + option.productDisplayName! + " as you have one or more open tickets against it."
                            
                            
                            let alert = UIAlertController(title:"Warning", message:message, preferredStyle: .alert)
                            
                            //alert.view.frame = UIScreen.mainScreen().applicationFrame
                            let action = UIAlertAction(title:oKey, style: .default) { _ in
                                //   vc.dismissViewControllerAnimated(true, completion: nil)
                            }
                            alert.addAction(action)
                            self.present(alert, animated: true){}
                            
                            
                        }else{
                            //                        selectUnSelectProduct(option, cell: cell)
                            cell.imageViewCheckMark.isHidden = true
                            arraySelectedProductList.remove(option)
                            
                            
                        }
                    }else{
                        cell.imageViewCheckMark.isHidden = true
                        arraySelectedProductList.remove(option)
                        
                    }
                }
            } else {
                cell.imageViewCheckMark.isHidden = true
                arraySelectedProductList.remove(option)
            }
        } else {
            cell.imageViewCheckMark.isHidden = false
            arraySelectedProductList.add(option)
        }
        
    }
    
    func selectUnSelectProduct(_ product:ProductData , cell: ProductCell) {
        
        if arraySelectedProductList.contains(product) {
            cell.imageViewCheckMark.isHidden = true
            arraySelectedProductList.remove(product)
        }
        else{
            cell.imageViewCheckMark.isHidden = false
            arraySelectedProductList.add(product)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2), height: 140)
    }
    
    
    func animateCell(_ cell: UICollectionViewCell) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.5
        cell.layer.add(animation, forKey: animation.keyPath)
    }
    
    func saveUserData() {
        self.view.endEditing(true)
        if NetworkChecker.isConnectedToNetwork() {
            if validateData() {
                showPlaceHolderView()
                var values: Dictionary<String, AnyObject> = [:]
                let userData = PlistManager.sharedInstance.getValueForKey("user") as! NSDictionary

                var user: Dictionary<String, AnyObject> = userData as! Dictionary<String, AnyObject>
                user .removeValue(forKey: "ibaseNumber")
                user .removeValue(forKey: "pin")
                user .removeValue(forKey: "preferedCallingNumber")
                user .removeValue(forKey: "alternateNoPreference")
                user .removeValue(forKey: "alternatemobilenumber")
                user["addresses"] = [] as NSArray
//                user["firstName"] = (cellProfileView.firstNameTextField.text?.trim())!
//                user["lastName"] = (cellProfileView.lastNameTextField.text?.trim())!
//                user["alternatemobilenumber"] = (cellProfileView.alternateMobileNoTextField.text?.trim())!
                
                
//                user["email"] = (cellProfileView.emailTextField.text?.trim())!
//                if((cellProfileView.preferredTimeStartTextField.text?.trim()) != "") {
//                    let time = (cellProfileView.preferredTimeStartTextField.text?.trim())!
//                    dateFormatter.dateFormat = "HH:mm"
//                    let date = dateFormatter.dateFromString(time)
//                    dateFormatter.dateFormat = "HH:mm:ss"
//                    let newTime = dateFormatter.stringFromDate(date!)
//                    user["prefferedTimingFrom"] = newTime
//                }
//                if((cellProfileView.preferredTimeEndTextField.text?.trim()) != "") {
//                    let time = (cellProfileView.preferredTimeEndTextField.text?.trim())!
//                    dateFormatter.dateFormat = "HH:mm"
//                    let date = dateFormatter.dateFromString(time)
//                    dateFormatter.dateFormat = "HH:mm:ss"
//                    let newTime = dateFormatter.stringFromDate(date!)
//                    user["prefferedTimingTo"] = newTime
//                }
                
                values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
                
                var productIds : String = ""
                if (ProductBL.shareInstance.selectedProducts.count>0) {
                    
                    for  product in ProductBL.shareInstance.selectedProducts {
                        let selectedProduct = product as! ProductData
                        productIds = productIds + selectedProduct.productId! + ","
                    }
                    if productIds.characters.count>1 {
                        productIds = String(productIds.characters.dropLast())
                    }
                    print(productIds)
                }
                if productIds.characters.count>0 {
                    user["registeredProductsIds"] = productIds as AnyObject?
                }
                
                values["user"] = user as AnyObject?
                values["platform"] = platform as AnyObject?
                values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
                
                print("param >> \(values)")
                
                DataManager.shareInstance.getDataFromWebService(registerUserURLMize, dataDictionary:values as NSDictionary) { (result, error) -> Void in
                    if error == nil {
                        DispatchQueue.main.async {
                            self.hidePlaceHolderView()
                            RegisterUserModel.shareInstance.parseResponseObject(result)
                            let status = RegisterUserModel.shareInstance.status!
                            if status == "error" {
                                let message = RegisterUserModel.shareInstance.errorMessage!
                                DataManager.shareInstance.showAlert(self, title: messageTitle, message: message)
                            } else {
                                PlistManager.sharedInstance.saveValue(user as AnyObject, forKey: "user")
                                let refreshAlert = UIAlertController(title: "Success", message:"Profile has been updated.", preferredStyle: UIAlertController.Style.alert)
                                
                                
                                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                    
                                    self.dismiss(animated: true, completion:{
                                        let nc = NotificationCenter.default
                                        nc.post(name: Notification.Name(rawValue: "refreshProductsList"), object: nil)//refresh dashboard data
                                    })

                                }))
//                                self.addProductToUserDB()
                                self.present(refreshAlert, animated: true, completion: nil)
                                
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
    
    
    //=========================================Product List Database=============================================================>
    func addProductToDB(){
        let fileURL = DBManager.shareInstance.getPath()
        let db1 = FMDatabase(path: fileURL)
        
        
        let allProductList: NSMutableArray
        allProductList = ProductBL.shareInstance.products
        db1?.open()
        let isdeleted = db1?.executeUpdate("DELETE FROM productList", withArgumentsIn:nil)
        if(isdeleted!)
        {
            for var i in 0..<allProductList.count {
                let products = allProductList[i] as! NSMutableDictionary
                let productDisplayName = products["productDisplayName"] as! String
                let natureOfProblemDetails = products["natureOfProblemDetails"] as! NSArray
                let productId = products["productId"] as! String
                let productImage = products["productImage"] as! String
                let productname = products["productname"] as! String
                
                let isinserted = db1?.executeUpdate("INSERT INTO productList (productId,productname,productDisplayName,natureOfProblemDetails,productImage) VALUES (?,?,?,?,?)", withArgumentsIn: [productId,productname,productDisplayName,natureOfProblemDetails,productImage])
                
                if(!isinserted!){
                    print("Database Insert failure: \(db1?.lastErrorMessage())")
                }
            }
            
        } else {
            print("Database Delete failure: \(db1?.lastErrorMessage())")
        }
    }
    
    
    
    func addProductToUserDB(){
        let fileURL = DBManager.shareInstance.getPath()
        let db1 = FMDatabase(path: fileURL)
        
        
        var user = UserDetailsDatabaseModel.shareInstance.getUserDetails(PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String)
        
        var queryString : String
        var queryString2 = ""
        
        for case let product as ProductData in ProductBL.shareInstance.selectedProducts {
            // do something with button
            var productID = product.value(forKey: "productId")! as! String
            queryString = productID + ","
            queryString2.append(queryString)
        }
        queryString2.removeLast()
        print(queryString2)
        
        print(user["registeredProductsIds"])
        user["registeredProductsIds"] = queryString2 as AnyObject
        
        UserDetailsDatabaseModel.shareInstance.addUserDetails(PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String? ?? "", user as Dictionary<String, AnyObject>)
        
        
        
        
        let allProductList: NSMutableArray
        allProductList = ProductBL.shareInstance.products
        db1?.open()
        let isdeleted = db1?.executeUpdate("DELETE FROM productList", withArgumentsIn:nil)
        if(isdeleted!)
        {
            for var i in 0..<allProductList.count {
                let products = allProductList[i] as! NSMutableDictionary
                let productDisplayName = products["productDisplayName"] as! String
                let natureOfProblemDetails = products["natureOfProblemDetails"] as! NSArray
                let productId = products["productId"] as! String
                let productImage = products["productImage"] as! String
                let productname = products["productname"] as! String
                
                let isinserted = db1?.executeUpdate("INSERT INTO productList (productId,productname,productDisplayName,natureOfProblemDetails,productImage) VALUES (?,?,?,?,?)", withArgumentsIn: [productId,productname,productDisplayName,natureOfProblemDetails,productImage])
                
                if(!isinserted!){
                    print("Database Insert failure: \(db1?.lastErrorMessage())")
                }
            }
            
        } else {
            print("Database Delete failure: \(db1?.lastErrorMessage())")
        }
    }

    
    func showPlaceHolderView() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

        let controller:UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "PlaceHolderView")
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
    
    func validateData() -> Bool {
        if arraySelectedProductList.count == 0 {
            DataManager.shareInstance.showAlert(self, title: "Product", message:"Please select at least one product.")
            return false;
        }else{
            ProductBL.shareInstance.selectedProducts = arraySelectedProductList
            return true;
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
