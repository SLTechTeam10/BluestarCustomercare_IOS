//
//  RegisterTwoVC.swift
//  BlueStar
//
//  Created by Ashish Rathod on 21/10/21.
//  Copyright © 2021 BlueStar. All rights reserved.
//

import UIKit
import FirebaseAnalytics
import Firebase

class RegisterTwoVC: UIViewController , AddressActionProtocol, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate,ProductTokenViewDelegate{
    
    
    func onAddNewAddress() {
        print("on Add New Address Called")
    }

    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblTitleReg: UILabel!
    
    var iBaseCodeTextFieldView = iBaseView()
    var addressTypeView = AddressTypeRadioBtns()
    var isCompanyNameDisplayed : Bool = false
    var resConfigTextField : UITextField!
    var companyNameTextField : UITextField!
    var address1StateTextField: UITextField!
    var resConfPickerView = UIPickerView()
    var address1TextField = TextFieldwithInfoView()
    var selectedResConfig: String!
    var address1PincodeTextField: UITextField!
    
    var isAddressAutoFilled : Bool = false
    
    var addressLine2 = AddressLine2TextField()
    var address1LocalityTextField: UITextField!
    var address1CityTextField: UITextField!
    var selectedStateCode: String!
    
    var emailTextField = TextFieldView()
    var chooseProductTextField = DropDownView()
    var productTokenField:ProductTokenView!// = ProductTokenView()
    
    var  tokenViewheight:CGFloat = 30.0
    var buttonSubmit:UIButton!
    
    var primaryNoCheckBoxButton:UIButton!
    var alternateNoCheckBoxButton:UIButton!
    
    var isChecked : Bool = false
    
    let dateFormatter = DateFormatter()
    
    var preferredTimeTextField = PreferredTimeTextFieldView()
    
    var strTitle : String!
    var strFirstName = ""
    var strLastName = ""
    var strGender = ""
    var strYears = ""
    var strMobileNumber = ""
    var strAlternateMobileNumber = ""
    var strSelState = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialization()
        
    }
    
    func initialization()
    {

        if let strTit = UserDefaults.standard.value(forKey: "strTitle") as? String{
            self.strTitle = strTit
        }
        
        if let strFName = UserDefaults.standard.value(forKey: "strFirstName") as? String{
            self.strFirstName = strFName
        }
        
        if let strLName = UserDefaults.standard.value(forKey: "strLastName") as? String{
            self.strLastName = strLName
        }
        
        if let strGen = UserDefaults.standard.value(forKey: "strGender") as? String{
            self.strGender = strGen
        }
        
        if let strSelAge = UserDefaults.standard.value(forKey: "strSelectedAge") as? String{
            self.strYears = strSelAge
        }
        
        if let strMobileNum = UserDefaults.standard.value(forKey: "strPrimaryMobileNumber") as? String{
            self.strMobileNumber = strMobileNum
        }
        
        if let alterNum = UserDefaults.standard.value(forKey:"strAlternateMobilerNumber" ) as? String{
            self.strAlternateMobileNumber = alterNum
        }
        
//        print("Title: \(self.strTitle ?? "")")
//        print("FirstName: \(self.strFirstName)")
//        print("LastName: \(self.strLastName)")
//        print("Gender: \(self.strGender)")
//        print("Years: \(self.strYears)")
//        print("Mobile Number: \(self.strMobileNumber)")
//        print("AlterNative mobile number: \(self.strAlternateMobileNumber)")
        
        setAddressTypeRadioButtons()
        setResConfigTextField()
        setAdress1TextField()
        setAdressLine2TextField()
        setAdress1PincodeTextField()
        setAdress1LocalityTextField()
        setAdress1CityTextField()
        setAdress1StateTextField()
        setEmailTextField()
        addProductChooseField()
        addProductTokenField()
        setSubmitButton()
        serviceCallForProductList()
        
        let user = PlistManager.sharedInstance.getValueForKey("user") as? NSDictionary
        
        if user != nil {
            preFillAllFields(user!)
        }
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(updateProductSelection), name: NSNotification.Name(rawValue: "updateProductSelection"), object: nil)
        nc.addObserver(self, selector: #selector(addressSelected(_:)), name: NSNotification.Name(rawValue: "addressSelected"), object: nil)
        //  nc.addObserver(self, selector: #selector(clearAllTextFields), name: NSNotification.Name(rawValue: "clearAllTextFields"), object: nil)
        //         setprimaryNoCheckBoxButton()
        //         setAlternateNoCheckBoxButton()
        
    }
    
    @objc func updateProductSelection(_ notification:Notification)  {
        //if self.productTokenField != nil {
        self.view.endEditing(true)
        self.productTokenField.tokens = ProductBL.shareInstance.selectedProducts
        self.productTokenField.reloadTokeData()
        //}
    }
    
    func serviceCallForGetCityAndStateFromPincode(_ pinCodeNumber: String) {
        
        if NetworkChecker.isConnectedToNetwork() {
            
            let values: Dictionary<String, AnyObject> = [:]
            let googleMapURL = "http://maps.googleapis.com/maps/api/geocode/json?components=country:IN%7Cpostal_code:" + pinCodeNumber
            
            let mapMyIndiaURL = "https://apis.mapmyindia.com/advancedmaps/v1/7dij7ibnselacx3o1leyj9o37d7fp598/place_detail?place_id=" + pinCodeNumber
            DataManager.shareInstance.forceupdateAPI(mapMyIndiaURL, dataDictionary:values as NSDictionary) { (result, error) -> Void in
                
                if error == nil {
                    
                    DispatchQueue.main.async {
                        
                        if let responseDictionary: NSDictionary = result as? NSDictionary {
                            
                            let responseAddresses : NSArray = (responseDictionary.object(forKey: "results") as? NSArray)!
                            
                            if responseAddresses.count > 0 {
                                
                              //  let addresses = responseAddresses .value(forKey: "address_components") as? NSArray
                                let localAddress = responseAddresses.object(at: 0) as? NSDictionary
                                
                                let newCity = localAddress? .value(forKey: "city") as! String?
                                let newState = localAddress? .value(forKey: "state") as! String?
                                
                                
                                if (newCity?.characters.count)! > 0 {
                                    self.address1CityTextField.text = newCity
                                }
                                
                                if (newState?.characters.count)! > 0 {
                                    self.address1StateTextField.text = newState
                                }
                                
                                for (index,value) in states.enumerated() {
                                    
                                    if value == newState {
                                        print(index )
                                        self.selectedStateCode = statesCode[index]
                                    }
                                    //print("[PlistManager] Key Index - \(index) = \(element)")
//                                    if newState as! String == state {
//                                        //print("[PlistManager] Found the Item that we were looking for for key: [\(key)]")
//                                        value = dict[key]! as AnyObject?
//                                    } else {
//                                        //print("[PlistManager] This is Item with key '\(element)' and not the Item that we are looking for with key: \(key)")
//                                    }
                                }
                                
//                                var stringLocalAddressCity : String = ""
//                                var stringLocalAddressCityLocality : String = ""
//                                var stringLocalAddressCountry : String = ""
                                
                                
//                                for address in localAddress! {
//
//                                    let address1: NSDictionary = (address as? NSDictionary)!
//                                    let localAddressTypes = address1 .value(forKey: "types") as? NSArray
//
//                                    let stringState = localAddressTypes?.object(at: 0) as! String
//
//                                    if stringState == "country" {
//
//                                        stringLocalAddressCountry = (address1 .value(forKey: "long_name") as! String?)!
//                                    }
//
//                                    if stringState == "administrative_area_level_2" {
//
//                                        stringLocalAddressCity = (address1 .value(forKey: "long_name") as! String?)!
//                                    }
//
//                                    if stringState == "locality" {
//
//                                        stringLocalAddressCityLocality = (address1 .value(forKey: "long_name") as! String?)!
//                                    }
//
//                                    if stringState == "administrative_area_level_1" {
//
//                                        self.address1StateTextField.text = address1 .value(forKey: "long_name") as! String?
//                                    }
//                                }
                                
//                                if stringLocalAddressCountry == "India" {
//
//                                    if stringLocalAddressCity.characters.count > 0 {
//
//                                        if stringLocalAddressCityLocality.characters.count > 0 {
//
//                                            self.address1CityTextField.text = stringLocalAddressCityLocality
//                                        }
//                                        else {
//
//                                            self.address1CityTextField.text = stringLocalAddressCity
//                                        }
//                                    }
//                                    else {
//
//                                        self.address1CityTextField.text = ""
//                                    }
//                                }
//                                else {
//
//                                    self.address1CityTextField.text = ""
//                                    self.address1StateTextField.text = ""
//                                }
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
    
    // MARK: - UITextField Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(textField == address1PincodeTextField) {
            let maxLength = 6
         //   iBaseCodeTextFieldView.iBaseTextField.text = ""
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            
            if newLength==maxLength {
                
                let stringPinCode = address1PincodeTextField.text! + string as String
                serviceCallForGetCityAndStateFromPincode(stringPinCode)
            }
            
            return newLength <= maxLength
        }else if(textField == address1CityTextField || textField == address1StateTextField || textField == address1LocalityTextField){
//                iBaseCodeTextFieldView.iBaseTextField.text = ""
        }else if(textField == iBaseCodeTextFieldView.iBaseTextField){
            
            address1StateTextField.text = ""
            address1CityTextField.text = ""
            address1PincodeTextField.text = ""
            //addressTextView.text = ""
            address1TextField.textView.text = ""
            address1LocalityTextField.text = ""
            
            
            // set placeholder in address textview
            let placeholder: String = "Address Line 1 *"
            let loc: Int = placeholder.characters.count
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: placeholder as String, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(netHex:0x000000)]))
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location:loc-1,length:1))
            myMutableString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: fontQuicksandBookBoldRegular, size: 16)!, range: NSRange(location:0,length:placeholder.characters.count))
            //   textFieldView.textView.attributedPlaceholder = myMutableString
            address1TextField.textView.attributedText = myMutableString
            address1TextField.textView.keyboardType = .default
            
        }
        
        /*
         if(textField == alternateMobileNoTextField.textField) {
         let maxLength = 10
         guard let text = textField.text else { return true }
         let newLength = text.characters.count + string.characters.count - range.length
         return newLength <= maxLength
         }
         */
        
        return true
    }
    
    // MARK:- Address selected event
    @objc func addressSelected(_ notification: NSNotification) {
        if let addr = notification.userInfo! as NSDictionary? {
            print(addr)
            
            if let index = statesCode.index(of: (addr.value(forKey: "state") as! String)) {
                    self.address1StateTextField.text = states[index]
            }
          //  customerIDView.btnCustomerID.setTitle(addr["customerId"] as? String, for: .normal)
            
            var addressConf = ""
            if let addrr = addr.value(forKey: "subTypeCode"){
                addressConf = addrr as! String
            }
            
            if addressConf == "Commercial" {
                if(companyNameTextField != nil){
                    companyNameTextField.removeFromSuperview()
                }
                if (resConfigTextField != nil) {
                    resConfigTextField.removeFromSuperview()
                }
                setCompanyNameTextField()
                addressTypeView.btnCommercial.isSelected = true
                addressTypeView.btnResidential.isSelected = false
                companyNameTextField.text = addr.value(forKey: "companyName") as! String
            }else {
                if (resConfigTextField != nil) {
                    resConfigTextField.removeFromSuperview()
                }
                
                if(companyNameTextField != nil){
                    companyNameTextField.removeFromSuperview()
                }
                setResConfigTextField()
                addressTypeView.btnCommercial.isSelected = false
                addressTypeView.btnResidential.isSelected = true
                resConfigTextField.isUserInteractionEnabled = true
                if let ress = addr.value(forKey: "residentialConfiguration"){
                    if(resConfigs.contains(ress as! String)){
                        selectedResConfig = ress as? String
                        resConfigTextField.isUserInteractionEnabled = false
                    }
                    
                }
                resConfigTextField.text = selectedResConfig
            }
            
            self.address1TextField.textView.font = UIFont(name: fontQuicksandBookRegular, size: 16)!
            self.address1TextField.textView.textColor = UIColor.black
          
            self.addressLine2.textView.font = UIFont(name: fontQuicksandBookRegular, size: 16)!
            self.addressLine2.textView.textColor = UIColor.black

            self.address1TextField.textView.text = addr.value(forKey: "address1") as! String
            
            if let local = (addr.value(forKey: "address2") as? String){
                self.addressLine2.textView.text = local
            }else{
                self.addressLine2.textView.text = ""
            }
            
            self.address1CityTextField.text = (addr.value(forKey: "city") as! String)

//            self.address1LocalityTextField.text = (addr.value(forKey: "locality") as! String)
            if let local = (addr.value(forKey: "locality") as? String){
                self.address1LocalityTextField.text = local
            }else{
                self.address1LocalityTextField.text = ""
            }
            
            if (self.address1LocalityTextField.text == "") {
                address1LocalityTextField.attributedPlaceholder = NSAttributedString(string: "d",
                                                                                     attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor):  UIColor(netHex:0x666666)]))
            }
            self.address1PincodeTextField.text = (addr.value(forKey: "pinCode") as! String)
