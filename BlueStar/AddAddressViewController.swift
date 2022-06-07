//
//  AddAddressViewController.swift
//  BlueStar
//
//  Created by tarun.kapil on 22/08/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class AddAddressViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UITextViewDelegate {
    
    @IBOutlet weak var aspectRatioTextViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var iBaseLabel: UILabel!
    @IBOutlet weak var iBaseTextField: UITextField!
    @IBOutlet weak var iBaseButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var textHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pincodeLabel: UILabel!
    @IBOutlet weak var pincodeTextField: UITextField!
    @IBOutlet weak var localityLabel: UILabel!
    @IBOutlet weak var localityTextField: UITextField!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var stateArrowImageView: UIImageView!
    
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companyNameTextField: UITextField!
    
//    @IBOutlet weak var companyNameLabelHeight: NSLayoutConstraint!
    
    @IBOutlet weak var companyView: UIView!
    
    @IBOutlet weak var companyNameViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var companyNameLabelHeight: NSLayoutConstraint!
    
    @IBOutlet weak var companyNameTfHeight: NSLayoutConstraint!
    @IBOutlet weak var btnResidential: UIButton!
    @IBOutlet weak var btnCommercial: UIButton!
    
    var navigationBarTitle: String! = "Add New Address"
    var ibaseCode: String! = ""
    var address: String! = ""
    var locality: String! = ""
    var pincode: String! = ""
    var city: String! = ""
    var state: String! = ""
    var firstName: String! = ""
    var lastName: String! = ""
    var mobileNo: String! = ""
    var editAddressID: String! = ""
    var addressTag:Int! = nil
    var primary: String! = "false"
    var isIbaseValidated: Bool = false
    var validateIbaseAndCallSave: Bool = false
    var border = CALayer()
    
    var selectedStateCode: String!
    var selectedAddress: NSDictionary = [:]
    var addressTypeView = AddressTypeRadioBtns()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iBaseTextField.delegate = self
        pincodeTextField.delegate = self
        localityTextField.delegate = self
        cityTextField.delegate = self
        stateTextField.delegate = self
        
        setNavigationBar()
        setTextFields()
        
        
        setAddressTypeRadioButtons()
               NotificationCenter.default.addObserver(self, selector: #selector(self.getSelectedRegisterAddress(_:)), name: NSNotification.Name(rawValue: "addressSelected"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let screenClass = self.classForCoder.description()
        Analytics.setScreenName("Add New Address Screen", screenClass: screenClass)
        Analytics.logEvent("page_view",parameters: ["page":"Add New Address Screen"])
    }
    override func viewDidLayoutSubviews() {
        //        var scrollViewInsets = UIEdgeInsetsZero
        //        scrollViewInsets.top = 50
        //        scrollViewInsets.top -= contentView.bounds.size.height/10.0;
        //        scrollViewInsets.bottom = scrollView.bounds.size.height
        //        scrollViewInsets.bottom -= contentView.bounds.size.height/10.0;
        //        scrollViewInsets.bottom -= 10
        //        scrollView.contentInset = scrollViewInsets
        super.viewDidLayoutSubviews()
        
        let contentSize = self.addressTextView.sizeThatFits(self.addressTextView.bounds.size)
        var frame = self.addressTextView.frame
        frame.size.height = contentSize.height
        self.addressTextView.frame = frame
        
//        aspectRatioTextViewConstraint = NSLayoutConstraint(item: self.addressTextView, attribute: .height, relatedBy: .equal, toItem: self.addressTextView, attribute: .width, multiplier: addressTextView.bounds.height/addressTextView.bounds.width, constant: 1)
//        self.addressTextView.addConstraint(aspectRatioTextViewConstraint!)
//
//        addressTextView.layer.addSublayer(createBorderOfTextView(addressTextView, bottomColor: "gray"))
//        addressTextView.layer.masksToBounds = true
    }
    
    func setNavigationBar() {
        self.title = navigationBarTitle
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
        leftButton.setImage(UIImage(named: IMG_CrossButton), for: UIControl.State())
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.addTarget(self, action: #selector(moveBackToMyAccount), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItem = leftBarButton
        let rightButton = UIButton()
        rightButton.setTitle(" Save", for: UIControl.State())
        rightButton.setImage(UIImage(named: IMG_Tick), for: UIControl.State())
        rightButton.titleLabel?.font = UIFont(name: fontQuicksandBookRegular, size: 15)
        rightButton.frame = CGRect(x: 0, y: 0, width: 70, height: 25)
        let lineViewLeft = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: rightButton.frame.size.height))
        lineViewLeft.backgroundColor = UIColor(netHex: 0x4F90D9)
        rightButton.addSubview(lineViewLeft)
        rightButton.addTarget(self, action: #selector(validateIbaseAndSaveAddressDirect), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        
//        iBaseButton.layer.borderWidth = 1.0
//        iBaseButton.layer.borderColor = UIColor(netHex: 0x246cb0).cgColor
//        iBaseButton.layer.cornerRadius = 5.0
    }
    
    func setTextFields() {
        iBaseLabel.textColor = UIColor(netHex: 0x000000)
        iBaseTextField.layer.addSublayer(createBorder(iBaseTextField, bottomColor: "grey"))
        iBaseTextField.layer.masksToBounds = true
        iBaseTextField.keyboardType = .numberPad
        iBaseTextField.text = ibaseCode
        //print("ibase address is:-\(ibaseCode)")
        
        addressLabel.textColor = UIColor(netHex: 0x000000)
        addressTextView.layer.addSublayer(createBorderOfTextView(addressTextView, bottomColor: "grey"))
        addressTextView.layer.masksToBounds = true
        addressTextView.text = address
        
        pincodeLabel.textColor = UIColor(netHex: 0x000000)
        pincodeTextField.layer.addSublayer(createBorder(pincodeTextField, bottomColor: "grey"))
        pincodeTextField.layer.masksToBounds = true
        pincodeTextField.keyboardType = .numberPad
        pincodeTextField.text = pincode
        
        localityLabel.textColor = UIColor(netHex: 0x000000)
        localityTextField.layer.addSublayer(createBorder(localityTextField, bottomColor: "grey"))
        localityTextField.layer.masksToBounds = true
        localityTextField.text = locality
        
        cityLabel.textColor = UIColor(netHex: 0x000000)
        cityTextField.layer.addSublayer(createBorder(cityTextField, bottomColor: "grey"))
        cityTextField.layer.masksToBounds = true
        cityTextField.text = city
        
        stateLabel.textColor = UIColor(netHex: 0x000000)
        stateTextField.layer.addSublayer(createBorder(stateTextField, bottomColor: "grey"))
        stateTextField.layer.masksToBounds = true
        let paddingForFirst = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: stateTextField.frame.size.height))
        stateTextField.rightView = paddingForFirst
        stateTextField.rightViewMode = UITextField.ViewMode .always
        stateTextField.text = state
        if let textField = stateTextField as? BSCustomTextField, true {
            textField.readonly = true
        }
        
        companyNameTextField.layer.addSublayer(createBorder(companyNameTextField, bottomColor: "grey"))
        companyNameTextField.layer.masksToBounds = true
