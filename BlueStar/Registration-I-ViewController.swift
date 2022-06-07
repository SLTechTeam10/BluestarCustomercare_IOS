//
//  Registration-I-ViewController.swift
//  BlueStar
//
//  Created by Hexan Dev on 13/10/21.
//  Copyright © 2021 BlueStar. All rights reserved.
//

import UIKit
import FirebaseAnalytics
import Firebase

//class BSCustomTextField: UITextField {
//    
//    var readonly: Bool = false
//    
//    override func target(forAction action: Selector, withSender sender: Any?) -> Any? {
//        if ((action == #selector(paste(_:)) || (action == #selector(cut(_:))) || (action == #selector(copy(_:)))) && self.readonly) {
//            return nil
//        }
//        return super.target(forAction: action, withSender: sender)
//    }
//    
//    override func caretRect(for position: UITextPosition) -> CGRect {
//        if readonly {
//            return CGRect.zero
//        }
//        return super.caretRect(for: position)
//    }
//}

class Registration_I_ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UITextViewDelegate, ProductTokenViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var navigationBarView: UIView!
    
    @IBOutlet weak var crossButton: UIButton!
    var titlePickerView = UIPickerView()
    var titleTextField = TextFieldView()
    var firstNameTextField = TextFieldView()
    var lastNameTextField = TextFieldView()
    var genderTextField : UITextField!
    var genderPickerView = UIPickerView()
    var agePickerView = UIPickerView()
    var resConfPickerView = UIPickerView()
    var ageGroupTextField : UITextField!
    var resConfigTextField : UITextField!
    
    var alternateMobileNoTextField = TextFieldView()
    var primaryMobileNoTextField = TextFieldView()
    
    var addressTypeView = AddressTypeRadioBtns()
    var companyNameTextField : UITextField!

    var iBaseCodeTextFieldView = iBaseView()//TextFieldwithInfoView()
    var customerIDView = iBaseViewNew()
    var address1TextField = TextFieldwithInfoView()
    var addressLine2 = AddressLine2TextField()
    var address1PincodeTextField: UITextField!
    var address1LocalityTextField: UITextField!
    var address1CityTextField: UITextField!
    var address1StateTextField: UITextField!
    var emailTextField = TextFieldView()
    var preferredTimeTextField = PreferredTimeTextFieldView()
    //var questionTextField = TextFieldwithInfoView()
    var chooseProductTextField = DropDownView()
    var productTokenField:ProductTokenView!// = ProductTokenView()
    var fromDate: Date!
    var toDate : Date!
    var fromAmPm : String!
    var toAmPm :String!
    let checkedImage = UIImage(named: "check_box")! as UIImage
    let uncheckedImage = UIImage(named: "uncheck_box")! as UIImage
    var buttonSubmit:UIButton!
    var primaryNoCheckBoxButton:UIButton!
    var alternateNoCheckBoxButton:UIButton!

    var  tokenViewheight:CGFloat = 30.0
    var isChecked : Bool = false
    var isCompanyNameDisplayed : Bool = false
    var selectedStateCode: String!
    var selectedTitle: String!
    var selectedGender: String!
    var selectedAge: String!
    var selectedResConfig: String!
    var isAddressAutoFilled : Bool = false
    var isFirtTimeHide: Bool = false
    let dateFormatter = DateFormatter()
    var blackColor = UIColor(netHex:0x000000)
    var grayColor = UIColor(netHex:0x666666)

    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigationBar()
        setTitleTextField()
        setFirstNameTextField()
        setLastNameTextField()
        setGenderTextField()
        setAgeGroupTextField()
        setPrimaryMobileNoTextField()
        setAlternateMobileNoTextField()
        addiBaseCodeTextField() //this will be added in next version
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
        setprimaryNoCheckBoxButton()
        setAlternateNoCheckBoxButton()
        serviceCallForProductList()
        let user = PlistManager.sharedInstance.getValueForKey("user") as? NSDictionary
        if user != nil {
            preFillAllFields(user!)
        }
//        var user1: Dictionary<String, AnyObject> = PlistManager.sharedInstance.getValueForKey("user") as! Dictionary<String, AnyObject>
//        print(user1)
        let nc = NotificationCenter.default

        nc.addObserver(self, selector: #selector(updateProductSelection), name: NSNotification.Name(rawValue: "updateProductSelection"), object: nil)
        
        
        
       nc.addObserver(self, selector: #selector(addressSelected(_:)), name: NSNotification.Name(rawValue: "addressSelected"), object: nil)
        
        nc.addObserver(self, selector: #selector(clearAllTextFields), name: NSNotification.Name(rawValue: "clearAllTextFields"), object: nil)
        

        primaryNoCheckBoxButton.isHidden = true
        alternateNoCheckBoxButton.isHidden = true
//        updateTextFieldsYcoordinate()
        if(!isFirtTimeHide){
            DataManager.shareInstance.showAlert(self, title: "Welcome", message: "Welcome to the Blue Star Customer Care Application! Please register to continue and help us serve you better.")
            crossButton.isHidden = false
        }else{
            crossButton.isHidden = true
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setContentSize()
        let screenClass = self.classForCoder.description()
        Analytics.setScreenName("Registration Screen", screenClass: screenClass)
        Analytics.logEvent("page_view",parameters: ["page":"Registration Screen"])
    }


    func setContentSize() {
//        if isCompanyNameDisplayed {
            productTokenField.frame = CGRect(x: 10, y: 30+70*15, width: contentView.frame.size.width-20,height: tokenViewheight);
//        } else {
//            productTokenField.frame = CGRect(x: 10, y: 30+70*14, width: contentView.frame.size.width-20,height: tokenViewheight);
//        }
        if ProductBL.shareInstance.selectedProducts.count == 0 {
            buttonSubmit.frame = CGRect(x: 10,y: productTokenField.frame.origin.y+tokenViewheight-10,width: UIScreen.main.bounds.size.width-20,height: 50)
        } else {
            buttonSubmit.frame = CGRect(x: 10,y: productTokenField.frame.origin.y+tokenViewheight+14,width: UIScreen.main.bounds.size.width-20,height: 50)
        }
        scrollView.contentSize = CGSize(width: scrollView.bounds.size.width, height: 50+buttonSubmit.frame.origin.y+20)
    }

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
            // CRASH 25/12 ZYZZ
//            self.address1LocalityTextField.text = (addr.value(forKey: "locality") as! String)
            if let local = (addr.value(forKey: "locality") as? String){
                self.address1LocalityTextField.text = local
            }else{
                self.address1LocalityTextField.text = ""
            }
            
            if (self.address1LocalityTextField.text == "") {
                address1LocalityTextField.attributedPlaceholder = NSAttributedString(string: "Landmark",
                                                                       attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor):  UIColor(netHex:0x666666)]))
            }
            self.address1PincodeTextField.text = (addr.value(forKey: "pinCode") as! String)
//            self.address1StateTextField.text = (addr.value(forKey: "state") as! String)
            disableTextFieldToEnterAddress()
            
            self.iBaseCodeTextFieldView.iBaseTextField.text = addr["customerId"] as! String
//            isAddressAutoFilled = true
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func createNavigationBar() {
        navigationBarView.layer.backgroundColor = UIColor(netHex: 0x246cb0).cgColor
        navigationBarView.tintColor = UIColor.white
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
    }
    
    func setTextField(_ textFieldView: inout TextFieldView, placeholder: String, leftImage: String, yAxis: CGFloat) -> TextFieldView {
        textFieldView = Bundle.main.loadNibNamed("TextFieldView", owner: self, options: nil)?[0] as! TextFieldView
        textFieldView.frame = CGRect(x: 10, y: yAxis, width: contentView.bounds.size.width-20,height: 50)
//        if(placeholder == "Title *"){
//            textFieldView.frame = CGRect(x: 10, y: yAxis, width: 80,height: 50)
//        }
        textFieldView.leftImageView.image = UIImage(named: leftImage)
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
    
    func setMobileNumberTextField(_ textFieldView: inout TextFieldView, placeholder: String, leftImage: String, yAxis: CGFloat) -> TextFieldView {
        textFieldView = Bundle.main.loadNibNamed("TextFieldView", owner: self, options: nil)?[0] as! TextFieldView
        textFieldView.frame = CGRect(x: 10, y: yAxis, width: contentView.bounds.size.width-20,height: 50)
        //enable it when checkboxex are displayed
        //textFieldView.frame = CGRect(x: 10, y: yAxis, width: contentView.bounds.size.width-60,height: 50)
        textFieldView.leftImageView.image = UIImage(named: leftImage)
        textFieldView.textFieldView.layer.borderColor = UIColor(netHex:0xDEDFE0).cgColor
        textFieldView.label.backgroundColor = UIColor(netHex:0xDEDFE0)
        textFieldView.textFieldView.layer.cornerRadius = 3.0
        textFieldView.textFieldView.layer.borderWidth = 1.0
        textFieldView.rightFirstImageView.isHidden = true
        textFieldView.textField.textColor = UIColor(netHex:0x666666)
        textFieldView.textField.font = UIFont(name: fontQuicksandBookRegular, size: 16)
        
        if placeholder == "Primary Mobile Number *" {
            let loc: Int = placeholder.characters.count
            var myMutableString = NSMutableAttributedString()
            //let range = (placeholder as String).range(of: placeholder)
            //let boldFontAttribute = [NSFontAttributeName:boldFontAttribute!]
            myMutableString = NSMutableAttributedString(string: placeholder as String, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(netHex:0x666666)]))
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location:loc-1,length:1))
            //let boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16.0)]
            //UIFont.boldSystemFont(ofSize: 16.0)
            
            //myMutableString.addAttributes(boldFontAttribute, range: String.range(placeholder))
            //myMutableString.addAttributes(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 16),range: loc )
            myMutableString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: fontQuicksandBookBoldRegular, size: 16)!, range: NSRange(location:0,length:placeholder.characters.count))
            //let boldfont = NSMutableAttributedString(string: placeholder as String)
            textFieldView.textField.attributedPlaceholder = myMutableString
            
            textFieldView.textField.autocapitalizationType = .words
        }
        else if placeholder == "Alternate Mobile Number" {
            
            let loc: Int = placeholder.characters.count
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: placeholder as String, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(netHex:0x666666)]))
       //     myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: fontQuicksandBookBoldRegular, size: 16)!, range: NSRange(location:0,length:placeholder.characters.count))
            textFieldView.textField.attributedPlaceholder = myMutableString
            
            textFieldView.textField.autocapitalizationType = .words
        }
        else {
            textFieldView.textField.attributedPlaceholder = NSAttributedString(string:placeholder, attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(netHex:0x666666)]))
        }
        let paddingForFirst = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textFieldView.textField.frame.size.height))
        textFieldView.textField.leftView = paddingForFirst
        textFieldView.textField.leftViewMode = UITextField.ViewMode .always
        textFieldView.textField.isUserInteractionEnabled = true