//            self.address1StateTextField.text = (addr.value(forKey: "state") as! String)
            disableTextFieldToEnterAddress()
            
            self.iBaseCodeTextFieldView.iBaseTextField.text = addr["customerId"] as! String
//            isAddressAutoFilled = true
            
        }
    }
    
    func disableTextFieldToEnterAddress() {
        if isCompanyNameDisplayed {
            companyNameTextField.isUserInteractionEnabled = false
        }
        address1TextField.textView.isUserInteractionEnabled = false
        addressLine2.textView.isUserInteractionEnabled = false
        address1PincodeTextField.isEnabled = false
        address1LocalityTextField.isEnabled = false
        address1CityTextField.isEnabled = false
        address1StateTextField.isEnabled = false
        addressTypeView.btnCommercial.isUserInteractionEnabled = false
        addressTypeView.btnResidential.isUserInteractionEnabled = false
//        resConfigTextField.isUserInteractionEnabled = false
        address1TextField.textView.textColor = UIColor(netHex:0x666666)
        addressLine2.textView.textColor = UIColor(netHex:0x666666)
        address1PincodeTextField.textColor = UIColor(netHex:0x666666)
        address1LocalityTextField.textColor = UIColor(netHex:0x666666)
        address1CityTextField.textColor = UIColor(netHex:0x666666)
        address1StateTextField.textColor = UIColor(netHex:0x666666)
       
    }
    
    func setSubmitButton() {
        
//        buttonSubmit = UIButton(frame: CGRect(x: 10, y: 70+productTokenField.frame.origin.y, width: UIScreen.main.bounds.size.width-20, height: 50))
        buttonSubmit = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width/4 , y: productTokenField.frame.origin.y + productTokenField.frame.size.height + 10, width: 200, height: 50))
        
        //        let button = UIButton(frame: CGRect(x: 10, y: 70+70*11, width: UIScreen.mainScreen().bounds.size.width-20, height: 50))
        buttonSubmit.setTitle("Submit", for: UIControl.State())