//        companyNameTextField.keyboardType = .numberPad
        
        
        let arrowTap = UITapGestureRecognizer(target: self, action: #selector(editState))
        stateArrowImageView.isUserInteractionEnabled = true
        stateArrowImageView.addGestureRecognizer(arrowTap)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == pincodeTextField) {
            iBaseTextField.text = ""
            let maxLength = 6
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            
            if newLength==maxLength {
                
                let stringPinCode = pincodeTextField.text! + string as String
                serviceCallForGetCityAndStateFromPincode(stringPinCode)
            }
            
            return newLength <= maxLength
        }
        if(textField == stateTextField || textField == cityTextField || textField == pincodeTextField || textField == addressTextView || textField == localityTextField){
            iBaseTextField.text = ""
        }else{
            stateTextField.text = ""
                        cityTextField.text = ""
                        pincodeTextField.text = ""
                        addressTextView.text = ""
                        localityTextField.text = ""
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == stateTextField {
            stateAction()
        }
        textField.layer.addSublayer(createBorder(textField, bottomColor: "blue"))
        textField.layer.masksToBounds = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.addSublayer(createBorder(textField, bottomColor: "grey"))
        textField.layer.masksToBounds = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == addressTextView{
            iBaseTextField.text = ""
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == stateTextField {
            stateAction()
        }
        textView.layer.addSublayer(createBorderOfTextView(textView, bottomColor: "blue"))
        textView.layer.masksToBounds = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.layer.addSublayer(createBorderOfTextView(textView, bottomColor: "grey"))
        textView.layer.masksToBounds = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func numberOfComponentsInPickerView(_ pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return states.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.text = states[row]
        pickerLabel.font = UIFont(name: fontQuicksandBookRegular, size: 15)
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        stateTextField.text = states[row]
        selectedStateCode = statesCode[row]
        iBaseTextField.text = ""
    }
    
    func stateAction() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        stateTextField.inputView = pickerView
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(netHex:0x4F90D9)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(stateTextFieldTapped(_:)))
        doneButton.tag = 0
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(stateTextFieldTapped(_:)))
        cancelButton.tag = 1
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        stateTextField.inputAccessoryView = toolBar
    }
    
    @objc func stateTextFieldTapped(_ sender: UIButton){
        stateTextField.resignFirstResponder()
    }
    
    @objc func editState() {
        stateTextField.becomeFirstResponder()
    }
    
    func createBorder(_ textField: UITextField, bottomColor: String) -> CALayer {
        
        let border = CALayer()
        let width = CGFloat(1.0)
        if bottomColor == "grey" {
            border.borderColor = UIColor(netHex: 0xDEDFE0).cgColor
        } else if bottomColor == "blue" {
            border.borderColor = UIColor(netHex: 0x246cb0).cgColor
        }
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width: view.bounds.size.width-40, height: textField.frame.size.height)
        border.borderWidth = width
        return border
    }
    
    func createBorderOfTextView(_ textView: UITextView, bottomColor: String) -> CALayer {
        
        let width = CGFloat(1.0)
        if bottomColor == "grey" {
            border.borderColor = UIColor(netHex: 0xDEDFE0).cgColor
        } else if bottomColor == "blue" {
            border.borderColor = UIColor(netHex: 0x246cb0).cgColor
        }
        border.frame = CGRect(x: 0, y: textView.frame.size.height - width, width: view.bounds.size.width-40, height: textView.frame.size.height)
        border.borderWidth = width
        return border
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if(text == "\n") {
            
            textView.resignFirstResponder()
            return false
        }
        
        //let sizeThatFitsTextView = addressTextView.sizeThatFits(CGSize(width: addressTextView.frame.size.width, height: 100000))
        //textHeightConstraint.constant = sizeThatFitsTextView.height;
        addressTextView.layer.addSublayer(createBorderOfTextView(addressTextView, bottomColor: "blue"))
        addressTextView.layer.masksToBounds = true
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        return numberOfChars < 100;
    }
    
    @objc func moveBackToMyAccount() {
        navigationController?.popViewController(animated: true)
    }
    
    func saveUserData() {
        if(iBaseButton.title(for: .normal) != "Customer Id"){
           // selectedAddress
            UserAddressesDatabaseModel.shareInstance.UpdateAddressAsActive(for: PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String, forCustomerId: iBaseButton.title(for: .normal)!)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "updateAddresses"), object: nil)
            //self.dismiss(animated: true, completion: nil)
            navigationController?.popViewController(animated: true)
        }else{
            self.callRegisterApi()
        }
    }
    
    func callRegisterApi(){
        self.view.endEditing(true)
        if NetworkChecker.isConnectedToNetwork() {
            if validateFields() {
                showPlaceHolderView()
                
                var userType: String
                var company: String
                if btnResidential.isSelected {
                    userType = "Residential"
                    company = ""
                } else {
                    userType = "Commercial"
                    company = (companyNameTextField.text?.trim())! 
                }
                
                var values: Dictionary<String, AnyObject> = [:]
                var user: Dictionary<String, AnyObject> = PlistManager.sharedInstance.getValueForKey("user") as! Dictionary<String, AnyObject>
                
                user .removeValue(forKey: "ibaseNumber")
                user .removeValue(forKey: "pin")
                user .removeValue(forKey: "preferedCallingNumber")
                user .removeValue(forKey: "alternateNoPreference")
                user .removeValue(forKey: "alternatemobilenumber")
                
                let addresses: NSMutableArray = []
                    //= user["addresses"] as! NSMutableArray
                var newAddress = ["address1":(addressTextView.text?.trim())!,
                                  "locality":(localityTextField.text?.trim())!,
                                  "city":(cityTextField.text?.trim())!,
                                  "state": selectedStateCode,
                                  "pinCode":(pincodeTextField.text?.trim())!,
                                  //  "ibaseno":(iBaseTextField.text?.trim())!,
                    "subTypeCode" : userType,
                    "companyName" : company]
                //                                  "isPrimaryAddress":primary]
                
                if ((self.navigationBarTitle == "Edit Address")) {
                    
                    addresses.replaceObject(at:addressTag , with: newAddress)
                    //                    if newAddress["isPrimaryAddress"]!! == "true"{
                    //                        if((self.iBaseTextField.text!.trim()) != "" ) {
                    //                            user["ibaseNumber"] = self.iBaseTextField.text as AnyObject?
                    //                        }else{
                    //                            user["ibaseNumber"] = (self.iBaseTextField.text?.trim())! as AnyObject?
                    //                        }
                    //                    }
                } else {
                    //                    if(addresses.value(forKey != newAddress["ibaseno"]){
                    addresses.add(newAddress)
                    //                    }
                    //                    else{
                    //                        DataManager.shareInstance.showAlert(self, title: messageTitle, message: "IBase no. is already exist")
                    //                    }
                    //
                    
                }
                //this will send with primary address
                //                if((self.iBaseTextField.text!.trim()) != "" ) {
                //                    user["ibaseNumber"] = self.iBaseTextField.text
                //                }
                
                //                if((iBaseTextField.text?.trim()) != "" && iBaseButton.titleLabel?.text == "Edit") {
                //                    user["ibaseNumber"] = iBaseTextField.text?.trim() as AnyObject?
                //                }
                
                //                else{
                //                    user["ibaseNumber"] = ""
                //                }
                
                user["addresses"] = addresses
                values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
                values["user"] = user as AnyObject?
                values["platform"] = platform as AnyObject?
                values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
                //      values["ibaseno"] = iBaseTextField.text?.trim() as AnyObject?
                
                if(iBaseButton.title(for: .normal) == "Customer Id"){
                    DataManager.shareInstance.getDataFromWebService(registerUserURLMize, dataDictionary:values as NSDictionary){ (result, error) -> Void in
                        if error == nil {
                            DispatchQueue.main.async {
                                self.hidePlaceHolderView()
                                RegisterUserModel.shareInstance.parseResponseObject(result)
                                //                            let message = RegisterUserModel.shareInstance.errorMessage
                                let status = RegisterUserModel.shareInstance.status!
                                if status == "error" {
                                    //DataManager.shareInstance.showAlert(self, title: messageTitle, message: message)
                                } else {
                                    //call getAllAddresses API
                                    
                                    
                                    //customerId
                                    //
                                    let addressesList: NSMutableArray =  user["addresses"] as! NSMutableArray
                                    newAddress["customerId"] = result?.value(forKey: "customerId") as! String
                                    addressesList.add(newAddress)
                                    user["addresses"] = addressesList
                                    PlistManager.sharedInstance.saveValue(user as AnyObject, forKey: "user")
                                    //UserAddressesDatabaseModel.shareInstance.addUserAddress(PlistManager.sharedInstance.getValueForKey("mobileNumber"), <#T##addresses: NSArray##NSArray#>, active: <#T##String#>)
                                    UserAddressesDatabaseModel.shareInstance.addNewAddressFor(PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String, address: newAddress as NSDictionary)
                                   // UserAddressesDatabaseModel.shareInstance.UpdateAddressAsActive(for: PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String, forCustomerId: result?.value(forKey: "customerId") as! String)
                                    self.navigationController?.popViewController(animated: true)
                                    let nc = NotificationCenter.default
                                     nc.post(name: Notification.Name(rawValue: "updateAddresses"), object: nil)
                                    //getAddressFromMizeServer
                                    //nc.post(name: Notification.Name(rawValue: "getAllAddressFromMize"), object: user)
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
                }else{
                    //add new address in db
                }
                
            }
        } else {
            DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
        }
    }
    
    func validateFields() -> Bool {
        let pinCode = (pincodeTextField.text?.trim())!
        if addressTextView.text?.trim() == "" {
            DataManager.shareInstance.showAlert(self, title: invalidAddressTitle, message: invalidAddressMessage)
            return false
        }
        else if cityTextField.text?.trim() == "" {
            DataManager.shareInstance.showAlert(self, title: invalidCityTitle, message: invalidCityMessage)
            return false
        }
        else if pinCode == "" {
            DataManager.shareInstance.showAlert(self, title: invalidPincodeTitle, message: invalidPincodeMessage)
            return false
        } else if pinCode != "" && (pinCode.characters.count != 6 || !pinCode.isNumeric) {
            DataManager.shareInstance.showAlert(self, title: invalidPincodeTitle, message: invalidPincodeMessage)
            return false
        }
            //        else if localityTextField.text?.trim() == "" {
            //            DataManager.shareInstance.showAlert(self, title: invalidLocalityTitle, message: invalidLocalityMessage)
            //            return false
            //        }
        else if stateTextField.text?.trim() == "" {
            DataManager.shareInstance.showAlert(self, title: invalidStateTitle, message: invalidStateMessage)
            return false
        } else if btnCommercial.isSelected == true {
            if (companyNameTextField.text?.trim() == "") {
                DataManager.shareInstance.showAlert(self, title: invalidCompanyNameTitle, message: invalidCompanyNameMessage)
                return false
            }
        }
        return true
    }
    
    func setAddressTypeRadioButtons() {
        
        let img_radio_button_on = UIImage(named: "radio_button_on") as! UIImage
        let img_radio_button_off = UIImage(named: "radio_button_off") as! UIImage
        
        btnResidential .setBackgroundImage(img_radio_button_off, for: .normal)
        btnResidential .setBackgroundImage(img_radio_button_on , for: .selected)
        
        btnCommercial .setBackgroundImage(img_radio_button_off, for: .normal)
        btnCommercial .setBackgroundImage(img_radio_button_on , for: .selected)
        
        btnResidential.isSelected = true
        
        companyNameViewHeight .constant = 0.0
        companyNameLabelHeight .constant = 0.0
        companyNameTfHeight .constant = 0.0

    }
    
    
//    func addressTypeRadionBtnPressed(_ button : UIButton) {
//        if button.tag == 1 {
//            print("Button Pressed")
//
//
//        } else {
//            print("Button Pressed")
//            let heightConstraint = NSLayoutConstraint(item: companyView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
//            companyView.addConstraint(heightConstraint)
//            companyView.translatesAutoresizingMaskIntoConstraints = false
//
//        }
//    }
    
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
    
    @IBAction func iBaseButtonAction(_ sender: UIButton) {
        if (sender.titleLabel?.text == "Customer Id"){
            //&& iBaseTextField.text!.trim() != ""){
            //call Service
//            var user: Dictionary<String, AnyObject> = PlistManager.sharedInstance.getValueForKey("user") as! Dictionary<String, AnyObject>
//
//            let customerId = user["ibaseNumber"] as! String
//            if customerId ==  iBaseTextField.text!.trim(){
//                DataManager.shareInstance.showAlert(self, title:"Customer ID", message:"You have already added address with this customer ID.")
//            }else{
//                let result:Bool = self.checkIbaseAlreadyExist(user)
//                if(result){
//                        serviceCallForiBaseInfo((iBaseTextField.text!.trim()))
//                }else{
//                    DataManager.shareInstance.showAlert(self, title:"Customer ID", message:"You have already added address with this customer ID.")
//                }
//
//            }
            let controller:RegisterAddressViewController = self.storyboard!.instantiateViewController(withIdentifier: "RegisterAddressView") as! RegisterAddressViewController
            
          //  controller.delegate = self as! registerAddressDelegate
            controller.addresses = UserAddressesDatabaseModel.shareInstance.getUserInactiveAddrress(PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String)
                //(PlistManager.sharedInstance.getValueForKey("user") as? NSDictionary)?.value(forKey: "addresses") as! NSArray
            controller.view.frame = self.view.bounds
            controller.view.backgroundColor = UIColor(white: 0.1, alpha: 0.65)
            
            controller.willMove(toParent: self)
            self.view.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)
        }
        //else if (sender.titleLabel?.text == "Go" && iBaseTextField.text!.trim() == ""){
            //DataManager.shareInstance.showAlert(self, title:"Customer ID", message:"Please enter customer ID.")
      //  }
    else{
            enableTextFieldToEnterAddress()
        }
        
    }
    
    @IBAction func iBaseInfoButtonAction(_ sender: UIButton) {
        DataManager.shareInstance.showAlert(self, title:"Customer ID", message:"Please enter customer ID to retrieve your address.")
    }
    
    func checkIbaseAlreadyExist(_ userDictionary: Dictionary<String, AnyObject>) -> Bool{
        let addresses: NSArray = userDictionary["addresses"] as! NSArray
        for addressDetail in addresses{
            let address: NSDictionary = addressDetail as! NSDictionary
            if(address.value(forKey: "ibaseno") as! String == iBaseTextField.text!.trim()){
                return false
            }
        }
        return true
    }
    func enableTextFieldToEnterAddress() {
        iBaseButton.setTitle("Customer Id", for:UIControl.State())
        
        addressTextView.isEditable = true
        pincodeTextField.isEnabled = true
        localityTextField.isEnabled = true
        cityTextField.isEnabled = true
        stateTextField.isEnabled = true
        iBaseTextField.isEnabled = true
        
        iBaseTextField.text = ""
        addressTextView.text = ""
        pincodeTextField.text = ""
        localityTextField.text = ""
        cityTextField.text = ""
        stateTextField.text = ""
        isIbaseValidated = false
    }
    
    func disableTextFieldToEnterAddress() {
        //iBaseButton.setTitle("Edit", for:UIControlState())
        
        iBaseTextField.isEnabled = false
        addressTextView.isEditable = false
        pincodeTextField.isEnabled = false
        localityTextField.isEnabled = false
        cityTextField.isEnabled = false
        stateTextField.isEnabled = false
        if(validateIbaseAndCallSave){
            self.saveUserData()
        }
    }
    
    @objc func validateIbaseAndSaveAddressDirect(){
        if(isIbaseValidated && (iBaseTextField.text?.trim()) != ""){
            self.saveUserData()
        }else if(!isIbaseValidated && (iBaseTextField.text?.trim()) != ""){
            validateIbaseAndCallSave = true
            self.iBaseButtonAction(iBaseButton)
        }else{
            self.saveUserData()
        }
    }
    
    func serviceCallForGetCityAndStateFromPincode(_ pinCodeNumber: String) {
        
        if NetworkChecker.isConnectedToNetwork() {
            
            let values: Dictionary<String, AnyObject> = [:]
            let googleMapURL = "http://maps.googleapis.com/maps/api/geocode/json?components=country:IN%7Cpostal_code:" + pinCodeNumber
            
            let mapMyIndiaURL = "https://apis.mapmyindia.com/advancedmaps/v1/7dij7ibnselacx3o1leyj9o37d7fp598/place_detail?place_id=" + pinCodeNumber
            DataManager.shareInstance.getDataFromWebService(mapMyIndiaURL, dataDictionary:values as NSDictionary) { (result, error) -> Void in
                
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
                                    self.cityTextField.text = newCity
                                }
                                
                                if (newState?.characters.count)! > 0 {
                                    self.stateTextField.text = newState
                                }
                                
                                for (index,value) in states.enumerated() {
                                    
                                    if value == newState {
                                        print(index )
                                        self.selectedStateCode = statesCode[index]
                                    }
                        
                        
                        //
//                        if let responseDictionary: NSDictionary = result as? NSDictionary {
//
//                            let responseAddresses : NSArray = (responseDictionary.object(forKey: "results") as? NSArray)!
//
//                            if responseAddresses.count > 0 {
//
//                                let addresses = responseAddresses .value(forKey: "address_components") as? NSArray
//                                let localAddress = addresses?.object(at: 0) as? NSArray
//
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
//                                        self.stateTextField.text = address1 .value(forKey: "long_name") as! String?
//                                    }
//                                }
//
//                                if stringLocalAddressCountry == "India" {
//
//                                    if stringLocalAddressCity.characters.count > 0 {
//
//                                        if stringLocalAddressCityLocality.characters.count > 0 {
//
//                                            self.cityTextField.text = stringLocalAddressCityLocality
//                                        }
//                                        else {
//
//                                            self.cityTextField.text = stringLocalAddressCity
//                                        }
//                                    }
//                                    else {
//
//                                        self.cityTextField.text = ""
//                                    }
//                                }
//                                else {
//
//                                    self.cityTextField.text = ""
//                                    self.stateTextField.text = ""
//                                }
//                            }
//                        }//
                                }
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
    
    
    func serviceCallForiBaseInfo(_ iBaseNumber: String) {
        
        if NetworkChecker.isConnectedToNetwork() {
            var values: Dictionary<String, AnyObject> = [:]
            values["ibaseNumber"] = iBaseNumber as AnyObject?//iBaseCodeTextField.textField.text//"122016"//PlistManager.sharedInstance.getValueForKey("mobileNumber")
            self.showPlaceHolderView()
            DataManager.shareInstance.getDataFromWebService(iBaseURL, dataDictionary:values as NSDictionary) { (result, error) -> Void in
                
                if error == nil {
                    DispatchQueue.main.async {
                        self.hidePlaceHolderView()
                        
                        if let responseDictionary: NSDictionary = result as? NSDictionary {
                            
                            if(checkKeyExist(KEY_Status, dictionary: responseDictionary)) {
                                if let responseStatus : String = (responseDictionary.object(forKey: KEY_Status) as? String) {
                                    if responseStatus == "success"{
                                        
                                        if(isNotNull(responseDictionary.object(forKey: "addresses") as AnyObject?)) {
                                            
                                            if let responseAddresses : NSArray = (responseDictionary.object(forKey: "addresses") as? NSArray){
                                                
                                                var fullAddress :String = ""
                                                var iBaseAddress:String = ""
                                                var city:String = ""
                                                var locality:String = ""
                                                var pincode:String = ""
                                                var state:String = ""
                                                self.isIbaseValidated = true
                                                let address  = responseAddresses.object(at: 0) as! NSDictionary
                                                if isNotNull(address.object(forKey: "address") as AnyObject?){
                                                    iBaseAddress = address["address"] as! String
                                                    fullAddress = iBaseAddress
                                                }
                                                
                                                if isNotNull(address.object(forKey: "city") as AnyObject?){
                                                    city = address["city"] as! String
                                                    fullAddress = fullAddress + "\n" + city
                                                }
                                                
                                                if isNotNull(address.object(forKey: "locality") as AnyObject?){
                                                    locality = address["locality"] as! String
                                                    if locality.trim() != ""{
                                                        fullAddress = fullAddress + "\n" + locality
                                                    }
                                                }
                                                
                                                if isNotNull(address.object(forKey: "pincode") as AnyObject?){
                                                    pincode = address["pincode"] as! String
                                                    if pincode.trim() != ""{
                                                        fullAddress = fullAddress + "\n" + pincode
                                                    }
                                                }
                                                
                                                if isNotNull(address.object(forKey: "state") as AnyObject?){
                                                    state = address["state"] as! String
                                                    fullAddress = fullAddress + "\n" + state
                                                }
                                                
                                                let refreshAlert = UIAlertController(title: "Do you want this address.", message:fullAddress, preferredStyle: UIAlertController.Style.alert)
                                                
                                                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                                    self.iBaseTextField.resignFirstResponder()
                                                    self.addressTextView.text = iBaseAddress
                                                    self.cityTextField.text = city
                                                    self.localityTextField.text = locality
                                                    self.pincodeTextField.text = pincode
                                                    self.stateTextField.text = state
                                                    //print("I base Address is:------->\(iBaseAddress)")
                                                    self.disableTextFieldToEnterAddress()
                                                }))
                                                
                                                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                                                    
                                                    self.enableTextFieldToEnterAddress()
                                                    
                                                }))
                                                
                                                self.present(refreshAlert, animated: true, completion: nil)
                                                
                                                
                                                
                                            } else {
                                                // products = []
                                            }
                                        }
                                    }else{
                                        if let responseError : String = (responseDictionary.object(forKey: "errorMessage") as? String)
                                        {
                                            DataManager.shareInstance.showAlert(self, title: errorTitle, message: responseError)
                                        }
                                    }
                                    
                                } else {
                                    DataManager.shareInstance.showAlert(self, title: errorTitle, message: errorMessage)
                                    
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
    
    @IBAction func radioButtonClicked(_ button: UIButton) {
        if button.tag == 2 {
            companyNameViewHeight .constant = 50.0
            companyNameLabelHeight .constant = 13.0
            companyNameTfHeight .constant = 30.0
            btnCommercial.isSelected = true
            btnResidential.isSelected = false
        } else if button.tag == 1 {
            companyNameViewHeight .constant = 0.0
            companyNameLabelHeight .constant = 0.0
            companyNameTfHeight .constant = 0.0
            btnResidential.isSelected = true
            btnCommercial.isSelected = false
        }
    }
    
    //MARK:- Register Address Delegate Method
    
    @objc func getSelectedRegisterAddress(_ notification: NSNotification) {
          if let address = notification.userInfo! as NSDictionary? {
            print(address)
            selectedAddress = address
            var fullAddress :String = ""
            var iBaseAddress:String = ""
            //var address2:String = ""
            var city:String = ""
            var locality:String = ""
            var pincode:String = ""
            var state:String = ""
            self.isIbaseValidated = true
            //let address  = responseAddresses.object(at: 0) as! NSDictionary
            if isNotNull(address["address1"] as AnyObject?){
                iBaseAddress = address["address1"] as! String
                fullAddress = iBaseAddress
            }
            //        if isNotNull(address["address2"] as AnyObject?){
            //           // city = address["city"] as! String
            //            address2 = fullAddress + "\n" + city
            //        }
            if isNotNull(address["city"] as AnyObject?){
                city = address["city"] as! String
                fullAddress = fullAddress + "\n" + city
            }
            
            if isNotNull(address["locality"] as AnyObject?){
                locality = address["locality"] as! String
                if locality.trim() != ""{
                    fullAddress = fullAddress + "\n" + locality
                }
            }
            
            if isNotNull(address["pincode"] as AnyObject?){
                pincode = address["pincode"] as! String
                if pincode.trim() != ""{
                    fullAddress = fullAddress + "\n" + pincode
                }
            }
            
            if isNotNull(address["state"] as AnyObject?){
                state = address["state"] as! String
                fullAddress = fullAddress + "\n" + state
            }
            
            let refreshAlert = UIAlertController(title: "Do you want this address.", message:fullAddress, preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                self.iBaseTextField.resignFirstResponder()
                self.iBaseButton.setTitle(address["customerId"] as? String, for: .normal)
                self.addressTextView.text = iBaseAddress
                self.cityTextField.text = city
                self.localityTextField.text = locality
                self.pincodeTextField.text = pincode
                self.stateTextField.text = state
                
                self.disableTextFieldToEnterAddress()
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                self.enableTextFieldToEnterAddress()
            }))
            self.present(refreshAlert, animated: true, completion: nil)
        }
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