//                if textFieldView == alternateMobileNoTextField {
//                    textFieldView.textField.keyboardType = .numberPad
//                } else {
        textFieldView.textField.keyboardType = .default
//                }
        textFieldView.backgroundColor = UIColor.white
        return textFieldView
    }
    
    func setAddressTextFields(_ textFieldView: inout TextFieldView, placeholder: String, xAxis: CGFloat, yAxis: CGFloat) -> TextFieldView {
        textFieldView = Bundle.main.loadNibNamed("TextFieldView", owner: self, options: nil)?[0] as! TextFieldView
        textFieldView.frame = CGRect(x: xAxis, y: yAxis, width: contentView.bounds.size.width/2-15,height: 50)
        textFieldView.textField.frame = CGRect(x: 10, y: textFieldView.textField.frame.origin.y, width: contentView.bounds.size.width/2-15,height: 50)
        textFieldView.leftImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0));
        textFieldView.textFieldView.layer.borderColor = UIColor(netHex:0xDEDFE0).cgColor
        textFieldView.label.isHidden = true
        textFieldView.textFieldView.layer.cornerRadius = 3.0
        textFieldView.textFieldView.layer.borderWidth = 1.0
        textFieldView.rightFirstImageView.isHidden = true
        textFieldView.textField.textColor = UIColor(netHex:0x666666)
        textFieldView.textField.font = UIFont(name: fontQuicksandBookRegular, size: 16)
        textFieldView.textField.attributedPlaceholder = NSAttributedString(string:placeholder, attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(netHex:0x666666)]))
        
        let paddingForFirst = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textFieldView.textField.frame.size.height))
        textFieldView.textField.leftView = paddingForFirst
        textFieldView.textField.leftViewMode = UITextField.ViewMode .always
        textFieldView.textField.isUserInteractionEnabled = true
        textFieldView.textField.keyboardType = .default
        textFieldView.backgroundColor = UIColor.white
        return textFieldView
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
//            else if placeholder == "Address Line 2 " {
//            textFieldView.textView.tag == 1002
//        }
//        textView.textAlignment = NSTextAlignmentCenter;
        textFieldView.textView.textAlignment = .center
//        textFieldView.contentVerticalAlignment = .center
        if (placeholder == "Address Line 1 *" || placeholder == "Address Line 2 " ) {
            let loc: Int = placeholder.characters.count
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: placeholder as String, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(netHex:0x666666)]))
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location:loc-1,length:1))
            myMutableString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: fontQuicksandBookRegular, size: 16)!, range: NSRange(location:0,length:placeholder.characters.count))
            //   textFieldView.textView.attributedPlaceholder = myMutableString
            textFieldView.textView.attributedText = myMutableString
            textFieldView.textView.keyboardType = .default
        } else {
          //  textFieldView.textView.attributedPlaceholder = NSAttributedString(string:placeholder, attributes:[NSForegroundColorAttributeName: UIColor(netHex:0x000000)])
            textFieldView.textView.keyboardType = .numbersAndPunctuation
        }
//        let paddingForFirst = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textFieldView.textView.frame.size.height))
        //textFieldView.textView.leftView = paddingForFirst
        //textFieldView.textView.leftViewMode = UITextFieldViewMode .always
        textFieldView.textView.isUserInteractionEnabled = true
        //        if textFieldView == pinTextField {
        //            textFieldView.textField.keyboardType = .NumberPad
        //            textFieldView.textField.secureTextEntry = true
        //        } else {
        //        }
        textFieldView.backgroundColor = UIColor.white
        return textFieldView
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
        if(textView == address1TextField.textView){
            iBaseCodeTextFieldView.iBaseTextField.text = ""
        }
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
    
    //MARK:- Helper Methods
    
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
    
    func createiBaseNumberView(_ textFieldView: inout iBaseView, yAxis: CGFloat) -> iBaseView {
        textFieldView = Bundle.main.loadNibNamed("iBaseView", owner: self, options: nil)?[0] as! iBaseView
        
        textFieldView.frame = CGRect(x: 10, y: yAxis, width: contentView.bounds.size.width-20,height: 70)
//        textFieldView.iBaseButton.addTarget(self, action: #selector(iBaseButtonAction), for:.touchUpInside)
        return textFieldView
    }
    
//    func createCustomerIdView(_ textFieldView: inout iBaseViewNew, yAxis: CGFloat) -> iBaseViewNew {
//        customerIDView = Bundle.main.loadNibNamed("iBaseViewNew", owner: self, options: nil)?[0] as! iBaseViewNew
//        customerIDView.frame = CGRect(x: 10, y: yAxis, width: contentView.bounds.size.width-20,height: 70)
//        customerIDView.btnCustomerID.addTarget(self, action: #selector(btnCustomerIdAction), for:.touchUpInside)
//        return customerIDView
//    }
    func setTitleTextField() {
        
        titleTextField = setTextField(&titleTextField, placeholder:"Select Title *", leftImage: IMG_User, yAxis: 30)
        
        titlePickerView = UIPickerView()
        titlePickerView.tag = 3
        titlePickerView.delegate = self
        titleTextField.textField.text = ""
        selectedTitle = ""
        titleTextField.textField.inputView = titlePickerView
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
        titleTextField.textField.inputAccessoryView = toolBar
        
        scrollView.addSubview(titleTextField)
        titleTextField.textField.delegate = self
    }
    func setFirstNameTextField(){
        firstNameTextField = setTextField(&firstNameTextField, placeholder:"First Name *", leftImage: IMG_User, yAxis: 30+70)
        scrollView.addSubview(firstNameTextField)
        firstNameTextField.textField.delegate = self
    }
    
    func setLastNameTextField(){
        lastNameTextField = setTextField(&lastNameTextField, placeholder: "Last Name *", leftImage: IMG_User, yAxis: 30+70*2)
        scrollView.addSubview(lastNameTextField)
        lastNameTextField.textField.delegate = self
    }
    func setGenderTextField() {
        
//        genderTextField = setTextField(&genderTextField, placeholder:"Gender", leftImage: IMG_User, yAxis: 30+70*3)
        genderTextField = createAddressTextFields(&genderTextField, placeholder: "Gender *", xAxis: 10, yAxis: 35+70*3, preventPaste: true)
        genderPickerView = UIPickerView()
        genderPickerView.tag = 4
        genderPickerView.delegate = self
        genderTextField.text = ""
        selectedGender = ""
        genderTextField.inputView = genderPickerView
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
        genderTextField.inputAccessoryView = toolBar
        
        scrollView.addSubview(genderTextField)
        genderTextField.delegate = self
    }
    func setAgeGroupTextField() {
        
//        ageGroupTextField = setTextField(&ageGroupTextField, placeholder:"Age Group", leftImage: IMG_User, yAxis: 30+70*3)
        ageGroupTextField = createAddressTextFields(&ageGroupTextField, placeholder: "Age (years) *", xAxis: view.bounds.size.width/2+5, yAxis: 35+70*3, preventPaste: true)
        agePickerView = UIPickerView()
        agePickerView.tag = 5
        agePickerView.delegate = self
        ageGroupTextField.text = ""
        selectedAge = ""
        ageGroupTextField.inputView = agePickerView
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
        ageGroupTextField.inputAccessoryView = toolBar
        
        scrollView.addSubview(ageGroupTextField)
        ageGroupTextField.delegate = self
    }
    func setPrimaryMobileNoTextField() {
        primaryMobileNoTextField = setMobileNumberTextField(&primaryMobileNoTextField, placeholder: "Primary Mobile Number *", leftImage: IMG_Mobile, yAxis: 30+70*4)
        scrollView.addSubview(primaryMobileNoTextField)
        primaryMobileNoTextField.textField.text = PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String?
        self.primaryMobileNoTextField.textField.isEnabled = false
        primaryMobileNoTextField.textField.keyboardType = .numberPad
        //self.primaryNoTextField.backgroundColor = UIColor(color.whitec)
        self.primaryMobileNoTextField.textField.textColor = blackColor
        primaryMobileNoTextField.textField.delegate = self
    }
    func setAlternateMobileNoTextField() {
        alternateMobileNoTextField = setMobileNumberTextField(&alternateMobileNoTextField, placeholder: "Alternate Mobile Number", leftImage: IMG_Mobile, yAxis: 30+70*5)
        scrollView.addSubview(alternateMobileNoTextField)
        alternateMobileNoTextField.textField.keyboardType = .numberPad
        alternateMobileNoTextField.textField.delegate = self
    }
    
    
    
    func addiBaseCodeTextField(){
        //        iBaseCodeTextField = setTextFieldwithInfo(&iBaseCodeTextField, placeholder: "iBase Number", leftImage: IMG_iBaseCode, isRightImage: false, rightImage: "", yAxis: 30+70*2)
        iBaseCodeTextFieldView = createiBaseNumberView(&iBaseCodeTextFieldView, yAxis: 35+70*6)
        scrollView.addSubview(iBaseCodeTextFieldView)
        iBaseCodeTextFieldView.iBaseTextField.delegate = self
//        iBaseCodeTextFieldView.iBaseTextField.textColor = UIColor(netHex:0x666666)

        iBaseCodeTextFieldView.iBaseTextField.attributedPlaceholder = NSAttributedString(string:"Customer ID", attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(netHex:0x666666)]))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showiBaseInfo))
        iBaseCodeTextFieldView.infoImageView.isUserInteractionEnabled = true
        iBaseCodeTextFieldView.infoImageView.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(btnCustomerIdAction))