//        buttonSubmit.setPreferences()
        buttonSubmit.layer.cornerRadius = 5.0
        buttonSubmit.backgroundColor = UIColor(netHex:0x0672EB)
        buttonSubmit.addTarget(self, action: #selector(submitButtonAction), for: .touchUpInside)
        scrollView.addSubview(buttonSubmit)
        scrollView.bringSubviewToFront(buttonSubmit)
    }
    
    func validateFields() -> Bool {
        //var pin: String! = ""

        let pinCode = (address1PincodeTextField.text?.trim())!
            
        if(address1TextField.textView.text?.trim() == "") {
            DataManager.shareInstance.showAlert(self, title: invalidAddressTitle, message: invalidAddressMessage)
            return false
        } else if(address1TextField.textView.text == "Address Line 1 *"){
            DataManager.shareInstance.showAlert(self, title: invalidAddressTitle, message: invalidAddressMessage)
            return false
        }
        else if (address1TextField.textView.text?.trim().count)! < 10 {
            DataManager.shareInstance.showAlert(self, title: invalidAddressTitleMinChar, message: invalidAddressMessage)
            return false
        }
       
        else if pinCode == "" {
            DataManager.shareInstance.showAlert(self, title: invalidPincodeTitle, message: invalidPincodeMessage)
            return false
        } else if pinCode.count != 6 {
            DataManager.shareInstance.showAlert(self, title: invalidPincodeTitle, message: invalidPincodeMessage)
            return false
        } else if !pinCode.isNumeric {
            DataManager.shareInstance.showAlert(self, title: invalidPincodeTitle, message: invalidPincodeMessage)
            return false

        }  else if address1CityTextField.text?.trim() == "" {
            DataManager.shareInstance.showAlert(self, title: invalidCityTitle, message: invalidCityMessage)
            return false
        }else if address1StateTextField.text?.trim() == "" {
            DataManager.shareInstance.showAlert(self, title: invalidStateTitle, message: invalidStateMessage)
            return false
        } else if(emailTextField.textField.text?.trim() == "") {
            DataManager.shareInstance.showAlert(self, title: invalidEmailTitle, message: invalidEmailMessage)
            return false
        } else if !isValidEmail(emailTextField.textField.text!.trim()) {
            DataManager.shareInstance.showAlert(self, title: invalidEmailTitle, message: invalidEmailMessage)
            return false
        } else if(ProductBL.shareInstance.selectedProducts.count==0){
            DataManager.shareInstance.showAlert(self, title: "Product", message:"Please select at least one product from the dropdown list.")
            return false
        } else if isCompanyNameDisplayed {
            if (companyNameTextField.text?.trim() == "") {
                DataManager.shareInstance.showAlert(self, title: invalidCompanyNameTitle, message: invalidCompanyNameMessage)
                return false
            }
        }else if !isCompanyNameDisplayed {
            if (resConfigTextField.text?.trim() == "") {
                DataManager.shareInstance.showAlert(self, title: invalidResidentialConfigurationTitle, message: invalidResidentialMessage)
                return false
            }
        }
            /*
             else if(questionTextField.textField.text?.trim() != "" && questionTextField.textField.text?.trim() != "Security Question" && answerTextField.textField.text?.trim() == "") {
             DataManager.shareInstance.showAlert(self, title: invalidAnswerTitle, message: invalidAnswerMessage)
             return false
             }
             */
            /*
             else if(pinTextField.textField.text?.trim() != "") {
             pin = (pinTextField.textField.text?.trim())!
             if(pin.characters.count < 4 || !pin.isNumeric) {
             DataManager.shareInstance.showAlert(self, title: invalidPinTitle, message: invalidPinMessage)
             return false
             } else if(pin.characters.count == 4 && (questionTextField.textField.text?.trim() == "" || questionTextField.textField.text?.trim() == "Security Question")) {
             DataManager.shareInstance.showAlert(self, title: invalidQuestionTitle, message: invalidQuestionMessage)
             return false
             }
             }
             */
        
        return true
    }
    
    func isValidEmail(_ emailId:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailId)
    }
    
    // MARK: - Submit button action
    @objc func submitButtonAction(_ sender: AnyObject) {
        self.view.endEditing(true)
        
        
//        let controller:RegisterAddressViewController = self.storyboard!.instantiateViewController(withIdentifier: "RegisterAddressView") as! RegisterAddressViewController
//        controller.addresses = (PlistManager.sharedInstance.getValueForKey("user") as? NSDictionary)?.value(forKey: "addresses") as! NSArray
//        // setup delegate for new address selection
//        controller.addressProtocol1 = self
//            //UserAddressesDatabaseModel.shareInstance.getUserAddrress(PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String)
//        controller.isComingFromDashbord = false
//        controller.view.frame = self.view.bounds
//        controller.view.backgroundColor = UIColor(white: 0.1, alpha: 0.65)
//        controller.willMove(toParent: self)
//        self.view.addSubview(controller.view)
//        self.addChild(controller)
//        controller.didMove(toParent: self)
        
        
//        if NetworkChecker.isConnectedToNetwork() {
//        
//            let customerID = self.iBaseCodeTextFieldView.iBaseTextField.text
////            if (customerID == nil || !customerID!.trim().isNumber() ){
////                DataManager.shareInstance.showAlert(self, title: invalidAddressTitle, message: invalidAddressSelection)
////                return
////            }
//            if validateFields() {
//                
//                showPlaceHolderView()
//                
//                var userType: String
//                var company: String
//                if addressTypeView.btnResidential.isSelected {
//                    userType = "Residential"
//                } else {
//                    userType = "Commercial"
//                }
//                
//                let userData = PlistManager.sharedInstance.getValueForKey("user") as? NSDictionary
//                var values: Dictionary<String, AnyObject> = [:]
//                var user: Dictionary<String, Any> = [:]
//                user["title"] = strTitle.getTitleCode()
//                user["firstName"] = (strFirstName.trim()) as AnyObject?
//                user["lastName"] = (strLastName.trim()) as AnyObject?
////                user["mobileNumber"] = (primaryMobileNoTextField .textField.text?.trim())! as AnyObject?
//                user["alternatemobilenumber"] = (strAlternateMobileNumber.trim()) as AnyObject?
//                
//                user["gender"] = strGender
//                user["age"] = strYears
////                user["residentialConfiguration"] = selectedResConfig
//                if isCompanyNameDisplayed {
//                    company = (companyNameTextField.text?.trim())!
//                } else {
//                    company = ""
//                }
//                if(self.isChecked == true)
//                {
//                  //  user["preferedCallingNumber"] = (alternateMobileNoTextField.textField.text?.trim())! as AnyObject?
//                }
//                else
//                {
//                  //  user["preferedCallingNumber"] = (primaryMobileNoTextField.textField.text?.trim())! as AnyObject?
//                }
//                //user["alternatemobilenumber"] = (alternateMobileNoTextField.textField.text?.trim())! as AnyObject?
//                
//                if userData != nil {
//                    
////                    if(customerIDView.btnCustomerID.title(for: .normal) as! String != "Customer ID"){
//                    if ((iBaseCodeTextFieldView.iBaseTextField.text?.trim().count)! > 0) {
//                        var selectedAdd:NSMutableDictionary = [:]
//                        var allAdds = userData?.value(forKey: "addresses") as! NSMutableArray
//                        for i in 0..<allAdds.count {
//                            let aaa = allAdds[i] as! NSMutableDictionary
//                            if(aaa["customerId"] as? String == iBaseCodeTextFieldView.iBaseTextField.text){
//                                selectedAdd = allAdds[i] as! NSMutableDictionary
//                                break
//                            }
//                        }
////                        selectedAdd.setValue(selectedResConfig, forKey: "residentialConfiguration")
////                        for address in (userData!["addresses"] as? [[String:String]])! {
////                            if(address["customerId"] == iBaseCodeTextFieldView.iBaseTextField.text){
////                                selectedAdd = address as                                 break
////                            }
////                        }
//                        if(selectedAdd["subTypeCode"] as! String == "Residential"){
//                            if let ress = selectedAdd["residentialConfiguration"] as? String{
//                                if (ress.count <= 0){
//                                    selectedAdd.setValue(selectedResConfig, forKey: "residentialConfiguration")
//                                    var arr : NSMutableArray = []
//                                    arr.add(selectedAdd)
//                                    user["addresses"] = arr
//                                }else if(resConfigs.contains(ress)){
//                                     user["addresses"] = [] as NSArray
//                                }else{
//                                    selectedAdd.setValue(selectedResConfig, forKey: "residentialConfiguration")
//                                    var arr : NSMutableArray = []
//                                    arr.add(selectedAdd)
//                                    user["addresses"] = arr
//                                }
//                            }else{
//                                selectedAdd.setValue(selectedResConfig, forKey: "residentialConfiguration")
//                                var arr : NSMutableArray = []
//                                arr.add(selectedAdd)
//                                user["addresses"] = arr
//                            }
//                            
//                        }else{
//                             user["addresses"] = [] as NSArray
//                        }
////                        user["addresses"] = [] as NSArray
//                        
//                    }else{
//                        //let addresses = userData!["addresses"] as! NSMutableArray selectedStateCode as AnyObject?
//                        var addressLine2Text : String
//                        if addressLine2.textView.text?.trim() == "Address Line 2" {
//                            addressLine2Text = ""
//                        } else {
//                            addressLine2Text = (addressLine2.textView.text?.trim())!
//                        }
//                        
//                        let newPrimaryAddress = [["address1":(address1TextField.textView.text?.trim())!,
//                                                 "address2" : addressLine2Text,
//                                                 "locality":(address1LocalityTextField.text?.trim())!,
//                                                 "city":(address1CityTextField.text?.trim())!,
//                                                 "state":selectedStateCode,
//                                                 "pinCode":(address1PincodeTextField.text?.trim())!,
//                                                 "companyName":company,
//                                                 "residentialConfiguration": selectedResConfig,
//                                                 "subTypeCode":userType]]
//                        //addresses.add(newPrimaryAddress)
//                         user["addresses"] = newPrimaryAddress
//
//                    }
//                }
//
//                
//                user["email"] = (emailTextField.textField.text?.trim())! as AnyObject?
//
//                values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
//                
//                var productIds : String = ""
//                if (ProductBL.shareInstance.selectedProducts.count>0) {
//                    
//                    for  product in ProductBL.shareInstance.selectedProducts {
//                        let selectedProduct = product as! ProductData
//                        productIds = productIds + selectedProduct.productId! + ","
//                    }
//                    if productIds.characters.count>1 {
//                        productIds = String(productIds.characters.dropLast())
//                    }
//                    print(productIds)
//                }
//                if productIds.characters.count>0 {
//                    user["registeredProductsIds"] = productIds as AnyObject? // ZYZZ 28/10
////                    user["registeredProductsIds"] = "F5800"
//                }
//                values["user"] = user as AnyObject?
//                values["platform"] = platform as AnyObject?
//                values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
//                
//                print(values)
//
//                
//                DataManager.shareInstance.getDataFromWebService(registerUserURLMize, dataDictionary:values as NSDictionary) { (result, error) -> Void in
//                    if error == nil {
//                        DispatchQueue.main.async {
//                            self.hidePlaceHolderView()
//                            RegisterUserModel.shareInstance.parseResponseObject(result)
//                            let status = RegisterUserModel.shareInstance.status!
//                            if status == "error" {
//                                let message = RegisterUserModel.shareInstance.errorMessage!
//                                DataManager.shareInstance.showAlert(self, title: messageTitle, message: message)
//                            } else {
//                                
//                                var addresses = (PlistManager.sharedInstance.getValueForKey("user") as? NSDictionary)?.value(forKey: "addresses")as! NSMutableArray
//                                let allCustIdsArray = addresses.value(forKey: "customerId") as! NSArray
//                                print(allCustIdsArray)
//                                // Subscribe to topics for in-app and cloud messaging
//                                Messaging.messaging().subscribe(toTopic: PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String) { error in
//                                    print("Subscribed to mobile number topic")
//                                }
//                                Messaging.messaging().subscribe(toTopic: self.strGender) { error in
//                                    print("Subscribed to Gender topic")
//                                }
//                                Messaging.messaging().subscribe(toTopic: String(self.strYears.prefix(2))) { error in
//                                    print("Subscribed to Age Group topic",String(self.strYears.prefix(2)))
//                                }
//                                
//                                for individualCustomerId in allCustIdsArray{
//                                    Messaging.messaging().subscribe(toTopic: individualCustomerId as! String) { error in
//                                        print("Subscribed to Customer Id topic",individualCustomerId)
//                                    }
//                                }
//                                
////                                  if(self.customerIDView.btnCustomerID.title(for: .normal)! == "Customer ID"){
//                                
//                                if ((self.iBaseCodeTextFieldView.iBaseTextField.text?.trim().count)! == 0) {
//                                    let address = user ["addresses"] as! NSArray
//                                    if(address.count>0){
////                                        let add: NSMutableDictionary = address.object(at: 0) as! NSMutableDictionary
//                                        // address.object(at: 0) as! Dictionary<String, AnyObject>
//                                       
////                                        let add = address.object(at: 0) as! Dictionary<String, AnyObject>
//                                        
//                                        
//                                        let add = NSMutableDictionary(dictionary: address.object(at: 0) as! Dictionary<String, AnyObject>)
//                                        
//
//
//                                        add.setValue(result?.value(forKey: "customerId"), forKey: "customerId")
//                                        addresses.add(add)
//                                    }
//                                    UserAddressesDatabaseModel.shareInstance.addUserAddress(PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String, addresses, active: result?.value(forKey: "customerId") as! String)
//                                  }else{
//                                    var allAddress = NSMutableArray()
//                                    for id in addresses {
//                                        if let aaa = id as? [String: Any], let customerId = aaa["customerId"] as? String {
//                                            if(customerId == self.iBaseCodeTextFieldView.iBaseTextField.text){
//                                                var address = aaa
//                                                address["residentialConfiguration"] = self.selectedResConfig
//                                                allAddress.add(address)
//                                            }else{
//                                                allAddress.add(aaa)
//                                            }
//                                        }
//                                    }
//                                    addresses = allAddress
//                                    UserAddressesDatabaseModel.shareInstance.addUserAddress(PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String, allAddress, active: self.iBaseCodeTextFieldView.iBaseTextField.text!)
//                                }
//                                user["addresses"] = addresses.mutableCopy() as! NSArray
//                                PlistManager.sharedInstance.saveValue(user as AnyObject, forKey: "user")
//                            UserDetailsDatabaseModel.shareInstance.addUserDetails(PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String? ?? "", user as Dictionary<String, AnyObject>)
//                                
//                                PlistManager.sharedInstance.saveValue(true as AnyObject, forKey: "registered")
//                                self.getEquipmentList()
//                                let controller:RegisteredPopUpViewController = self.storyboard!.instantiateViewController(withIdentifier: "RegisteredPopUpView") as! RegisteredPopUpViewController
//                                controller.view.frame = self.view.bounds;
//                                controller.view.backgroundColor = UIColor(white: 0.1, alpha: 0.65)
//                                controller.willMove(toParent: self)
//                                self.view.addSubview(controller.view)
//                                self.addChild(controller)
//                                controller.didMove(toParent: self)
//                            }
//                        }
//                    } else {
//                        DispatchQueue.main.async {
//                            self.hidePlaceHolderView()
//                            if error?.code != -999 {
//                                DataManager.shareInstance.showAlert(self, title: (error?.domain)!, message: (error?.localizedDescription)!)
//                            }
//                        }
//                    }
//                }
//                
//            }
//        } else {
//            DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
//        }
    }
    
    // MARK: - Equipment List
    func getEquipmentList(){
        let fileURL = DBManager.shareInstance.getPath()
        let db1 = FMDatabase(path: fileURL)
        var equipmentList : NSArray! = []
        //var equipmentList : NSArray! = []
        if NetworkChecker.isConnectedToNetwork() {
            // self.showPlaceHolderView()
            var values: Dictionary<String, AnyObject> = [:]
            values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
            values["platform"] = platform as AnyObject?
            values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
            let ccIDs = UserAddressesDatabaseModel.shareInstance.getCustomerIDs(values["mobileNumber"]! as! String)
            print(ccIDs)
            values["customerIds"] = ccIDs as String as AnyObject
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

                                //
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
                                }
                            }
                        }
                    }
                    //             }
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
    
    // MARK: - API call
    func serviceCallForProductList() {
        
        if NetworkChecker.isConnectedToNetwork() {
            var values: Dictionary<String, AnyObject> = [:]
            values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
            values["platform"] = platform as AnyObject?
            values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey") // ZYZZ 28/10
//            values["authKey"] = "MnCGBhQOdGHAKkmqPYeC" as AnyObject?
            self.showPlaceHolderView()
            
            DataManager.shareInstance.getDataFromWebService(productListURLMize, dataDictionary:values as NSDictionary) { (result, error) -> Void in
                if error == nil {
                    DispatchQueue.main.async {
                        self.hidePlaceHolderView()
                        
                        if let responseDictionary: NSDictionary = result as? NSDictionary {
                            
                            if let responseStatus : String = (responseDictionary.object(forKey: KEY_Status) as? String) {
                                
                                if responseStatus == "success"{
                                    ProductBL.shareInstance.products.removeAllObjects()
                                    ProductBL.shareInstance.selectedProducts.removeAllObjects()
                                    let user = PlistManager.sharedInstance.getValueForKey("user") as? NSDictionary
                                    if let _ = user?.value(forKey: "registeredProductsIds") {
                                        ProductBL.shareInstance.parseProductDataWithUserAlreadySelectedProducts(result)
                                    }else{
                                            ProductBL.shareInstance.parseResponseObject(result)
                                    }
                                    
                                    let userr = PlistManager.sharedInstance.getValueForKey("user") as? NSDictionary
                                    if user != nil {
                                        self.preFillAllFields(userr!)
                                    }
                                }
                                else{
                                    if let responseError : String = (responseDictionary.object(forKey: "errorMessage") as? String)
                                    {
                                        DataManager.shareInstance.showAlert(self, title: errorTitle, message: responseError)
                                    }
                                }
                            }
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
            DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
        }
        
    }
    
    func preFillAllFields(_ user: NSDictionary) {
        emailTextField.textField.textColor = UIColor(netHex:0x000000)

        //        alternateMobileNoTextField.textField.text = user["alternatemobilenumber"] as? String
        let addresses = user["addresses"] as! NSArray
        for (_, value) in addresses.enumerated() {
            let address = value as! Dictionary<String, AnyObject>
        }
        emailTextField.textField.text = user["email"] as? String
        if let _ = user["prefferedTimingFrom"] {
            let startTime = user["prefferedTimingFrom"] as! String
             if startTime.trim() != "" {
                dateFormatter.dateFormat = "HH:mm:ss"
                let startDate = dateFormatter.date(from: startTime)
                dateFormatter.dateFormat = "HH:mm"
                let newStartTime = dateFormatter.string(from: startDate!)
                preferredTimeTextField.textFieldOne.text = newStartTime
            }
        }
        if let _ = user["prefferedTimingTo"] {
            let endTime = user["prefferedTimingTo"] as! String
             if endTime.trim() != "" {
                dateFormatter.dateFormat = "HH:mm:ss"
                let endDate = dateFormatter.date(from: endTime)
                dateFormatter.dateFormat = "HH:mm"
                let newEndTime = dateFormatter.string(from: endDate!)
                preferredTimeTextField.textFieldTwo.text = newEndTime
            }
        }
        
        if let _ = user.value(forKey: "registeredProductsIds") {
            let strProductIds = user.value(forKey: "registeredProductsIds") as! String
            let arrProductIds = strProductIds.components(separatedBy: ",")
            let mutableArray: NSMutableArray = NSMutableArray ()
            
            let arrAllProducts = ProductBL.shareInstance.products
            for value in arrAllProducts{
                let product = value as! ProductData
                if(arrProductIds.contains(product.productId!)){
                    mutableArray.add(product)
                }
            }
                        ProductBL.shareInstance.selectedProducts = mutableArray
            self.productTokenField.tokens = mutableArray
            self.productTokenField.reloadTokeData()
        }
        
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
    
    func setAlternateNoCheckBoxButton(){
        alternateNoCheckBoxButton=UIButton(frame: CGRect(x: contentView.bounds.size.width-50, y: 30+70*5, width: 50, height: 50))
        let uncheckedImage = UIImage(named: "uncheck_box")! as UIImage
        //let uncheckedImage = UIImage(named: "uncheck_box")! as UIImage
        // primaryNoCheckBoxButton.setPreferences()
        alternateNoCheckBoxButton.setImage(uncheckedImage, for: .normal)
         alternateNoCheckBoxButton.addTarget(self, action: #selector(checkAlternateImage), for: .touchUpInside)
        alternateNoCheckBoxButton.isEnabled = false
        scrollView.addSubview(alternateNoCheckBoxButton)
        scrollView.bringSubviewToFront(alternateNoCheckBoxButton)
    }
    
    @objc func checkAlternateImage(_ sender: AnyObject) {
        let checkedImage = UIImage(named: "check_box")! as UIImage
        let uncheckedImage = UIImage(named: "uncheck_box")! as UIImage
        
        // Post a notification
        
        isChecked = true
        primaryNoCheckBoxButton.setImage(uncheckedImage, for: .normal)
        alternateNoCheckBoxButton.setImage(checkedImage, for: .normal)

    }
    
    func setprimaryNoCheckBoxButton(){
        primaryNoCheckBoxButton=UIButton(frame: CGRect(x: contentView.bounds.size.width-50, y: 30+70*4, width: 50, height: 50))
        let checkedImage = UIImage(named: "check_box")! as UIImage
        //let uncheckedImage = UIImage(named: "uncheck_box")! as UIImage
        // primaryNoCheckBoxButton.setPreferences()
        primaryNoCheckBoxButton.setImage(checkedImage, for: .normal)
        primaryNoCheckBoxButton.addTarget(self, action: #selector(checkPrimaryImage), for: .touchUpInside)
        primaryNoCheckBoxButton.isEnabled = false
        scrollView.addSubview(primaryNoCheckBoxButton)
        scrollView.bringSubviewToFront(primaryNoCheckBoxButton)
    }
    
    @objc func checkPrimaryImage(_ sender: AnyObject) {
        let checkedImage = UIImage(named: "check_box")! as UIImage
        let uncheckedImage = UIImage(named: "uncheck_box")! as UIImage
        isChecked=false
        // Post a notification
        
        primaryNoCheckBoxButton.setImage(checkedImage, for: .normal)
        alternateNoCheckBoxButton.setImage(uncheckedImage, for: .normal)

    }
    
    func addProductTokenField() {
        
        productTokenField = Bundle.main.loadNibNamed("ProductTokenView", owner: self, options: nil)?[0] as! ProductTokenView
        productTokenField.delegate = self
        productTokenField.backgroundColor = .blue
        productTokenField.frame = CGRect(x: 10, y: chooseProductTextField.frame.origin.y + chooseProductTextField.frame.size.height + 10 , width: contentView.frame.size.width-20,height: tokenViewheight);
        scrollView.addSubview(productTokenField)
        
    }
    
    func tokenViewTotalHeight(_ tokenViewSize: CGSize) {
        tokenViewheight = tokenViewSize.height+16
        productTokenField.frame = CGRect(x: 10, y: chooseProductTextField.frame.origin.y + chooseProductTextField.frame.size.height + 10, width: contentView.frame.size.width-20,height: tokenViewheight)
        setContentSize()
    }
    
    func setContentSize() {

        productTokenField.frame = CGRect(x: 10, y: chooseProductTextField.frame.origin.y + chooseProductTextField.frame.size.height + 10, width: contentView.frame.size.width-20,height: tokenViewheight);
        if ProductBL.shareInstance.selectedProducts.count == 0 {
            buttonSubmit.frame = CGRect(x: 10,y: productTokenField.frame.origin.y+tokenViewheight-10,width: UIScreen.main.bounds.size.width-20,height: 50)
        } else {
            buttonSubmit.frame = CGRect(x: 10,y: productTokenField.frame.origin.y+tokenViewheight+14,width: UIScreen.main.bounds.size.width-20,height: 50)
        }
        scrollView.contentSize = CGSize(width: scrollView.bounds.size.width, height: 50+buttonSubmit.frame.origin.y+20)
    }
    
    func addProductChooseField(){
        
        chooseProductTextField = createDropDowndWithInfo(&chooseProductTextField, placeholder: "Select Products", leftImage: IMG_ProductList, isRightImage: true, rightImage: IMG_DownArrow, yAxis: emailTextField.frame.origin.y + emailTextField.frame.size.height + 10)
        
        chooseProductTextField.buttoDropDown.addTarget(self, action: #selector(openProductList), for:.touchUpInside)
        
        let arrowTap = UITapGestureRecognizer(target: self, action: #selector(openProductList))
        chooseProductTextField.rightFirstImageView.isUserInteractionEnabled = true
        chooseProductTextField.rightFirstImageView.addGestureRecognizer(arrowTap)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showProductChooseInfo))
        chooseProductTextField.rightSecondImageView.isUserInteractionEnabled = true
        chooseProductTextField.rightSecondImageView.addGestureRecognizer(tap)
        
        chooseProductTextField.addGestureRecognizer(arrowTap)
        scrollView.addSubview(chooseProductTextField)
        
    }
    
    @objc func showProductChooseInfo() {
        DataManager.shareInstance.showAlert(self, title:"Product", message:"Select your products.")
    }
    
    @objc func openProductList() {
        //open product List
        let vc : ProductListPickerVC =  ProductListPickerVC(nibName: "ProductListPickerVC", bundle: nil)
        vc.isFromRegistration = true
        self.present(vc, animated: true, completion: nil)
    }
    
    func createDropDowndWithInfo(_ textFieldView: inout DropDownView, placeholder: String, leftImage: String, isRightImage: Bool, rightImage: String, yAxis: CGFloat) -> DropDownView {
        
        textFieldView = Bundle.main.loadNibNamed("DropDownView", owner: self, options: nil)?[0] as! DropDownView
        textFieldView.frame = CGRect(x: 10, y: yAxis, width: contentView.bounds.size.width-20,height: 50)
        textFieldView.leftImageView.image = UIImage(named: leftImage)
        textFieldView.buttonView.layer.borderColor = UIColor(netHex:0xDEDFE0).cgColor
        textFieldView.label.backgroundColor = UIColor(netHex:0xDEDFE0)
        textFieldView.buttonView.layer.cornerRadius = 3.0
        textFieldView.buttonView.layer.borderWidth = 1.0
        if isRightImage {
            textFieldView.rightFirstImageView.image = UIImage(named: rightImage)
        }
        textFieldView.rightSecondImageView.image = UIImage(named: IMG_Info)
        textFieldView.buttoDropDown.titleLabel?.textColor = UIColor(netHex:0x000000)
        //textFieldView.textField.textColor = UIColor(netHex:0x000000)
        textFieldView.buttoDropDown.titleLabel!.font = UIFont(name: fontQuicksandBookRegular, size: 16)
        textFieldView.buttoDropDown.setTitleColor(UIColor(netHex:0x000000), for: UIControl.State())
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: placeholder as String, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(netHex:0x000000)]))
        myMutableString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: fontQuicksandBookRegular, size: 16)!, range: NSRange(location:0,length:placeholder.characters.count))
        textFieldView.buttoDropDown.setAttributedTitle(myMutableString, for: UIControl.State())
        return textFieldView
    }
    
    func setEmailTextField(){
        emailTextField = setTextField(&emailTextField, placeholder: "Email *", leftImage: IMG_Email, yAxis: self.address1CityTextField.frame.origin.y + self.address1CityTextField.frame.size.height + 10)
        scrollView.addSubview(emailTextField)
        emailTextField.textField.delegate = self
        emailTextField.textField.keyboardType = .emailAddress
    }
    
    func setTextField(_ textFieldView: inout TextFieldView, placeholder: String, leftImage: String, yAxis: CGFloat) -> TextFieldView {
        
        textFieldView = Bundle.main.loadNibNamed("TextFieldView", owner: self, options: nil)?[0] as! TextFieldView
        textFieldView.frame = CGRect(x: 10, y: yAxis, width: contentView.bounds.size.width-20,height: 50)
        textFieldView.leftImageView.image = UIImage(named: leftImage)
        
        let imgColor = UIColor(netHex: 0x246cb0)
//        textFieldView.leftImageView.setImageColor(color: .blue)
        
        textFieldView.textFieldView.layer.borderColor = UIColor(netHex:0xDEDFE0).cgColor
        textFieldView.label.backgroundColor = UIColor(netHex:0xDEDFE0)
        textFieldView.textFieldView.layer.cornerRadius = 3.0
        textFieldView.textFieldView.layer.borderWidth = 1.0
        textFieldView.rightFirstImageView.isHidden = true
        textFieldView.textField.textColor = UIColor(netHex:0x666666)
        textFieldView.textField.font = UIFont(name: fontQuicksandBookRegular, size: 16)
        if placeholder == "First Name *" || placeholder == "Last Name *" || placeholder == "Select Title *" {
            let loc: Int = placeholder.characters.count
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: placeholder as String, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(netHex:0x666666)]))
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location:loc-1,length:1))
            myMutableString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: fontQuicksandBookBoldRegular, size: 16)!, range: NSRange(location:0,length:placeholder.characters.count))
            textFieldView.textField.attributedPlaceholder = myMutableString
            textFieldView.textField.autocapitalizationType = .words
        } else if placeholder == "Email *" {
            let loc: Int = placeholder.characters.count
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: placeholder as String, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(netHex:0x666666)]))
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location:loc-1,length:1))
            myMutableString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: fontQuicksandBookRegular, size: 16)!, range: NSRange(location:0,length:placeholder.characters.count))
            textFieldView.textField.attributedPlaceholder = myMutableString
//            textFieldView.textField.autocapitalizationType = .words
        } else {
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: placeholder as String, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(netHex:0x666666)]))
            myMutableString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: fontQuicksandBookBoldRegular, size: 16)!, range: NSRange(location:0,length:placeholder.characters.count))
            textFieldView.textField.attributedPlaceholder = myMutableString
        }
        let paddingForFirst = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textFieldView.textField.frame.size.height))
        textFieldView.textField.leftView = paddingForFirst
        textFieldView.textField.leftViewMode = UITextField.ViewMode .always
        textFieldView.textField.isUserInteractionEnabled = true
        //        if textFieldView == alternateMobileNoTextField {
        //            textFieldView.textField.keyboardType = .NumberPad
        //        } else {
        textFieldView.textField.keyboardType = .default
        //        }
        textFieldView.backgroundColor = UIColor.white
        return textFieldView
    }
    
    func setAdress1StateTextField(){
        address1StateTextField = createAddressTextFields(&address1StateTextField, placeholder: "State *", xAxis: view.bounds.size.width/2+5, yAxis: self.address1PincodeTextField.frame.origin.y + self.address1PincodeTextField.frame.size.height + 10, preventPaste: true)
        
        let pickerView = UIPickerView()
        pickerView.tag = 2
        pickerView.delegate = self
        address1StateTextField.text = ""//states[0]
        selectedStateCode = ""//statesCode[0]
//        pickerView.selectRow(1, inComponent: 0, animated: false)
        address1StateTextField.inputView = pickerView
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(netHex:0x4F90D9)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(stateTextFieldTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(stateTextFieldTapped))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        address1StateTextField.inputAccessoryView = toolBar
        
        scrollView.addSubview(address1StateTextField)
        address1StateTextField.delegate = self
    }
    
    @objc func stateTextFieldTapped(){
        
        address1StateTextField.resignFirstResponder()
        
        if self.strSelState == ""
        {
//            self.address1StateTextField.text = states[0]
        }
        else
        {
            self.address1StateTextField.text = self.strSelState
        }
        
    }
    
    func setAdress1LocalityTextField(){
        address1LocalityTextField = createAddressTextFields(&address1LocalityTextField, placeholder: "Landmark ", xAxis:10, yAxis: self.addressLine2.frame.origin.y + self.addressLine2.frame.size.height + 10)
        scrollView.addSubview(address1LocalityTextField)
        address1LocalityTextField.delegate = self
    }
    
    func setAdress1CityTextField(){
        address1CityTextField = createAddressTextFields(&address1CityTextField, placeholder: "City *", xAxis: 10, yAxis: self.address1LocalityTextField.frame.origin.y + self.address1LocalityTextField.frame.size.height + 10)
        scrollView.addSubview(address1CityTextField)
        address1CityTextField.delegate = self
    }
    
    func setAdress1PincodeTextField(){
        address1PincodeTextField = createAddressTextFields(&address1PincodeTextField, placeholder: "Pincode *", xAxis: view.bounds.size.width/2+5, yAxis: self.addressLine2.frame.origin.y + self.addressLine2.frame.size.height + 10)
        scrollView.addSubview(address1PincodeTextField)
        address1PincodeTextField.delegate = self
    }
    
    func setAdress1TextField(){
        address1TextField = setTextFieldwithInfo(&address1TextField, placeholder: "Address Line 1 *", leftImage: IMG_Address, isRightImage: false, rightImage: "", yAxis: resConfigTextField.frame.origin.y + resConfigTextField.frame.size.height + 10)
        
        address1TextField.leftImageView.setImageColor(color: .blue)
        address1TextField.rightSecondImageView.setImageColor(color: .blue)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showAddressInfo))
        address1TextField.rightSecondImageView.isUserInteractionEnabled = true
        address1TextField.rightSecondImageView.addGestureRecognizer(tap)
        
        scrollView.addSubview(address1TextField)
        address1TextField.textView.delegate = self
    }
    
    func setAdressLine2TextField(){
        
        addressLine2 = setAddressLine2TextField(&addressLine2, placeholder: "Address Line 2 ", leftImage: IMG_Address, isRightImage: false, rightImage: "", yAxis: self.address1TextField.frame.origin.y + self.address1TextField.frame.size.height + 10)
        
        addressLine2.leftImageView.setImageColor(color: .blue)
        addressLine2.rightSecondImageView.setImageColor(color: .blue)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showAddressInfo))
        addressLine2.rightSecondImageView.isUserInteractionEnabled = true
        addressLine2.rightSecondImageView.addGestureRecognizer(tap)
        
        scrollView.addSubview(addressLine2)
        addressLine2.textView.delegate = self

    }
    
    func setAddressLine2TextField(_ textFieldView: inout AddressLine2TextField, placeholder: String, leftImage: String, isRightImage: Bool, rightImage: String, yAxis: CGFloat) -> AddressLine2TextField  {
        
        textFieldView = Bundle.main.loadNibNamed("AddressLine2TextField", owner: self, options: nil)?[0] as! AddressLine2TextField
        textFieldView.frame = CGRect(x: 10, y: yAxis, width: contentView.bounds.size.width-20,height: 55)
        textFieldView.leftImageView.image = UIImage(named: leftImage)
        textFieldView.textFieldView.layer.borderColor = UIColor(netHex:0xDEDFE0).cgColor
        textFieldView.label.backgroundColor = UIColor(netHex:0xDEDFE0)
        textFieldView.textFieldView.layer.cornerRadius = 3.0
        textFieldView.textFieldView.layer.borderWidth = 1.0
        if isRightImage {
            textFieldView.rightFirstImageView.image = UIImage(named: rightImage)
        }
        textFieldView.rightSecondImageView.image = UIImage(named: IMG_Info)
        textFieldView.textView.textColor = UIColor(netHex:0x000000)
        textFieldView.textView.font = UIFont(name: fontQuicksandBookRegular, size: 16)
        textFieldView.textView.tag = 1
        
        
        let loc: Int = placeholder.characters.count
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: placeholder as String, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(netHex:0x666666)]))
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location:loc-1,length:1))
        myMutableString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: fontQuicksandBookRegular, size: 16)!, range: NSRange(location:0,length:placeholder.characters.count))
        textFieldView.textView.attributedText = myMutableString
        textFieldView.textView.keyboardType = .default
        
        textFieldView.textView.isUserInteractionEnabled = true
        
        textFieldView.backgroundColor = UIColor.white
        return textFieldView
    }
    
    @objc func showAddressInfo() {
        DataManager.shareInstance.showAlert(self, title: addressTitle, message: addressInfoMessage)
    }
    
    func setTextFieldwithInfo(_ textFieldView: inout TextFieldwithInfoView, placeholder: String, leftImage: String, isRightImage: Bool, rightImage: String, yAxis: CGFloat) -> TextFieldwithInfoView {
        
        textFieldView = Bundle.main.loadNibNamed("TextFieldwithInfoView", owner: self, options: nil)?[0] as! TextFieldwithInfoView
        if placeholder == "Address Line 1 *" {
            textFieldView.frame = CGRect(x: 10, y: yAxis, width: contentView.bounds.size.width-20,height: 50)

        } else if placeholder == "Address Line 2 " {
            textFieldView.frame = CGRect(x: 10, y: yAxis, width: contentView.bounds.size.width-20,height: 100)
        }
            
        textFieldView.leftImageView.image = UIImage(named: leftImage)
        textFieldView.textFieldView.layer.borderColor = UIColor(netHex:0xDEDFE0).cgColor
        textFieldView.label.backgroundColor = UIColor(netHex:0xDEDFE0)
        textFieldView.textFieldView.layer.cornerRadius = 3.0
        textFieldView.textFieldView.layer.borderWidth = 1.0
        if isRightImage {
            textFieldView.rightFirstImageView.image = UIImage(named: rightImage)
        }
        textFieldView.rightSecondImageView.image = UIImage(named: IMG_Info)
        textFieldView.textView.textColor = UIColor(netHex:0x000000)
        textFieldView.textView.font = UIFont(name: fontQuicksandBookRegular, size: 16)
        if placeholder == "Address Line 1 *" {
            textFieldView.textView.tag = 1001
        }
        textFieldView.textView.textAlignment = .center
        if (placeholder == "Address Line 1 *" || placeholder == "Address Line 2 " ) {
            let loc: Int = placeholder.characters.count
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: placeholder as String, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(netHex:0x666666)]))
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location:loc-1,length:1))
            myMutableString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: fontQuicksandBookRegular, size: 16)!, range: NSRange(location:0,length:placeholder.characters.count))
            textFieldView.textView.attributedText = myMutableString
            textFieldView.textView.keyboardType = .default
        } else {
            textFieldView.textView.keyboardType = .numbersAndPunctuation
        }
        textFieldView.textView.isUserInteractionEnabled = true
        textFieldView.backgroundColor = UIColor.white
        return textFieldView
    }
    
    func setAddressTypeRadioButtons() {
        
        addressTypeView = Bundle.main.loadNibNamed("AddressTypeRadioBtns", owner: self, options: nil)?[0] as! AddressTypeRadioBtns
        addressTypeView.frame = CGRect(x: 0, y: 15, width: contentView.frame.size.width,height: 50);
        addressTypeView.btnResidential.addTarget(self, action: #selector(addressTypeRadionBtnPressed(_:)), for:.touchUpInside)
        addressTypeView.btnResidential.isSelected = true
        
        addressTypeView.btnCommercial.addTarget(self, action: #selector(addressTypeRadionBtnPressed(_:)), for:.touchUpInside)
        scrollView.addSubview(addressTypeView)
        
    }
    
    @objc func addressTypeRadionBtnPressed(_ button : UIButton) {
        print(button.tag)
        
        if button.tag == 1 {
            if isCompanyNameDisplayed {
                isCompanyNameDisplayed = false
//                updateTextFieldsYcoordinate()
                setResConfigTextField()
                if(companyNameTextField != nil){
                    companyNameTextField.removeFromSuperview()
                }
            }
        } else {
             if !isCompanyNameDisplayed {
                resConfigTextField.removeFromSuperview()
                setCompanyNameTextField()
            }
        }
    }
    
    func setCompanyNameTextField() {
        
        companyNameTextField = createAddressTextFields(&companyNameTextField, placeholder: "Company Name *", xAxis:10, yAxis: 70)
        scrollView.addSubview(companyNameTextField)
        companyNameTextField.delegate = self
        isCompanyNameDisplayed = true
//        updateTextFieldsYcoordinate()
        
        //        iBaseCodeTextFieldView.frame.origin.y = 35+70*4
        //        iBaseCodeTextFieldView .setNeedsDisplay()
    }
    
    func createAddressTextFields(_ textField: inout UITextField!, placeholder: String, xAxis: CGFloat, yAxis: CGFloat, preventPaste: Bool = false) -> UITextField {
        textField = BSCustomTextField(frame: CGRect(x: xAxis, y: yAxis, width: view.bounds.size.width/2-15,height: 50))
        if let textField = textField as? BSCustomTextField, preventPaste {
            textField.readonly = true
        }
        textField.placeholder = placeholder
        textField.layer.borderColor = UIColor(netHex:0xDEDFE0).cgColor
        textField.layer.cornerRadius = 3.0
        textField.layer.borderWidth = 1.0
        textField.textColor = UIColor(netHex:0x000000)
        textField.font = UIFont(name: fontQuicksandBookRegular, size: 16)
        
        let loc: Int = placeholder.characters.count
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: placeholder as String, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(netHex:0x666666)]))
//        if(textField != ageGroupTextField && textField != genderTextField){
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location:loc-1,length:1))
//        }
        myMutableString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: fontQuicksandBookRegular, size: 16)!, range: NSRange(location:0,length:placeholder.characters.count))
        textField.attributedPlaceholder = myMutableString
        //textField.attributedPlaceholder = NSAttributedString(string:placeholder, attributes:[NSForegroundColorAttributeName: UIColor(netHex:0x000000)])
        let paddingForFirst = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.size.height))
        textField.leftView = paddingForFirst
        textField.leftViewMode = UITextField.ViewMode .always
        textField.isUserInteractionEnabled = true
        textField.keyboardType = .default
        if placeholder == "State *" {
            let imageContainer = UIView(frame: CGRect(x: 2, y: contentView.bounds.size.width/2-50, width: 30, height: 25))
            let imageView = UIImageView(image: UIImage(named: IMG_DownArrow))
            imageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
            let arrowTap = UITapGestureRecognizer(target: self, action: #selector(editState))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(arrowTap)
            imageContainer.addSubview(imageView)
            textField.rightView = imageContainer
            textField.rightViewMode = UITextField.ViewMode .always
        }else if placeholder == "Pincode *" {
            textField.keyboardType = .numberPad
        }else if placeholder == "Company Name *" {
            textField.frame = CGRect(x: 10, y: yAxis, width: view.bounds.size.width-20,height: 50)
        }else if placeholder == "Address Line 2 " {
            textField.frame = CGRect(x: 10, y: yAxis, width: view.bounds.size.width-20,height: 50)
        }else if placeholder == "BHK - Bedroom Hall Kitchen *" {
            textField.frame = CGRect(x: 10, y: yAxis, width: view.bounds.size.width-20,height: 50)
        }
        return textField
    }
    
    @objc func editState() {
        address1StateTextField.becomeFirstResponder()
    }
    
    func setResConfigTextField() {
        
        resConfigTextField = createAddressTextFields(&resConfigTextField, placeholder: "BHK - Bedroom Hall Kitchen *", xAxis:10, yAxis: 70)
        resConfPickerView = UIPickerView()
        resConfPickerView.tag = 1
        resConfPickerView.delegate = self
        resConfigTextField.text = ""
        selectedResConfig = ""
        resConfigTextField.inputView = resConfPickerView
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(netHex:0x4F90D9)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(titleDoneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(titleCancelTapped))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        resConfigTextField.inputAccessoryView = toolBar
        
        scrollView.addSubview(resConfigTextField)
        resConfigTextField.delegate = self
    }
    
    @objc func titleDoneTapped(){
        
        if self.selectedResConfig == ""
        {
            resConfigTextField.text = resConfigs[0]
        }
        else
        {
            resConfigTextField.text = selectedResConfig
        }
        
        resConfigTextField.resignFirstResponder()
        
    }
    
    @objc func titleCancelTapped(){
        resConfigTextField.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.tag == 1
        {
            return resConfigs.count
        }
        else if pickerView.tag == 2
        {
            return states.count
        }
        
        
//        if pickerView.tag == 1 {
////            return states.count
//            return resConfigs.count
//        } else if pickerView.tag == 2 {
//            return securityQuestions.count
//        }   else if pickerView.tag == 3 {
//            return titles.count
//        } else if pickerView.tag == 4 {
//            return genders.count
//        }else if pickerView.tag == 5 {
//            return ageGroups.count
//        }else if pickerView.tag == 6 {
//            return resConfigs.count
//        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = .black
        
        if pickerView.tag == 1 {
//            pickerLabel.text = states[row]
            pickerLabel.text = resConfigs[row]
            pickerLabel.font = UIFont(name: fontQuicksandBookRegular, size: 15)
            pickerLabel.textAlignment = NSTextAlignment.center
        } else if pickerView.tag == 2 {
//            let data = securityQuestions[row]
//            let data = securityQuestions[row]
            pickerLabel.text = states[row]
            pickerLabel.font = UIFont(name: fontQuicksandBookRegular, size: 15)
            pickerLabel.textAlignment = NSTextAlignment.center
        } else if pickerView.tag == 3 {
            pickerLabel.text = titles[row]
            pickerLabel.font = UIFont(name: fontQuicksandBookRegular, size: 15)
            pickerLabel.textAlignment = NSTextAlignment.center
        } else if pickerView.tag == 4 {
            pickerLabel.text = genders[row]
            pickerLabel.font = UIFont(name: fontQuicksandBookRegular, size: 15)
            pickerLabel.textAlignment = NSTextAlignment.center
        } else if pickerView.tag == 5 {
            pickerLabel.text = ageGroups[row]
            pickerLabel.font = UIFont(name: fontQuicksandBookRegular, size: 15)
            pickerLabel.textAlignment = NSTextAlignment.center
        } else if pickerView.tag == 6 {
            pickerLabel.text = resConfigs[row]
            pickerLabel.font = UIFont(name: fontQuicksandBookRegular, size: 15)
            pickerLabel.textAlignment = NSTextAlignment.center
        }
        
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         if pickerView.tag == 1 {
            selectedResConfig = resConfigs[row]
         }
        if pickerView.tag == 2
        {
            strSelState = states[row]
        }
    }
    
    func addiBaseCodeTextField(){

//        iBaseCodeTextFieldView = createiBaseNumberView(&iBaseCodeTextFieldView, yAxis: 35+70*6)
        iBaseCodeTextFieldView = createiBaseNumberView(&iBaseCodeTextFieldView, yAxis: 15)
        scrollView.addSubview(iBaseCodeTextFieldView)
        iBaseCodeTextFieldView.iBaseTextField.delegate = self

        iBaseCodeTextFieldView.iBaseTextField.attributedPlaceholder = NSAttributedString(string:"Customer ID", attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(netHex:0x666666)]))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showiBaseInfo))
        iBaseCodeTextFieldView.infoImageView.isUserInteractionEnabled = true
        iBaseCodeTextFieldView.infoImageView.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(btnCustomerIdAction))
        iBaseCodeTextFieldView.btnCustomerID.addGestureRecognizer(tap2)
    }
    
    @objc func showiBaseInfo() {
        DataManager.shareInstance.showAlert(self, title: iBaseTitle, message: iBaseInfoMessage)
    }
    
    @objc func btnCustomerIdAction() {
        self.view.endEditing(true)
        print("cust id")
        let controller:RegisterAddressViewController = self.storyboard!.instantiateViewController(withIdentifier: "RegisterAddressView") as! RegisterAddressViewController
        controller.addresses = (PlistManager.sharedInstance.getValueForKey("user") as? NSDictionary)?.value(forKey: "addresses") as! NSArray
        // setup delegate for new address selection
        controller.addressProtocol1 = self
        controller.isComingFromDashbord = false
        controller.view.frame = self.view.bounds
        controller.view.backgroundColor = UIColor(white: 0.1, alpha: 0.65)
        controller.willMove(toParent: self)
        self.view.addSubview(controller.view)
        self.addChild(controller)
        controller.didMove(toParent: self)
    }
    
    func createiBaseNumberView(_ textFieldView: inout iBaseView, yAxis: CGFloat) -> iBaseView {
        textFieldView = Bundle.main.loadNibNamed("iBaseView", owner: self, options: nil)?[0] as! iBaseView
        
        textFieldView.frame = CGRect(x: 10, y: yAxis, width: contentView.bounds.size.width-20,height: 70)
//        textFieldView.iBaseButton.addTarget(self, action: #selector(iBaseButtonAction), for:.touchUpInside)
        return textFieldView
    }
    
    @IBAction func onClickClose(_ sender: UIButton) {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    //MARK:- UITextView Delegate Methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        if isAddressAutoFilled {
//            clearAllTextFields()
            isAddressAutoFilled = false
            address1TextField.textView.isUserInteractionEnabled = false
            addressLine2.textView.isUserInteractionEnabled = false

        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if (textView.text == "Address Line 1 *" || textView.text == "Address Line 2 " ) {
            textView.text = ""
            textView.font = UIFont(name: fontQuicksandBookRegular, size: 16)!
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {

        if textView.text == "" {
            var placeholder:String = ""
            if textView.tag == 1001 {
                placeholder = "Address Line 1 *" as String
            } else if textView.tag == 1002 {
                placeholder = "Address Line 2 " as String
            }
            
            let loc: Int = placeholder.characters.count
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: placeholder as String, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(netHex:0x666666)]))
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location:loc-1,length:1))
            //myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location:loc,length:0))
            myMutableString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: fontQuicksandBookRegular, size: 16)!, range: NSRange(location:0,length:placeholder.characters.count))
            textView.attributedText = myMutableString
           // textView.resignFirstResponder()
        }

        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