//        iBaseCodeTextFieldView.infoImageView.isUserInteractionEnabled = true
        iBaseCodeTextFieldView.btnCustomerID.addGestureRecognizer(tap2)
    }
    
//    func setCustomerIdView() {
//        customerIDView = createCustomerIdView(&customerIDView, yAxis: 35+70*4)
//        scrollView.addSubview(customerIDView)
//
//        let tap = UITapGestureRecognizer(target: self, action: #selector(showiBaseInfo))
//        customerIDView.infoImageView.isUserInteractionEnabled = true
//        customerIDView.infoImageView.addGestureRecognizer(tap)
//    }
    
    func setAddressTypeRadioButtons() {
        //        Bundle.mainBundle().loadNibNamed("SomeView", owner: self, options: nil)
        //        scrollView.addSubview(self.view);
        
        addressTypeView = Bundle.main.loadNibNamed("AddressTypeRadioBtns", owner: self, options: nil)?[0] as! AddressTypeRadioBtns
        addressTypeView.frame = CGRect(x: 0, y: 40+70*7, width: contentView.frame.size.width,height: 50);
        addressTypeView.btnResidential.addTarget(self, action: #selector(addressTypeRadionBtnPressed(_:)), for:.touchUpInside)
        addressTypeView.btnResidential.isSelected = true
        
        addressTypeView.btnCommercial.addTarget(self, action: #selector(addressTypeRadionBtnPressed(_:)), for:.touchUpInside)
        scrollView.addSubview(addressTypeView)
    }
    func setResConfigTextField() {
        
        resConfigTextField = createAddressTextFields(&resConfigTextField, placeholder: "BHK - Bedroom Hall Kitchen *", xAxis:10, yAxis: 30+70*8)
        resConfPickerView = UIPickerView()
        resConfPickerView.tag = 6
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
//        if isAddressAutoFilled {
//            clearAllTextFields()
//            isAddressAutoFilled = false
//        }
    }
    
    func setCompanyNameTextField() {
        companyNameTextField = createAddressTextFields(&companyNameTextField, placeholder: "Company Name *", xAxis:10, yAxis: 30+70*8)
        scrollView.addSubview(companyNameTextField)
        companyNameTextField.delegate = self
        isCompanyNameDisplayed = true
//        updateTextFieldsYcoordinate()
        
        //        iBaseCodeTextFieldView.frame.origin.y = 35+70*4
        //        iBaseCodeTextFieldView .setNeedsDisplay()
    }
    
    func setAdress1TextField(){
        address1TextField = setTextFieldwithInfo(&address1TextField, placeholder: "Address Line 1 *", leftImage: IMG_Address, isRightImage: false, rightImage: "", yAxis: 30+70*9)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showAddressInfo))
        address1TextField.rightSecondImageView.isUserInteractionEnabled = true
        address1TextField.rightSecondImageView.addGestureRecognizer(tap)
        
        scrollView.addSubview(address1TextField)
        address1TextField.textView.delegate = self
    }
    
    func setAdressLine2TextField(){
//        addressLine2 = createAddressTextFields(&address1LocalityTextField, placeholder: "Address Line 2 ", xAxis:10, yAxis: 55+70*7)
//        scrollView.addSubview(address1LocalityTextField)
//        address1LocalityTextField.delegate = self
        
//        addressLine2 = setTextFieldwithInfo(&addressLine2, placeholder: "Address Line 2 ", leftImage: IMG_Address, isRightImage: false, rightImage: "", yAxis: 55+70*7)
        
        addressLine2 = setAddressLine2TextField(&addressLine2, placeholder: "Address Line 2 ", leftImage: IMG_Address, isRightImage: false, rightImage: "", yAxis: 35+70*10)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showAddressInfo))
        addressLine2.rightSecondImageView.isUserInteractionEnabled = true
        addressLine2.rightSecondImageView.addGestureRecognizer(tap)
        