//        if(textView == address1TextField.textView){
//            iBaseCodeTextFieldView.iBaseTextField.text = ""
//        }
        
        textView.textColor = UIColor.black

        if textView.font == UIFont(name: fontQuicksandBookBoldRegular, size: 16) {

            var word:String = ""
            word.append(textView.text.characters.last!)
            
            textView.text = word
            textView.font = UIFont(name: fontQuicksandBookRegular, size: 16)!
            textView.textColor = UIColor.black
            
//            var myMutableString = NSMutableAttributedString()
//            myMutableString = NSMutableAttributedString(string: word as String, attributes: [NSForegroundColorAttributeName: UIColor(netHex:0x000000)])
//            myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location: 0, length: 100))
//            textView.attributedText = myMutableString

        }
//        else if textView.text.characters.count == 0 {
//
//            let placeholder = "Address Line 1 *" as String
//            let loc: Int = placeholder.characters.count
//            var myMutableString = NSMutableAttributedString()
//            myMutableString = NSMutableAttributedString(string: placeholder as String, attributes: [NSForegroundColorAttributeName: UIColor(netHex:0x666666)])
//            myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange(location:loc-1,length:1))
//            myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: fontQuicksandBookBoldRegular, size: 16)!, range: NSRange(location:0,length:placeholder.characters.count))
//
//            textView.resignFirstResponder()
//        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        
        
//        let range1 = NSMakeRange(textView.text.count-1, 1)
        textView.scrollRangeToVisible(range)
        return numberOfChars < 40;
    }
    
}

fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}