//            createAddressTextFields(&address1LocalityTextField, placeholder: "Address Line 2 ", xAxis:10, yAxis: 55+70*7)
        scrollView.addSubview(addressLine2)
        addressLine2.textView.delegate = self

    }
    
    func setAdress1PincodeTextField(){
        address1PincodeTextField = createAddressTextFields(&address1PincodeTextField, placeholder: "Pincode *", xAxis: view.bounds.size.width/2+5, yAxis: 35+70*11)
        scrollView.addSubview(address1PincodeTextField)
        address1PincodeTextField.delegate = self
    }
    
    func setAdress1LocalityTextField(){
        address1LocalityTextField = createAddressTextFields(&address1LocalityTextField, placeholder: "Landmark ", xAxis:10, yAxis: 35+70*11)
        scrollView.addSubview(address1LocalityTextField)
        address1LocalityTextField.delegate = self
    }
    
    func setAdress1CityTextField(){
        address1CityTextField = createAddressTextFields(&address1CityTextField, placeholder: "City *", xAxis: 10, yAxis: 35+70*12)
        scrollView.addSubview(address1CityTextField)
        address1CityTextField.delegate = self
    }
    
    func setAdress1StateTextField(){
        address1StateTextField = createAddressTextFields(&address1StateTextField, placeholder: "State *", xAxis: view.bounds.size.width/2+5, yAxis: 35+70*12, preventPaste: true)
        
        let pickerView = UIPickerView()
        pickerView.tag = 1
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
    
    func setEmailTextField(){
        emailTextField = setTextField(&emailTextField, placeholder: "Email *", leftImage: IMG_Email, yAxis: 35+70*13)
        scrollView.addSubview(emailTextField)
        emailTextField.textField.delegate = self
        emailTextField.textField.keyboardType = .emailAddress
    }
    
    func setPreferredTimeTextField() {
        preferredTimeTextField = Bundle.main.loadNibNamed("PreferredTimeTextFieldView", owner: self, options: nil)?[0] as! PreferredTimeTextFieldView
        preferredTimeTextField.frame = CGRect(x: 10, y: 35+70*14, width: contentView.frame.size.width-20,height: 50)
        preferredTimeTextField.leftImageView.image = UIImage(named: IMG_PreferredTime)
        preferredTimeTextField.textFieldView.layer.borderColor = UIColor(netHex:0xDEDFE0).cgColor
        preferredTimeTextField.label.backgroundColor = UIColor(netHex:0xDEDFE0)
        preferredTimeTextField.preferredTimeLabel.textColor = UIColor.black;//UIColor(netHex:0x000000)
        preferredTimeTextField.textFieldView.layer.cornerRadius = 3.0
        preferredTimeTextField.textFieldView.layer.borderWidth = 1.0
        
        preferredTimeTextField.textFieldOne.textColor = UIColor(netHex:0x000000)
        preferredTimeTextField.textFieldOne.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.light)
        preferredTimeTextField.textFieldOne.attributedPlaceholder = NSAttributedString(string:"15:00", attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(netHex:0x000000)]))
        let paddingForFirst = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: preferredTimeTextField.textFieldOne.frame.size.height))
        preferredTimeTextField.textFieldOne.leftView = paddingForFirst
        preferredTimeTextField.textFieldOne.leftViewMode = UITextField.ViewMode .always
        preferredTimeTextField.textFieldOne.isUserInteractionEnabled = true
        
        preferredTimeTextField.textFieldTwo.textColor = UIColor(netHex:0x000000)
        preferredTimeTextField.textFieldTwo.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.light)
        preferredTimeTextField.textFieldTwo.attributedPlaceholder = NSAttributedString(string:"16:00", attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(netHex:0x000000)]))
        
        let paddingForSecond = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: preferredTimeTextField.textFieldTwo.frame.size.height))
        preferredTimeTextField.textFieldTwo.leftView = paddingForSecond
        preferredTimeTextField.textFieldTwo.leftViewMode = UITextField.ViewMode .always
        preferredTimeTextField.textFieldTwo.isUserInteractionEnabled = true
        
        preferredTimeTextField.backgroundColor = UIColor.white
        scrollView.addSubview(preferredTimeTextField)
        preferredTimeTextField.textFieldOne.delegate = self
        preferredTimeTextField.textFieldTwo.delegate = self
        preferredTimeTextField.textFieldOne.text = "15:00"
        preferredTimeTextField.textFieldTwo.text = "16:00"
        dateFormatter.dateFormat = "HH:mm"
         toDate = dateFormatter.date(from: preferredTimeTextField.textFieldTwo.text!)
         fromDate = dateFormatter.date(from: preferredTimeTextField.textFieldOne.text!)
        //let endDate = preferredTimeTextField.textFieldTwo.text
        let calendar = NSCalendar.current
        let componentsFromStartDate = calendar.component(.hour , from: fromDate!)
        let componentsFromEndDate = calendar.component(.hour , from: toDate!)
        if(componentsFromStartDate >= 00 && componentsFromStartDate <= 11){
            fromAmPm = "am"
        }
        else
        {
            fromAmPm = "pm"
        }
        if(componentsFromEndDate >= 00 && componentsFromEndDate <= 11){
            toAmPm = "am"
        }
        else
        {
            toAmPm = "pm"
        }
        
        preferredTimeTextField.buttonInfoTime.addTarget(self, action: #selector(timeInfoButtonAction), for:.touchUpInside)
    }
    
    func addProductChooseField(){
        chooseProductTextField = createDropDowndWithInfo(&chooseProductTextField, placeholder: "Select Products", leftImage: IMG_ProductList, isRightImage: true, rightImage: IMG_DownArrow, yAxis: 35+70*14)
        
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
    
    func addProductTokenField() {
        productTokenField = Bundle.main.loadNibNamed("ProductTokenView", owner: self, options: nil)?[0] as! ProductTokenView
        productTokenField.delegate = self
        productTokenField.frame = CGRect(x: 10, y: 15+70*15, width: contentView.frame.size.width-20,height: tokenViewheight);
        scrollView.addSubview(productTokenField)
    }
    
    func setSubmitButton() {
        buttonSubmit = UIButton(frame: CGRect(x: 10, y: 70+productTokenField.frame.origin.y, width: UIScreen.main.bounds.size.width-20, height: 50))
        
        //        let button = UIButton(frame: CGRect(x: 10, y: 70+70*11, width: UIScreen.mainScreen().bounds.size.width-20, height: 50))
        buttonSubmit.setTitle("Submit", for: UIControl.State())
        buttonSubmit.setPreferences()
        buttonSubmit.addTarget(self, action: #selector(submitButtonAction), for: .touchUpInside)
        scrollView.addSubview(buttonSubmit)
        scrollView.bringSubviewToFront(buttonSubmit)
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

    /*
     func setQuestionTextField(){
     questionTextField = setTextFieldwithInfo(&questionTextField, placeholder: "Security Question", leftImage: IMG_SecurityQuestion, isRightImage: true, rightImage: IMG_DownArrow, yAxis: 30+70*8)
     
     let pickerView = UIPickerView()
     pickerView.tag = 2
     pickerView.delegate = self
     questionTextField.textField.inputView = pickerView
     let toolBar = UIToolbar()
     toolBar.barStyle = UIBarStyle.Default
     toolBar.translucent = true
     toolBar.tintColor = UIColor(netHex:0x4F90D9)
     toolBar.sizeToFit()
     let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(questionTextFieldTapped))
     let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
     let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(questionTextFieldTapped))
     toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
     toolBar.userInteractionEnabled = true
     questionTextField.textField.inputAccessoryView = toolBar
     
     let arrowTap = UITapGestureRecognizer(target: self, action: #selector(editQuestion))
     questionTextField.rightFirstImageView.userInteractionEnabled = true
     questionTextField.rightFirstImageView.addGestureRecognizer(arrowTap)
     
     let tap = UITapGestureRecognizer(target: self, action: #selector(showQuestionInfo))
     questionTextField.rightSecondImageView.userInteractionEnabled = true
     questionTextField.rightSecondImageView.addGestureRecognizer(tap)
     
     scrollView.addSubview(questionTextField)
     questionTextField.textField.delegate = self
     }
     
     func setAnswerTextField(){
     answerTextField = setTextField(&answerTextField, placeholder: "Answer", leftImage: IMG_Answer, yAxis: 30+70*9)
     scrollView.addSubview(answerTextField)
     answerTextField.textField.delegate = self
     }
     
     
     func setPinTextField(){
     pinTextField = setTextFieldwithInfo(&pinTextField, placeholder: "Choose your pin", leftImage: IMG_Pin, isRightImage: false, rightImage: "", yAxis: 30+70*10)
     
     let tap = UITapGestureRecognizer(target: self, action: #selector(showPinInfo))
     pinTextField.rightSecondImageView.userInteractionEnabled = true
     pinTextField.rightSecondImageView.addGestureRecognizer(tap)
     
     scrollView.addSubview(pinTextField)
     pinTextField.textField.delegate = self
     }
     
     func editQuestion() {
     questionTextField.textField.becomeFirstResponder()
     }
     */
    
    @objc func editState() {
        address1StateTextField.becomeFirstResponder()
    }
    
    func showQuestionInfo() {
        DataManager.shareInstance.showAlert(self, title: securityQuestionTitle, message: securityQuestionInfoMessage)
    }
    
    func showPinInfo() {
        DataManager.shareInstance.showAlert(self, title: pinTittle, message: pinInfoMessage)
    }
    
    @objc func showAddressInfo() {
        DataManager.shareInstance.showAlert(self, title: addressTitle, message: addressInfoMessage)
    }
    
    @objc func showiBaseInfo() {
        DataManager.shareInstance.showAlert(self, title: iBaseTitle, message: iBaseInfoMessage)
    }
    
    @objc func showProductChooseInfo() {
        DataManager.shareInstance.showAlert(self, title:"Product", message:"Select your products.")
    }
    
    @objc func timeInfoButtonAction() {
        DataManager.shareInstance.showAlert(self, title: "Preferred Time for Service", message:"Enter your preferred time of technician visit.")
    }

    func iBaseButtonAction() {
        
//        if (iBaseCodeTextFieldView.iBaseButton.titleLabel?.text == "Go" && iBaseCodeTextFieldView.iBaseTextField.text!.trim() != ""){
//            //call Service
//            serviceCallForiBaseInfo((iBaseCodeTextFieldView.iBaseTextField.text!.trim()))
//        }
//        else if (iBaseCodeTextFieldView.iBaseButton.titleLabel?.text == "Go" && iBaseCodeTextFieldView.iBaseTextField.text!.trim() == ""){
//            DataManager.shareInstance.showAlert(self, title:"Customer ID", message:"Please enter Customer ID.")
//        }else{
//            //enable text field
//            enableTextFieldToEnterAddress()
//        }
    }
    
    @objc func btnCustomerIdAction() {
        self.view.endEditing(true)
        print("cust id")
        let controller:RegisterAddressViewController = self.storyboard!.instantiateViewController(withIdentifier: "RegisterAddressView") as! RegisterAddressViewController
        controller.addresses = (PlistManager.sharedInstance.getValueForKey("user") as? NSDictionary)?.value(forKey: "addresses") as! NSArray

//        if controller.addresses.count == 0 {
//            controller.tableView.frame = CGRect(x: controller.tableView.frame.origin.x, y: controller.tableView.frame.origin.y, width: controller.tableView.frame.size.width, height: 100)
//            tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableView.contentSize.height)

//        }
            //UserAddressesDatabaseModel.shareInstance.getUserAddrress(PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String)
        controller.isComingFromDashbord = false
        controller.view.frame = self.view.bounds
        controller.view.backgroundColor = UIColor(white: 0.1, alpha: 0.65)
        controller.willMove(toParent: self)
        self.view.addSubview(controller.view)
        self.addChild(controller)
        controller.didMove(toParent: self)
    }
    
//    func enableTextFieldToEnterAddress() {
//      //  iBaseCodeTextFieldView.iBaseButton.setTitle("Go", for:UIControlState())
//
//        address1TextField.textView.isEditable = true
//        address1CityTextField.isEnabled = true
//        address1StateTextField.isEnabled = true
//        address1PincodeTextField.isEnabled = true
//        address1LocalityTextField.isEnabled = true
//     //  iBaseCodeTextFieldView.iBaseTextField.isEnabled = true
//
//        address1TextField.textView.text = ""
//        address1CityTextField.text = ""
//        address1StateTextField.text = ""
//        address1PincodeTextField.text = ""
//        address1LocalityTextField.text = ""
//
//     //  iBaseCodeTextFieldView.iBaseTextField.text = ""
//    }
    
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
    
    func enableTextFieldToEnterAddress() {
        address1TextField.textView.isUserInteractionEnabled = true
        addressLine2.textView.isUserInteractionEnabled = true
        address1PincodeTextField.isEnabled = true
        address1LocalityTextField.isEnabled = true
        address1CityTextField.isEnabled = true
        address1StateTextField.isEnabled = true
        addressTypeView.btnCommercial.isEnabled = true
        addressTypeView.btnResidential.isEnabled = true
        
        addressTypeView.btnCommercial.isUserInteractionEnabled = true
        addressTypeView.btnResidential.isUserInteractionEnabled = true
        
        address1TextField.textView.textColor = UIColor.black
        addressLine2.textView.textColor = UIColor.black
        address1PincodeTextField.textColor = UIColor.black
        address1LocalityTextField.textColor = UIColor.black
        address1CityTextField.textColor = UIColor.black
        address1StateTextField.textColor = UIColor.black

    }
    
    @objc func openProductList() {
        //open product List
        let vc : ProductListPickerVC =  ProductListPickerVC(nibName: "ProductListPickerVC", bundle: nil)//change this to your class name
//        let user = PlistManager.sharedInstance.getValueForKey("user") as? NSDictionary
//        if let _ = user?.value(forKey: "registeredProductsIds") {
//            let strProductIds = user?.value(forKey: "registeredProductsIds") as! String
//            let arrProductIds = strProductIds.components(separatedBy: ",")
//            let mutableArray: NSMutableArray = NSMutableArray ()
//
//            let arrAllProducts = ProductBL.shareInstance.products
//            for value in arrAllProducts{
//                let product = value as! ProductData
//                if(arrProductIds.contains(product.productId!)){
//                    mutableArray.add(product)
//                }
//            }
//            ProductBL.shareInstance.selectedProducts = mutableArray
//            self.productTokenField.tokens = mutableArray
//            self.productTokenField.reloadTokeData()
//        }
        vc.isFromRegistration = true
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    // MARK: - UITextField Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //        if(textField == pinTextField.textField) {
        //            let maxLength = 4
        //            guard let text = textField.text else { return true }
        //            let newLength = text.characters.count + string.characters.count - range.length
        //            return newLength <= maxLength
        //        }
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
                iBaseCodeTextFieldView.iBaseTextField.text = ""

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
        else if(textField == alternateMobileNoTextField.textField){
            let maxLength = 10
            guard let text = textField.text else { return true }
            //guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            if(newLength == maxLength )
            {
                primaryNoCheckBoxButton.isEnabled = true
                alternateNoCheckBoxButton.isEnabled = true
                //primaryNoCheckBoxButton.setImage(uncheckedImage, for: .normal)
                //alternateNoCheckBoxButton.setImage(checkedImage, for: .normal)
               // self.isChecked = true
            }
            else if(newLength < maxLength){
                primaryNoCheckBoxButton.isEnabled = false
                alternateNoCheckBoxButton.isEnabled = false
                //primaryNoCheckBoxButton.setImage(checkedImage, for: .normal)
                //alternateNoCheckBoxButton.setImage(uncheckedImage, for: .normal)
               // self.isChecked = false
            }
            return newLength <= maxLength
            
        }
        else if(textField == firstNameTextField || textField == lastNameTextField)
        {
            let maxLength = 50
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            if  newLength <= maxLength{
                
                let inverseSet = CharacterSet(charactersIn:" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.&").inverted
                
                let components = string.components(separatedBy: inverseSet)
                
                let filtered = components.joined(separator: "")  // use join("", components) if you are using Swift 1.2
                
                return string == filtered
                
            }
            else if(textField == primaryMobileNoTextField || textField == alternateMobileNoTextField){
                let maxLength = 10
                guard let text = textField.text else { return true }
                let newLength = text.characters.count + string.characters.count - range.length
                return newLength <= maxLength
            }
            else{
                return false
            }
            
            
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
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func findSelectedIndexFor(picker pickerView: UIPickerView, selectedValue: inout String,from: [String]){
        if(selectedValue.characters.count > 0){
            pickerView.selectRow(from.index(of:selectedValue)!, inComponent: 0, animated: true)
        }else{
            pickerView.selectRow(0, inComponent: 0, animated: true)
            selectedValue = from[0]
        }
        pickerView.reloadAllComponents()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField.placeholder == "Select Title *"){
            findSelectedIndexFor(picker: titlePickerView, selectedValue: &selectedTitle, from: titles)
        }else if(textField.placeholder == "Gender *"){
            findSelectedIndexFor(picker: genderPickerView, selectedValue: &selectedGender, from: genders)
        }else if(textField.placeholder == "Age (years) *"){
            findSelectedIndexFor(picker: agePickerView, selectedValue: &selectedAge, from: ageGroups)
        }else if(textField.placeholder == "BHK - Bedroom Hall Kitchen *"){
            findSelectedIndexFor(picker: resConfPickerView, selectedValue: &selectedResConfig, from: resConfigs)
        }
        else if isAddressAutoFilled {
          //  clearAllTextFields()
            isAddressAutoFilled = false
            address1TextField.textView.isUserInteractionEnabled = false
            addressLine2.textView.isUserInteractionEnabled = false
            address1PincodeTextField.isEnabled = false
        }else if textField == preferredTimeTextField.textFieldOne {
            startTimeAction()
        } else if textField == preferredTimeTextField.textFieldTwo {
            endTimeAction()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func navigationCrossButtonAction(_ sender: AnyObject) {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    func endTimeAction() {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.time
        datePickerView.minuteInterval=30
        datePickerView.locale = Locale(identifier: "en_GB")
        preferredTimeTextField.textFieldTwo.inputView = datePickerView
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(netHex:0x4F90D9)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(TextFieldTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(TextFieldTapped))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        preferredTimeTextField.textFieldTwo.inputAccessoryView = toolBar
        
        datePickerView.addTarget(self, action: #selector(datePickerValueChangedTwo), for: UIControl.Event.valueChanged)
        
        dateFormatter.dateFormat =  "HH:mm"
        if let dates = dateFormatter.date(from: preferredTimeTextField.textFieldTwo.text!){
            datePickerView.date = dates
        }
    }
    
    func startTimeAction() {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.time
        datePickerView.minuteInterval=30
        datePickerView.locale = Locale(identifier: "en_GB")
        preferredTimeTextField.textFieldOne.inputView = datePickerView
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(netHex:0x4F90D9)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(TextFieldTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(TextFieldTapped))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        preferredTimeTextField.textFieldOne.inputAccessoryView = toolBar
        
        datePickerView.addTarget(self, action: #selector(datePickerValueChangedOne), for: UIControl.Event.valueChanged)
        
        
        dateFormatter.dateFormat =  "HH:mm"
        if let dates = dateFormatter.date(from: preferredTimeTextField.textFieldOne.text!){
            datePickerView.date = dates
        }

    }
    
    @objc func datePickerValueChangedOne(_ sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        preferredTimeTextField.textFieldOne.text = dateFormatter.string(from: sender.date)
        preferredTimeTextField.textFieldTwo.text = dateFormatter.string(from: sender.date.addingTimeInterval(3600))
        fromDate = dateFormatter.date(from: dateFormatter.string(from: sender.date))
        //let hour:Int? = Int(dateFormatter.string(from: fromDate!))!
        let calendar = NSCalendar.current
        let components = calendar.component(.hour , from: dateFormatter.date(from: dateFormatter.string(from: sender.date))!)
        
        if(components >= 00 && components <= 11){
            fromAmPm = "am"
        }
        else
        {
            fromAmPm = "pm"
        }

    }
    
    @objc func datePickerValueChangedTwo(_ sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        preferredTimeTextField.textFieldTwo.text = dateFormatter.string(from: sender.date)
        toDate = dateFormatter.date(from: dateFormatter.string(from: sender.date))
        //let hour:Int? = Int(dateFormatter.string(from: toDate!))!
        let calendar = NSCalendar.current
        let components = calendar.component(.hour , from: dateFormatter.date(from: dateFormatter.string(from: sender.date))!)
        
        if(components >= 00 && components <= 11){
            toAmPm = "am"
        }
        else
        {
            toAmPm = "pm"
        }

    }
    
    @objc func TextFieldTapped(){
        preferredTimeTextField.textFieldOne.resignFirstResponder()
        preferredTimeTextField.textFieldTwo.resignFirstResponder()
    }
    
    //    func questionTextFieldTapped(){
    //        questionTextField.textField.resignFirstResponder()
    //    }
    
    @objc func stateTextFieldTapped(){
        address1StateTextField.resignFirstResponder()
    }
    @objc func titleDoneTapped(){
        titleTextField.textField.text = selectedTitle
        genderTextField.text = selectedGender
        ageGroupTextField.text = selectedAge
        resConfigTextField.text = selectedResConfig
        titleTextField.textField.resignFirstResponder()
        ageGroupTextField.resignFirstResponder()
        genderTextField.resignFirstResponder()
        resConfigTextField.resignFirstResponder()
    }
    @objc func titleCancelTapped(){
        selectedTitle = titleTextField.textField.text
        selectedGender = genderTextField.text
        selectedAge = ageGroupTextField.text
        selectedResConfig = resConfigTextField.text
        titleTextField.textField.resignFirstResponder()
        ageGroupTextField.resignFirstResponder()
        genderTextField.resignFirstResponder()
        resConfigTextField.resignFirstResponder()
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return states.count
        } else if pickerView.tag == 2 {
            return securityQuestions.count
        }   else if pickerView.tag == 3 {
            return titles.count
        } else if pickerView.tag == 4 {
            return genders.count
        }else if pickerView.tag == 5 {
            return ageGroups.count
        }else if pickerView.tag == 6 {
            return resConfigs.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = .black
        if pickerView.tag == 1 {
            pickerLabel.text = states[row]
            pickerLabel.font = UIFont(name: fontQuicksandBookRegular, size: 15)
            pickerLabel.textAlignment = NSTextAlignment.center
        } else if pickerView.tag == 2 {
            let data = securityQuestions[row]
            pickerLabel.text = data["question"]
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
            address1StateTextField.text = states[row]
            selectedStateCode = statesCode[row]
            iBaseCodeTextFieldView.iBaseTextField.text = ""
        } else if pickerView.tag == 2 {
            // let data = securityQuestions[row]
            //questionTextField.textField.text = data["question"]
        } else if pickerView.tag == 3 {
            selectedTitle = titles[row]
        }else if pickerView.tag == 4 {
            selectedGender = genders[row]
        }else if pickerView.tag == 5 {
            selectedAge = ageGroups[row]
        }else if pickerView.tag == 6 {
            selectedResConfig = resConfigs[row]
        }
    }
    
    @objc func submitButtonAction(_ sender: AnyObject) {
        self.view.endEditing(true)
        if NetworkChecker.isConnectedToNetwork() {
            if validateFields() {
                showPlaceHolderView()
                
                var userType: String
                var company: String
                if addressTypeView.btnResidential.isSelected {
                    userType = "Residential"
                } else {
                    userType = "Commercial"
                }
                
                let userData = PlistManager.sharedInstance.getValueForKey("user") as? NSDictionary
                var values: Dictionary<String, AnyObject> = [:]
                var user: Dictionary<String, Any> = [:]
                user["title"] = selectedTitle.getTitleCode()
                user["firstName"] = (firstNameTextField.textField.text?.trim())! as AnyObject?
                user["lastName"] = (lastNameTextField.textField.text?.trim())! as AnyObject?
//                user["mobileNumber"] = (primaryMobileNoTextField .textField.text?.trim())! as AnyObject?
                user["alternatemobilenumber"] = (alternateMobileNoTextField.textField.text?.trim())! as AnyObject?
                
                user["gender"] = selectedGender
                user["age"] = selectedAge
//                user["residentialConfiguration"] = selectedResConfig
                if isCompanyNameDisplayed {
                    company = (companyNameTextField.text?.trim())!
                } else {
                    company = ""
                }
                if(self.isChecked == true)
                {
                  //  user["preferedCallingNumber"] = (alternateMobileNoTextField.textField.text?.trim())! as AnyObject?
                }
                else
                {
                  //  user["preferedCallingNumber"] = (primaryMobileNoTextField.textField.text?.trim())! as AnyObject?
                }
                //user["alternatemobilenumber"] = (alternateMobileNoTextField.textField.text?.trim())! as AnyObject?
                
                if userData != nil {
                    
//                    if(customerIDView.btnCustomerID.title(for: .normal) as! String != "Customer ID"){
                    if ((iBaseCodeTextFieldView.iBaseTextField.text?.trim().count)! > 0) {
                        var selectedAdd:NSMutableDictionary = [:]
                        var allAdds = userData?.value(forKey: "addresses") as! NSMutableArray
                        for i in 0..<allAdds.count {
                            let aaa = allAdds[i] as! NSMutableDictionary
                            if(aaa["customerId"] as? String == iBaseCodeTextFieldView.iBaseTextField.text){
                                selectedAdd = allAdds[i] as! NSMutableDictionary
                                break
                            }
                        }
//                        selectedAdd.setValue(selectedResConfig, forKey: "residentialConfiguration")
//                        for address in (userData!["addresses"] as? [[String:String]])! {
//                            if(address["customerId"] == iBaseCodeTextFieldView.iBaseTextField.text){
//                                selectedAdd = address as                                 break
//                            }
//                        }
                        if(selectedAdd["subTypeCode"] as! String == "Residential"){
                            if let ress = selectedAdd["residentialConfiguration"] as? String{
                                if (ress.count <= 0){
                                    selectedAdd.setValue(selectedResConfig, forKey: "residentialConfiguration")
                                    var arr : NSMutableArray = []
                                    arr.add(selectedAdd)
                                    user["addresses"] = arr
                                }else if(resConfigs.contains(ress)){
                                     user["addresses"] = [] as NSArray
                                }else{
                                    selectedAdd.setValue(selectedResConfig, forKey: "residentialConfiguration")
                                    var arr : NSMutableArray = []
                                    arr.add(selectedAdd)
                                    user["addresses"] = arr
                                }
                            }else{
                                selectedAdd.setValue(selectedResConfig, forKey: "residentialConfiguration")
                                var arr : NSMutableArray = []
                                arr.add(selectedAdd)
                                user["addresses"] = arr
                            }
                            
                        }else{
                             user["addresses"] = [] as NSArray
                        }
//                        user["addresses"] = [] as NSArray
                        
                    }else{
                        //let addresses = userData!["addresses"] as! NSMutableArray selectedStateCode as AnyObject?
                        var addressLine2Text : String
                        if addressLine2.textView.text?.trim() == "Address Line 2" {
                            addressLine2Text = ""
                        } else {
                            addressLine2Text = (addressLine2.textView.text?.trim())!
                        }
                        
                        let newPrimaryAddress = [["address1":(address1TextField.textView.text?.trim())!,
                                                 "address2" : addressLine2Text,
                                                 "locality":(address1LocalityTextField.text?.trim())!,
                                                 "city":(address1CityTextField.text?.trim())!,
                                                 "state":selectedStateCode,
                                                 "pinCode":(address1PincodeTextField.text?.trim())!,
                                                 "companyName":company,
                                                 "residentialConfiguration": selectedResConfig,
                                                 "subTypeCode":userType]]
                        //addresses.add(newPrimaryAddress)
                         user["addresses"] = newPrimaryAddress

                    }
                    
                    // New registration
//                    if addresses.count==0 {
//                          let newPrimaryAddress = [["address1":(address1TextField.textView.text?.trim())!,
//                                                    "address2" : addressLine2.text?.trim(),
//                            "locality":(address1LocalityTextField.text?.trim())!,
//                            "city":(address1CityTextField.text?.trim())!,
////                            "state":(address1StateTextField.text?.trim())!,
//                            "state": selectedStateCode as AnyObject?,
//
//                            "pinCode":(address1PincodeTextField.text?.trim())!,
//                        //    "ibaseno":(iBaseCodeTextFieldView.iBaseTextField.text?.trim())!,
//                            //"isPrimaryAddress":"true",
//                            "companyName":company,
//                            "subTypeCode":userType]]
//
//                        user["addresses"] = newPrimaryAddress as AnyObject?
//
//                    }else{
//                        user["addresses"] = addresses
//                    }
                }
//                else {
//                   let newAddress = [["address1":(address1TextField.textView.text?.trim())!,
//                        "locality":(address1LocalityTextField.text?.trim())!,
//                        "city":(address1CityTextField.text?.trim())!,
//                        "state":(address1StateTextField.text?.trim())!,
//                        "pinCode":(address1PincodeTextField.text?.trim())!,
//                       // "ibaseno":(iBaseCodeTextFieldView.iBaseTextField.text?.trim())!,
//                       // "isPrimaryAddress":"true",
//                        "companyName":companyNameTextField.text?.trim(),
//                        "subTypeCode":userType]]
//
//                     user["addresses"] = newAddress as AnyObject?
//                }
                
                /*
                 if(self.questionTextField.textField.text?.trim() != "") {
                 var securityQuestionId: String!
                 for value in securityQuestions {
                 if value["question"] == (self.questionTextField.textField.text?.trim())! {
                 securityQuestionId = value["id"]!
                 }
                 }
                 user["securityQuestionId"] = securityQuestionId
                 user["securityQuestionAnswer"] = (answerTextField.textField.text?.trim())!
                 } else {
                 user["securityQuestionId"] = ""
                 user["securityQuestionAnswer"] = ""
                 }
                 
                 user["pin"] = (pinTextField.textField.text?.trim())!
                 */
                
                user["email"] = (emailTextField.textField.text?.trim())! as AnyObject?
                //remove prefered time once all done
//                if((self.preferredTimeTextField.textFieldOne.text?.trim()) != "") {
//                    let time = (preferredTimeTextField.textFieldOne.text?.trim())!
//                    dateFormatter.dateFormat = "HH:mm"
//                    let date = dateFormatter.date(from: time)
//                    dateFormatter.dateFormat = "HH:mm:ss"
//                    let newTime = dateFormatter.string(from: date!)
//                 //   user["prefferedTimingFrom"] = newTime as AnyObject?
//                } else {
//                 //   user["prefferedTimingFrom"] = "15:00:00" as AnyObject?
//                }
//                if((self.preferredTimeTextField.textFieldTwo.text?.trim()) != "") {
//                    let time = (preferredTimeTextField.textFieldTwo.text?.trim())!
//                    dateFormatter.dateFormat = "HH:mm"
//                    let date = dateFormatter.date(from: time)
//                    dateFormatter.dateFormat = "HH:mm:ss"
//                    let newTime = dateFormatter.string(from: date!)
//                  //  user["prefferedTimingTo"] = newTime as AnyObject?
//                } else {
//                  //  user["prefferedTimingTo"] = "16:00:00" as AnyObject?
//                }
                values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")

                // uncomment blow code when we show customer id filed
                /*
                if((iBaseCodeTextFieldView.iBaseTextField.text?.trim()) != "" && iBaseCodeTextFieldView.iBaseButton.titleLabel?.text == "Edit") {
                    user["ibaseNumber"] = iBaseCodeTextFieldView.iBaseTextField.text
                }else{
                    user["ibaseNumber"] = ""
                }
 */
//                user["ibaseNumber"] = (iBaseCodeTextFieldView.iBaseTextField.text?.trim())! as AnyObject?
                
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
                    user["registeredProductsIds"] = productIds as AnyObject? // ZYZZ 28/10
//                    user["registeredProductsIds"] = "F5800"
                }
                values["user"] = user as AnyObject?
                values["platform"] = platform as AnyObject?
                values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
                
                print(values)
//                print("\nHTTP request: \(URL)\nParams: \(values.json())\n")

                
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
                                
                                var addresses = (PlistManager.sharedInstance.getValueForKey("user") as? NSDictionary)?.value(forKey: "addresses")as! NSMutableArray
                                let allCustIdsArray = addresses.value(forKey: "customerId") as! NSArray
                                print(allCustIdsArray)
                                // Subscribe to topics for in-app and cloud messaging
                                Messaging.messaging().subscribe(toTopic: PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String) { error in
                                    print("Subscribed to mobile number topic")
                                }
                                Messaging.messaging().subscribe(toTopic: self.selectedGender) { error in
                                    print("Subscribed to Gender topic")
                                }
                                Messaging.messaging().subscribe(toTopic: String(self.selectedAge.prefix(2))) { error in
                                    print("Subscribed to Age Group topic",String(self.selectedAge.prefix(2)))
                                }
                                
                                for individualCustomerId in allCustIdsArray{
                                    Messaging.messaging().subscribe(toTopic: individualCustomerId as! String) { error in
                                        print("Subscribed to Customer Id topic",individualCustomerId)
                                    }
                                }
                                
//                                  if(self.customerIDView.btnCustomerID.title(for: .normal)! == "Customer ID"){
                                
                                if ((self.iBaseCodeTextFieldView.iBaseTextField.text?.trim().count)! == 0) {
                                    let address = user ["addresses"] as! NSArray
                                    if(address.count>0){
//                                        let add: NSMutableDictionary = address.object(at: 0) as! NSMutableDictionary
                                        // address.object(at: 0) as! Dictionary<String, AnyObject>
                                       
//                                        let add = address.object(at: 0) as! Dictionary<String, AnyObject>
                                        
                                        
                                        let add = NSMutableDictionary(dictionary: address.object(at: 0) as! Dictionary<String, AnyObject>)
                                        


                                        add.setValue(result?.value(forKey: "customerId"), forKey: "customerId")
                                        addresses.add(add)
                                    }
                                    UserAddressesDatabaseModel.shareInstance.addUserAddress(PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String, addresses, active: result?.value(forKey: "customerId") as! String)
                                  }else{
                                    var allAddress = NSMutableArray()
                                    for id in addresses {
                                        if let aaa = id as? [String: Any], let customerId = aaa["customerId"] as? String {
                                            if(customerId == self.iBaseCodeTextFieldView.iBaseTextField.text){
                                                var address = aaa
                                                address["residentialConfiguration"] = self.selectedResConfig
                                                allAddress.add(address)
                                            }else{
                                                allAddress.add(aaa)
                                            }
                                        }
                                    }
                                    addresses = allAddress
                                    UserAddressesDatabaseModel.shareInstance.addUserAddress(PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String, allAddress, active: self.iBaseCodeTextFieldView.iBaseTextField.text!)
                                }
                                user["addresses"] = addresses.mutableCopy() as! NSArray
                                PlistManager.sharedInstance.saveValue(user as AnyObject, forKey: "user")
                            UserDetailsDatabaseModel.shareInstance.addUserDetails(PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String? ?? "", user as Dictionary<String, AnyObject>)
                                
                                PlistManager.sharedInstance.saveValue(true as AnyObject, forKey: "registered")
                                self.getEquipmentList()
                                let controller:RegisteredPopUpViewController = self.storyboard!.instantiateViewController(withIdentifier: "RegisteredPopUpView") as! RegisteredPopUpViewController
                                controller.view.frame = self.view.bounds;
                                controller.view.backgroundColor = UIColor(white: 0.1, alpha: 0.65)
                                controller.willMove(toParent: self)
                                self.view.addSubview(controller.view)
                                self.addChild(controller)
                                controller.didMove(toParent: self)
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
    
    func json() -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
            guard let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) else {
                print("Can't create string with data.")
                return "{}"
            }
            return jsonString
        } catch let parseError {
            print("json serialization error: \(parseError)")
            return "{}"
        }
    }
    
    @objc func checkPrimaryImage(_ sender: AnyObject) {
        let checkedImage = UIImage(named: "check_box")! as UIImage
        let uncheckedImage = UIImage(named: "uncheck_box")! as UIImage
        isChecked=false
        // Post a notification
        
        primaryNoCheckBoxButton.setImage(checkedImage, for: .normal)
        alternateNoCheckBoxButton.setImage(uncheckedImage, for: .normal)

        
    }
    
    @objc func checkAlternateImage(_ sender: AnyObject) {
        let checkedImage = UIImage(named: "check_box")! as UIImage
        let uncheckedImage = UIImage(named: "uncheck_box")! as UIImage
        
        // Post a notification
        
        isChecked = true
        primaryNoCheckBoxButton.setImage(uncheckedImage, for: .normal)
        alternateNoCheckBoxButton.setImage(checkedImage, for: .normal)

    }
    
    func validateFields() -> Bool {
        //var pin: String! = ""
        let alternateNumber = (alternateMobileNoTextField.textField.text?.trim())!
        let number = (alternateMobileNoTextField.textField.text?.trim())!
        let pinCode = (address1PincodeTextField.text?.trim())!
        if (selectedTitle.trim() == "" || selectedTitle.trim().count==0){
            DataManager.shareInstance.showAlert(self, title: invalidTitle, message: invalidTitleMessage)
            return false
        }
        if(firstNameTextField.textField.text?.trim() == "") {
            DataManager.shareInstance.showAlert(self, title: invalidFirstNameTitle, message: invalidFirstNameMessage)
            return false
        }
//        else if(firstNameTextField.textField.text?.trim() != "" && !containsOnlyLetters((firstNameTextField.textField.text?.trim())!)) {
//            DataManager.shareInstance.showAlert(self, title: invalidFirstNameTitle, message: invalidNameMessage)
//            return false
//        }
        else if(lastNameTextField.textField.text?.trim() == "") {
            DataManager.shareInstance.showAlert(self, title: invalidLastNameTitle, message: invalidLastNameMessage)
            return false
        }
        else if(genderTextField.text?.trim() == "") {
            DataManager.shareInstance.showAlert(self, title: invalidGenderTitle, message: invalidGenderMessage)
            return false
        }
        else if(ageGroupTextField.text?.trim() == "") {
            DataManager.shareInstance.showAlert(self, title: invalidAgeGroupTitle, message: invalidAgeGroupMessage)
            return false
        }
//        else if(Calendar.current.dateComponents([.hour, .minute], from: fromDate, to: toDate!).hour! < 1 && (fromAmPm == toAmPm)){
//            DataManager.shareInstance.showAlert(self, title: invaidDateTitle, message: invalidDateMessage)
//
//        }
//        else if(lastNameTextField.textField.text?.trim() != "" && !containsOnlyLetters((lastNameTextField.textField.text?.trim())!)) {
//            DataManager.shareInstance.showAlert(self, title: invalidLastNameTitle, message: invalidNameMessage)
//            return false
//        }
//        else if alternateMobileNoTextField.textField.text?.trim() != "" && (alternateNumber.characters.count < 10 || !alternateMobileNoTextField.isNumeric) {
//                    DataManager.shareInstance.showAlert(self, title: invalidAlternateNumberTitle, message: invalidAlternateNumberMessage)
//                    return false
//            }
        else if(self.isChecked==true){
            if (alternateMobileNoTextField.textField.text?.trim() != "" || alternateMobileNoTextField.textField.text?.trim() == ""){
                if(!number.isNumeric || alternateNumber.characters.count < 10) {
                    DataManager.shareInstance.showAlert(self, title: invalidAlternateNumberTitle, message: invalidAlternateNumberMessage)
                    return false
                }
            }
            
        }  else if(address1TextField.textView.text?.trim() == "") {
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
    
    func preFillAllFields(_ user: NSDictionary) {
        selectedTitle = (user["title"] as? String)?.getTitleForCode()
        if(selectedTitle == nil){
            selectedTitle = ""
        }
        titleTextField.textField.text = selectedTitle
        firstNameTextField.textField.text = user["firstName"] as? String
        lastNameTextField.textField.text = user["lastName"] as? String
        if let gender = user["gender"] as? String{
            selectedGender = gender
        }else{
            selectedGender = ""
        }
        genderTextField.text = selectedGender
        
        if let age = user["age"] as? String{
            if(ageGroups.contains(age)){
                selectedAge = age
            }else{
                selectedAge = ""
            }
            
        }else{
            selectedAge = ""
        }
        ageGroupTextField.text = selectedAge
        
//        firstNameTextField.textField.isEnabled = false
//        lastNameTextField.textField.isEnabled = false
//        emailTextField.textField.isEnabled = false
        
        firstNameTextField.textField.textColor = UIColor(netHex:0x000000)
        lastNameTextField.textField.textColor = UIColor(netHex:0x000000)
        emailTextField.textField.textColor = UIColor(netHex:0x000000)

        //        alternateMobileNoTextField.textField.text = user["alternatemobilenumber"] as? String
        let addresses = user["addresses"] as! NSArray
        for (_, value) in addresses.enumerated() {
            let address = value as! Dictionary<String, AnyObject>
//            if address["isPrimaryAddress"] as! String == "true" {
//                address1TextField.textView.text = address["address"] as? String
//                address1PincodeTextField.text = address["pinCode"] as? String
//                address1LocalityTextField.text = address["locality"] as? String
//                address1CityTextField.text = address["city"] as? String
//                address1StateTextField.text = address["state"] as? String
//            }
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
            
//            print(arrAllProducts)
//           // print(arrAllProducts[0])
//
//            var arr = [NSDictionary]()
//            for product in arrAllProducts {
//                var obj = product as! NSDictionary
//                print(obj)
//                arr.append(obj)
////                arr.addObject(obj)
//            }
//            print(arr)
            
//            var obj = ProductData()
//            obj = obj.parseResponseObject(productInfo as! NSDictionary) as! ProductData
            
//            self.productTokenField.tokens = arrProductIds
        }
        
        /*
         if let _ = user["securityQuestionId"] {
         var question: String! = ""
         let questionID = user["securityQuestionId"] as! String
         for value in securityQuestions {
         if value["id"] == questionID {
         question = value["question"]!
         }
         }
         questionTextField.textField.text = question
         }
         */
        // answerTextField.textField.text = user["securityQuestionAnswer"] as? String
        // pinTextField.textField.text = user["pin"] as? String
    }
    
    func containsOnlyLetters(_ input: String) -> Bool {
        for chr in input.characters {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                return false
            }
        }
        return true
    }
    
    @objc func updateProductSelection(_ notification:Notification)  {
        //if self.productTokenField != nil {
        self.view.endEditing(true)
        self.productTokenField.tokens = ProductBL.shareInstance.selectedProducts
        self.productTokenField.reloadTokeData()
        //}
    }
    
    func tokenViewTotalHeight(_ tokenViewSize: CGSize) {
        tokenViewheight = tokenViewSize.height+16
        productTokenField.frame = CGRect(x: 10, y: 10+70*11, width: contentView.frame.size.width-20,height: tokenViewheight)
        setContentSize()
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
    
    func serviceCallForiBaseInfo(_ iBaseNumber: String) {
        
        if NetworkChecker.isConnectedToNetwork() {
            var values: Dictionary<String, AnyObject> = [:]
            values["ibaseNumber"] = iBaseNumber as AnyObject?
            self.showPlaceHolderView()
            DataManager.shareInstance.getDataFromWebService(iBaseURL, dataDictionary:values as NSDictionary) { (result, error) -> Void in
                
                if error == nil {
                    DispatchQueue.main.async {
                        self.hidePlaceHolderView()
                        
                        if let responseDictionary: NSDictionary = result as? NSDictionary {
                            
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
                                                locality = address["locality"] as! String
                                                if locality.trim() != ""{
                                                    fullAddress = fullAddress + "\n" + locality
                                                }
                                            }
                                            
                                            if isNotNull(address.object(forKey: "pincode") as AnyObject?){
                                                pincode = address["pincode"] as! String
                                                fullAddress = fullAddress + "\n" + pincode
                                            }
                                            
                                            if isNotNull(address.object(forKey: "state") as AnyObject?){
                                                state = address["state"] as! String
                                                fullAddress = fullAddress + "\n" + state
                                            }
                                            
                                            let refreshAlert = UIAlertController(title: "Do you want this address.", message:fullAddress, preferredStyle: UIAlertController.Style.alert)
                                            
                                            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                                self.iBaseCodeTextFieldView.iBaseTextField.resignFirstResponder()
                                                self.address1TextField.textView.font = UIFont(name: fontQuicksandBookRegular, size: 16)!
                                                self.address1TextField.textView.textColor = UIColor.black
                                                self.address1TextField.textView.text = iBaseAddress
                                                
                                                self.address1CityTextField.text = city
                                                self.address1LocalityTextField.text = locality
                                                self.address1PincodeTextField.text = pincode
                                                self.address1StateTextField.text = state
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
                            }else{
                                DataManager.shareInstance.showAlert(self, title: errorTitle, message: errorMessage)
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
    func updateTextFieldsYcoordinate() {
        
        address1TextField.frame = CGRect(x: address1TextField.frame.origin.x, y: 35+70*9, width: address1TextField.bounds.size.width,height: address1TextField.bounds.size.height)
        
        addressLine2.frame = CGRect(x: addressLine2.frame.origin.x, y: 35+70*10, width: address1TextField.bounds.size.width,height: addressLine2.bounds.size.height)
        
        address1PincodeTextField.frame = CGRect(x: address1PincodeTextField.frame.origin.x, y: 35+70*11, width: address1PincodeTextField.bounds.size.width,height: address1PincodeTextField.bounds.size.height)
        address1LocalityTextField.frame = CGRect(x: address1LocalityTextField.frame.origin.x, y: 35+70*11, width: address1LocalityTextField.bounds.size.width,height: address1LocalityTextField.bounds.size.height)
        address1CityTextField.frame = CGRect(x: address1CityTextField.frame.origin.x, y: 35+70*12, width: address1CityTextField.frame.size.width,height: address1CityTextField.frame.size.height)
        
        address1StateTextField.frame = CGRect(x: address1StateTextField.frame.origin.x, y: 35+70*12, width: address1StateTextField.frame.size.width,height: address1StateTextField.frame.size.height)
        
        emailTextField.frame = CGRect(x: emailTextField.frame.origin.x, y: 35+70*13, width: emailTextField.frame.size.width,height: emailTextField.frame.size.height)
        
        print(chooseProductTextField.frame)
        chooseProductTextField.frame = CGRect(x: chooseProductTextField.frame.origin.x, y: 35+70*14, width: chooseProductTextField.frame.size.width,height: chooseProductTextField.frame.size.height)
        productTokenField.frame = CGRect(x: productTokenField.frame.origin.x, y: 30+70*15, width: productTokenField.frame.size.width,height: productTokenField.frame.size.height)
        buttonSubmit.frame = CGRect(x: 10, y: productTokenField.frame.origin.y+tokenViewheight, width: UIScreen.main.bounds.size.width-20, height: buttonSubmit.frame.size.height)
        //print(buttonSubmit.frame)
        
        scrollView.contentSize = CGSize(width: scrollView.bounds.size.width, height: 50+buttonSubmit.frame.origin.y+20)
        
        if isCompanyNameDisplayed {
            companyNameTextField.isHidden = false
            
        } else {
            companyNameTextField.isHidden = true
            
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
    
    @objc func clearAllTextFields() {
        if isCompanyNameDisplayed {
            companyNameTextField.removeFromSuperview()
            isCompanyNameDisplayed = false
//            updateTextFieldsYcoordinate()
        }
        resConfigTextField.removeFromSuperview()
        genderTextField.removeFromSuperview()
        ageGroupTextField.removeFromSuperview()
        iBaseCodeTextFieldView.removeFromSuperview()
        addressTypeView.removeFromSuperview()
    //    emailTextField.removeFromSuperview()
        address1TextField.removeFromSuperview()
        addressLine2.removeFromSuperview()
        address1PincodeTextField.removeFromSuperview()
        address1LocalityTextField.removeFromSuperview()
        address1CityTextField.removeFromSuperview()
        address1StateTextField.removeFromSuperview()
        
        addiBaseCodeTextField()
        setAddressTypeRadioButtons()
    //    setEmailTextField()
        setAdress1TextField()
        setAdressLine2TextField()
        setAdress1PincodeTextField()
        setAdress1LocalityTextField()
        setAdress1CityTextField()
        setAdress1StateTextField()
        setResConfigTextField()
        setGenderTextField()
        setAgeGroupTextField()
    }
    
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

