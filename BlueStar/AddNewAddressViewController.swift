//
//  AddNewAddressViewController.swift
//  BlueStar
//
//  Created by Tejas.kutal on 04/12/18.
//  Copyright © 2018 BlueStar. All rights reserved.
//

import UIKit
import FirebaseAnalytics
import Firebase

class AddNewAddressViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    
    var isIbaseValidated: Bool = false
    var iBaseCodeTextFieldView = iBaseView()//TextFieldwithInfoView()

    var addressTypeView = AddressTypeRadioBtns()
    var companyNameTextField : UITextField!
    var customerIDView = iBaseViewNew()
    var address1TextField = TextFieldwithInfoView()
    var addressLine2 = AddressLine2TextField()
    var address1PincodeTextField: UITextField!
    var address1LocalityTextField: UITextField!
    var address1CityTextField: UITextField!
    var address1StateTextField: UITextField!
    var emailTextField = TextFieldView()
    var pickerView = UIPickerView()
    var resConfigTextField : UITextField!
    var isCompanyNameDisplayed : Bool = false
    var selectedStateCode: String!
    var isAddressAutoFilled : Bool = false
    var isKeybordDisplayed : Bool = false
    var selectedResConfig: String!
    var editSelectedAdd: [String: Any] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        addiBaseCodeTextField() //this will be added in next version
        setAddressTypeRadioButtons()
        setResConfigTextField()
        setAdress1TextField()
        setAdressLine2TextField()
        setAdress1PincodeTextField()
        setAdress1LocalityTextField()
        setAdress1CityTextField()
        setAdress1StateTextField()
        // Do any additional setup after loading the view.
        
        let nc = NotificationCenter.default

        nc.addObserver(self, selector: #selector(addressSelected(_:)), name: NSNotification.Name(rawValue: "addressSelected"), object: nil)
        nc.addObserver(self, selector: #selector(clearAllTextFields), name: NSNotification.Name(rawValue: "clearAllTextFields"), object: nil)
        print(editSelectedAdd)
        if(editSelectedAdd.count > 0){
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addressSelected"), object: nil, userInfo: editSelectedAdd)
            iBaseCodeTextFieldView.isUserInteractionEnabled = false
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let screenClass = self.classForCoder.description()
        Analytics.setScreenName("Add New Address Screen", screenClass: screenClass)
        Analytics.logEvent("page_view",parameters: ["page":"Add New Address Screen"])
    }
    func addiBaseCodeTextField(){
        //        iBaseCodeTextField = setTextFieldwithInfo(&iBaseCodeTextField, placeholder: "iBase Number", leftImage: IMG_iBaseCode, isRightImage: false, rightImage: "", yAxis: 30+70*2)
        iBaseCodeTextFieldView = createiBaseNumberView(&iBaseCodeTextFieldView, yAxis: 30)
        scrollView.addSubview(iBaseCodeTextFieldView)
        iBaseCodeTextFieldView.iBaseTextField.delegate = self
        
        iBaseCodeTextFieldView.iBaseTextField.attributedPlaceholder = NSAttributedString(string:"Customer ID", attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(netHex:0x666666)]))

        let tap = UITapGestureRecognizer(target: self, action: #selector(showiBaseInfo))
        iBaseCodeTextFieldView.infoImageView.isUserInteractionEnabled = true
        iBaseCodeTextFieldView.infoImageView.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(btnCustomerIdAction))
        //        iBaseCodeTextFieldView.infoImageView.isUserInteractionEnabled = true
        iBaseCodeTextFieldView.btnCustomerID.addGestureRecognizer(tap2)
    }
    func createiBaseNumberView(_ textFieldView: inout iBaseView, yAxis: CGFloat) -> iBaseView {
        textFieldView = Bundle.main.loadNibNamed("iBaseView", owner: self, options: nil)?[0] as! iBaseView
        textFieldView.frame = CGRect(x: 10, y: yAxis, width: contentView.bounds.size.width-20,height: 70)
        //        textFieldView.iBaseButton.addTarget(self, action: #selector(iBaseButtonAction), for:.touchUpInside)
        return textFieldView
    }
    @objc func showiBaseInfo() {
        DataManager.shareInstance.showAlert(self, title: iBaseTitle, message: iBaseInfoMessage)
    }
    @objc func btnCustomerIdAction() {
        self.view.endEditing(true)
        let controller:RegisterAddressViewController = self.storyboard!.instantiateViewController(withIdentifier: "RegisterAddressView") as! RegisterAddressViewController
        
        //  controller.delegate = self as! registerAddressDelegate
        controller.addresses = UserAddressesDatabaseModel.shareInstance.getUserInactiveAddrress(PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String)
        controller.isComingFromDashbord = false
        controller.view.frame = self.view.bounds
        
//        if controller.addresses.count == 0 {
//            controller.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: 300)
//        }
        controller.view.backgroundColor = UIColor(white: 0.1, alpha: 0.65)
        controller.willMove(toParent: self)
        self.view.addSubview(controller.view)
        self.addChild(controller)
        controller.didMove(toParent: self)
    }
   
//    func setFirstNameTextField(){
//        //        firstNameTextField.label.frame.size.width=0
//        //        firstNameTextField.label.frame.size.height=0
//        //firstNameTextField.label = UILabel(frame: CGRect(0, 0, 0, 0))
//        //UIFont boldFont=[UIFont boldSystemFont(ofSize:[UIFont .systemFontSize])]
//        //UIFont boldFont=[UIFont ]
//        //        var attrs = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 15)]
//        //        var boldText  = "First Name *"
//        //        var boldString = NSAttributedString(string:boldText, attributes:attrs)
//        firstNameTextField = setTextField(&firstNameTextField, placeholder:"First Name *", leftImage: IMG_User, yAxis: 30)
//        //firstNameTextField = setTextField(&firstNameTextField, placeholder: "First Name *", leftImage: IMG_User, yAxis: 30)
//        self.view.addSubview(firstNameTextField)
//        firstNameTextField.textField.delegate = self
//    }
    
//    func setTextField(_ textFieldView: inout TextFieldView, placeholder: String, leftImage: String, yAxis: CGFloat) -> TextFieldView {
//        textFieldView = Bundle.main.loadNibNamed("TextFieldView", owner: self, options: nil)?[0] as! TextFieldView
//        textFieldView.frame = CGRect(x: 10, y: yAxis, width: self.view.bounds.size.width-20,height: 50)
//        textFieldView.leftImageView.image = UIImage(named: leftImage)
//        textFieldView.textFieldView.layer.borderColor = UIColor(netHex:0xDEDFE0).cgColor
//        textFieldView.label.backgroundColor = UIColor(netHex:0xDEDFE0)
//        textFieldView.textFieldView.layer.cornerRadius = 3.0
//        textFieldView.textFieldView.layer.borderWidth = 1.0
//        textFieldView.rightFirstImageView.isHidden = true
//        textFieldView.textField.textColor = UIColor(netHex:0x000000)
//        textFieldView.textField.font = UIFont(name: fontQuicksandBookRegular, size: 16)
//        if placeholder == "First Name *" || placeholder == "Last Name *" {
//            let loc: Int = placeholder.characters.count
//            var myMutableString = NSMutableAttributedString()
//            myMutableString = NSMutableAttributedString(string: placeholder as String, attributes: [NSForegroundColorAttributeName: UIColor(netHex:0x000000)])
//            myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange(location:loc-1,length:1))
//            myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: fontQuicksandBookBoldRegular, size: 16)!, range: NSRange(location:0,length:placeholder.characters.count))
//            textFieldView.textField.attributedPlaceholder = myMutableString
//            textFieldView.textField.autocapitalizationType = .words
//        } else {
//            var myMutableString = NSMutableAttributedString()
//            myMutableString = NSMutableAttributedString(string: placeholder as String, attributes: [NSForegroundColorAttributeName: UIColor(netHex:0x000000)])
//            myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: fontQuicksandBookBoldRegular, size: 16)!, range: NSRange(location:0,length:placeholder.characters.count))
//            textFieldView.textField.attributedPlaceholder = myMutableString
//        }
//        let paddingForFirst = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textFieldView.textField.frame.size.height))
//        textFieldView.textField.leftView = paddingForFirst
//        textFieldView.textField.leftViewMode = UITextFieldViewMode .always
//        textFieldView.textField.isUserInteractionEnabled = true
//        //        if textFieldView == alternateMobileNoTextField {
//        //            textFieldView.textField.keyboardType = .NumberPad
//        //        } else {
//        textFieldView.textField.keyboardType = .default
//        //        }
//        textFieldView.backgroundColor = UIColor.white
//        return textFieldView
//    }
   
    
    func setNavigationBar() {
        self.title = "Add New Address"
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
        rightButton.addTarget(self, action: #selector(saveUserData), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        
        //        iBaseButton.layer.borderWidth = 1.0
        //        iBaseButton.layer.borderColor = UIColor(netHex: 0x246cb0).cgColor
        //        iBaseButton.layer.cornerRadius = 5.0
    }
    @objc func moveBackToMyAccount() {
        navigationController?.popViewController(animated: true)
    }
    
//    func validateIbaseAndSaveAddressDirect(){
//        if((iBaseCodeTextFieldView.iBaseTextField.text?.trim()) != "" && ){
//            self.saveUserData()
//        }else if(!isIbaseValidated && (iBaseCodeTextFieldView.iBaseTextField.text?.trim()) != ""){
////            validateIbaseAndCallSave = true
////            self.iBaseButtonAction(iBaseButton)
//        }else{
//            self.saveUserData()
//        }
//    }
//
    func setAddressTypeRadioButtons() {
        //        Bundle.mainBundle().loadNibNamed("SomeView", owner: self, options: nil)
        //        scrollView.addSubview(self.view);
        
        addressTypeView = Bundle.main.loadNibNamed("AddressTypeRadioBtns", owner: self, options: nil)?[0] as! AddressTypeRadioBtns
        addressTypeView.frame = CGRect(x: 0, y: 30+70, width: contentView.frame.size.width,height: 50);
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
                setResConfigTextField()
                companyNameTextField.removeFromSuperview()
//                updateTextFieldsYcoordinate()
                
            }
        } else {
            resConfigTextField.removeFromSuperview()
            setCompanyNameTextField()
        }
        print("Button Pressed")
    }
    func setResConfigTextField() {
        
        resConfigTextField = createAddressTextFields(&resConfigTextField, placeholder: "BHK - Bedroom Hall Kitchen *", xAxis:10, yAxis: 30+70*2)
        pickerView = UIPickerView()
        pickerView.tag = 6
//        pickerView.dataSource = self as? UIPickerViewDataSource
        pickerView.delegate = self
        resConfigTextField.text = ""
        selectedResConfig = ""
        resConfigTextField.inputView = pickerView
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
    func setCompanyNameTextField() {
        companyNameTextField = createAddressTextFields(&companyNameTextField, placeholder: "Company Name *", xAxis:10, yAxis: 30+70*2)
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
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location:loc-1,length:1))
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
        }
        else if placeholder == "Pincode *" {
            textField.keyboardType = .numberPad
        }
        else if placeholder == "Company Name *" {
            textField.frame = CGRect(x: 10, y: yAxis, width: view.bounds.size.width-20,height: 50)
        }
        else if placeholder == "Address Line 2 " {
            textField.frame = CGRect(x: 10, y: yAxis, width: view.bounds.size.width-20,height: 50)
        }else if placeholder == "BHK - Bedroom Hall Kitchen *" {
            textField.frame = CGRect(x: 10, y: yAxis, width: view.bounds.size.width-20,height: 50)
        }
        return textField
    }
    @objc func titleDoneTapped(){
        resConfigTextField.text = selectedResConfig
        resConfigTextField.resignFirstResponder()
    }
    @objc func titleCancelTapped(){
        selectedResConfig = resConfigTextField.text
        resConfigTextField.resignFirstResponder()
    }
    
    @objc func editState() {
        address1StateTextField.becomeFirstResponder()
    }
    
    func setAdress1TextField()  {
        address1TextField = setTextFieldwithInfo(&address1TextField, placeholder: "Address Line 1 *", leftImage: IMG_Address, isRightImage: false, rightImage: "", yAxis: 35+70*3)
        
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
        
        addressLine2 = setAddressLine2TextField(&addressLine2, placeholder: "Address Line 2 ", leftImage: IMG_Address, isRightImage: false, rightImage: "", yAxis: 35+70*4)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showAddress2Info))
        addressLine2.rightSecondImageView.isUserInteractionEnabled = true
        addressLine2.rightSecondImageView.addGestureRecognizer(tap)
        
        //            createAddressTextFields(&address1LocalityTextField, placeholder: "Address Line 2 ", xAxis:10, yAxis: 55+70*7)
        scrollView.addSubview(addressLine2)
        addressLine2.textView.delegate = self
        
    }
    
    func setAdress1PincodeTextField(){
        address1PincodeTextField = createAddressTextFields(&address1PincodeTextField, placeholder: "Pincode *", xAxis: view.bounds.size.width/2+5, yAxis: 35+70*5)
        scrollView.addSubview(address1PincodeTextField)
        address1PincodeTextField.delegate = self
    }
    
    func setAdress1LocalityTextField(){
        address1LocalityTextField = createAddressTextFields(&address1LocalityTextField, placeholder: "Landmark ", xAxis:10, yAxis: 35+70*5)
        scrollView.addSubview(address1LocalityTextField)
        address1LocalityTextField.delegate = self
    }
    
    func setAdress1CityTextField(){
        address1CityTextField = createAddressTextFields(&address1CityTextField, placeholder: "City *", xAxis: 10, yAxis: 35+70*6)
        scrollView.addSubview(address1CityTextField)
        address1CityTextField.delegate = self
    }
    
    func setAdress1StateTextField(){
        address1StateTextField = createAddressTextFields(&address1StateTextField, placeholder: "State *", xAxis: view.bounds.size.width/2+5, yAxis: 35+70*6, preventPaste: true)
        
        let pickerView = UIPickerView()
        pickerView.tag = 1
//        pickerView.dataSource = self as! UIPickerViewDataSource
        pickerView.delegate = self
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
    }
  
    
    func setTextFieldwithInfo(_ textFieldView: inout TextFieldwithInfoView, placeholder: String, leftImage: String, isRightImage: Bool, rightImage: String, yAxis: CGFloat) -> TextFieldwithInfoView {
        
        textFieldView = Bundle.main.loadNibNamed("TextFieldwithInfoView", owner: self, options: nil)?[0] as! TextFieldwithInfoView
        if placeholder == "Address Line 1 *" {
            textFieldView.frame = CGRect(x: 10, y: yAxis, width: contentView.bounds.size.width-20,height: 75)
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
    func setTextField(_ textFieldView: inout TextFieldView, placeholder: String, leftImage: String, yAxis: CGFloat) -> TextFieldView {
        textFieldView = Bundle.main.loadNibNamed("TextFieldView", owner: self, options: nil)?[0] as! TextFieldView
        textFieldView.frame = CGRect(x: 10, y: yAxis, width: self.view.bounds.size.width-20,height: 50)
        textFieldView.leftImageView.image = UIImage(named: leftImage)
        textFieldView.textFieldView.layer.borderColor = UIColor(netHex:0xDEDFE0).cgColor
        textFieldView.label.backgroundColor = UIColor(netHex:0xDEDFE0)
        textFieldView.textFieldView.layer.cornerRadius = 3.0
        textFieldView.textFieldView.layer.borderWidth = 1.0
        textFieldView.rightFirstImageView.isHidden = true
        textFieldView.textField.textColor = UIColor(netHex:0x000000)
        textFieldView.textField.font = UIFont(name: fontQuicksandBookRegular, size: 16)
        if placeholder == "First Name *" || placeholder == "Last Name *" {
            let loc: Int = placeholder.characters.count
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: placeholder as String, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(netHex:0x000000)]))
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location:loc-1,length:1))
            myMutableString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: fontQuicksandBookBoldRegular, size: 16)!, range: NSRange(location:0,length:placeholder.characters.count))
            textFieldView.textField.attributedPlaceholder = myMutableString
            textFieldView.textField.autocapitalizationType = .words
        } else {
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: placeholder as String, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(netHex:0x000000)]))
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

    @objc func showAddressInfo() {
        DataManager.shareInstance.showAlert(self, title: addressTitle, message: addressInfoMessage)
    }
    
    @objc func showAddress2Info() {
        DataManager.shareInstance.showAlert(self, title: addressTitle, message: address2InfoMessage)
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
        textFieldView.textView.tag = 1002

        
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return states.count
        } else if pickerView.tag == 2 {
            return securityQuestions.count
        }else if pickerView.tag == 6 {
            return resConfigs.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        if pickerView.tag == 1 {
            pickerLabel.text = states[row]
            pickerLabel.font = UIFont(name: fontQuicksandBookRegular, size: 15)
            pickerLabel.textAlignment = NSTextAlignment.center
        } else if pickerView.tag == 2 {
            let data = securityQuestions[row]
            pickerLabel.text = data["question"]
            pickerLabel.font = UIFont(name: fontQuicksandBookRegular, size: 15)
            pickerLabel.textAlignment = NSTextAlignment.center
        } else if pickerView.tag == 6 {
            pickerLabel.text = resConfigs[row]
            pickerLabel.font = UIFont(name: fontQuicksandBookRegular, size: 15)
            pickerLabel.textAlignment = NSTextAlignment.center
        }
        pickerLabel.textColor = .black
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
        }else if pickerView.tag == 6 {
            selectedResConfig = resConfigs[row]
        }
      //  self.view.frame.origin.y = 0
    }
    
    @objc func addressSelected(_ notification: NSNotification) {
        if let addr = notification.userInfo! as NSDictionary? {
            print(addr)
            
            if let index = statesCode.index(of: (addr.value(forKey: "state") as! String)) {
                self.address1StateTextField.text = states[index]
            }
            
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
            
            //  customerIDView.btnCustomerID.setTitle(addr["customerId"] as? String, for: .normal)
            self.address1TextField.textView.font = UIFont(name: fontQuicksandBookRegular, size: 16)!
            self.address1TextField.textView.textColor = UIColor.black
            self.address1TextField.textView.text = addr.value(forKey: "address1") as! String
            self.addressLine2.textView.font = UIFont(name: fontQuicksandBookRegular, size: 16)!
            self.addressLine2.textView.textColor = UIColor.black
            
            if let local = (addr.value(forKey: "address2") as? String){
                self.addressLine2.textView.text = local
            }else{
                self.addressLine2.textView.text = ""
            }
            self.address1CityTextField.text = (addr.value(forKey: "city") as! String)
            if let local = (addr.value(forKey: "locality") as? String){
                 self.address1LocalityTextField.text = local
            }else{
                 self.address1LocalityTextField.text = ""
            }
           
            self.address1PincodeTextField.text = (addr.value(forKey: "pinCode") as! String)
         
            self.iBaseCodeTextFieldView.iBaseTextField.text = addr["customerId"] as! String
            isAddressAutoFilled = true
            disableTextFieldToEnterAddress()
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
    
    
    @objc func clearAllTextFields() {
        isAddressAutoFilled = false
        if isCompanyNameDisplayed {
            companyNameTextField.removeFromSuperview()
            isCompanyNameDisplayed = false
//            updateTextFieldsYcoordinate()
        }
        resConfigTextField.removeFromSuperview()
        iBaseCodeTextFieldView.removeFromSuperview()
        addressTypeView.removeFromSuperview()
        address1TextField.removeFromSuperview()
        addressLine2.removeFromSuperview()
        address1PincodeTextField.removeFromSuperview()
        address1LocalityTextField.removeFromSuperview()
        address1CityTextField.removeFromSuperview()
        address1StateTextField.removeFromSuperview()
        
        addiBaseCodeTextField()
        setAddressTypeRadioButtons()
        setResConfigTextField()
        setAdress1TextField()
        setAdressLine2TextField()
        setAdress1PincodeTextField()
        setAdress1LocalityTextField()
        setAdress1CityTextField()
        setAdress1StateTextField()
    }
    
    //MARK:- UITextView Delegate Methods
    func findSelectedIndexFor(picker pickerView: UIPickerView, selectedValue: inout String,from: [String]){
        if(selectedValue.characters.count > 0){
            pickerView.selectRow(from.index(of:selectedValue)!, inComponent: 0, animated: true)
        }else{
            pickerView.selectRow(0, inComponent: 0, animated: true)
            selectedValue = from[0]
        }
        pickerView.reloadAllComponents()
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if isAddressAutoFilled {
            //            clearAllTextFields()
            isAddressAutoFilled = false
            address1TextField.textView.isUserInteractionEnabled = false
            addressLine2.textView.isUserInteractionEnabled = false
            
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if(textView == address1TextField.textView){
            iBaseCodeTextFieldView.iBaseTextField.text = ""
        }
        if textView.font == UIFont(name: fontQuicksandBookBoldRegular, size: 16) {
            
            var word:String = ""
            word.append(textView.text.characters.last!)
            
            textView.text = word
            textView.font = UIFont(name: fontQuicksandBookRegular, size: 16)!
            textView.textColor = UIColor.black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
     
        //textView.scrollRangeToVisible(range)
    
        if((textView.tag == 1001 || textView.tag == 1002) && text == "\n")
        {
            self.view.endEditing(true)
            return false
        }
        else
        {
            return numberOfChars < 40;
        }
    }
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
//        if isAddressAutoFilled {
//            clearAllTextFields()
//            isAddressAutoFilled = false
//        }
        
        if (textView.text == "Address Line 1 *" || textView.text == "Address Line 2 " ) {
            textView.text = ""
            textView.textColor = UIColor.black
            textView.font = UIFont(name: fontQuicksandBookRegular, size: 16)!
        }
        //        if textView.font == UIFont(name: fontQuicksandBookBoldRegular, size: 16) {
        //
        //            textView.text = ""
        //            textView.font = UIFont(name: fontQuicksandBookRegular, size: 16)!
        //        }
        //
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if isAddressAutoFilled {
            //  clearAllTextFields()
            isAddressAutoFilled = false
            address1TextField.textView.isUserInteractionEnabled = false
            addressLine2.textView.isUserInteractionEnabled = false
            address1PincodeTextField.isEnabled = false
        }
        if(textField.placeholder == "BHK - Bedroom Hall Kitchen *"){
            findSelectedIndexFor(picker: pickerView, selectedValue: &selectedResConfig, from: resConfigs)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if(textField == address1PincodeTextField) {
            let maxLength = 6
            //   iBaseCodeTextFieldView.iBaseTextField.text = ""
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            
            if newLength==maxLength {
                
                let stringPinCode = address1PincodeTextField.text! + string as String
                mapmyindiaTokenGeneration(stringPinCode)
            }
            return newLength <= maxLength
        }
        return true

    }
    
    @objc func saveUserData() {
//        if(iBaseCodeTextFieldView.iBaseTextField.text != "Customer Id"){
            if ((iBaseCodeTextFieldView.iBaseTextField.text?.trim().count)! > 0) {
            // selectedAddress
            // update res config
//                let userData = PlistManager.sharedInstance.getValueForKey("user") as? NSDictionary
                
                /*UserAddressesDatabaseModel.shareInstance.UpdateAddressAsActive(for: PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String, forCustomerId: iBaseCodeTextFieldView.iBaseTextField.text!)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "updateAddresses"), object: nil)
                //self.dismiss(animated: true, completion: nil)
                navigationController?.popViewController(animated: true)
                
                return*/
                
                
                var selectedAdd: [String: Any] = [:]
                var allAdds : NSMutableArray = UserAddressesDatabaseModel.shareInstance.getUserInactiveAddrress(PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String).mutableCopy() as! NSMutableArray
                
                for id in allAdds {
                    if let aaa = id as? [String: Any], let customerId = aaa["customerId"] as? String {
                        if(customerId == iBaseCodeTextFieldView.iBaseTextField.text){
                            selectedAdd = aaa
                            break
                        }
                    }
                }
                
                if(editSelectedAdd.count > 0 && editSelectedAdd["subTypeCode"] as! String == "Residential"){
                    if(selectedResConfig.count <= 0){
                        DataManager.shareInstance.showAlert(self, title: invalidResidentialConfigurationTitle, message: invalidResidentialMessage)
                    }else{
                        editSelectedAdd["residentialConfiguration"] = selectedResConfig
                        var arr : NSMutableArray = []
                        arr.add(editSelectedAdd)
                        //                    user["addresses"] = arr
                        callRegisterApi(addressToUpdate: arr)
                    }
                }
        else if(selectedAdd["subTypeCode"] as! String == "Residential"){
            if let ress = selectedAdd["residentialConfiguration"] as? String {
                if (ress.count <= 0){
                    selectedAdd["residentialConfiguration"] = selectedResConfig
                    var arr : NSMutableArray = []
                    arr.add(selectedAdd)
//                    user["addresses"] = arr
                    callRegisterApi(addressToUpdate: arr)
                }else{
//                    .. check resconf
                    if(resConfigs.contains(ress)){
                        UserAddressesDatabaseModel.shareInstance.UpdateAddressAsActive(for: PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String, forCustomerId: iBaseCodeTextFieldView.iBaseTextField.text!)
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "updateAddresses"), object: nil)
                        //self.dismiss(animated: true, completion: nil)
                        navigationController?.popViewController(animated: true)
                    }else{
                        selectedAdd["residentialConfiguration"] = selectedResConfig
                        var arr : NSMutableArray = []
                        arr.add(selectedAdd)
                        //                    user["addresses"] = arr
                        callRegisterApi(addressToUpdate: arr)
                    }
                    
                }
            }else{
                if(selectedResConfig.count <= 0){
                    DataManager.shareInstance.showAlert(self, title: invalidResidentialConfigurationTitle, message: invalidResidentialMessage)
                }else{
                    selectedAdd["residentialConfiguration"] = selectedResConfig
                    var arr : NSMutableArray = []
                    arr.add(selectedAdd)
                    callRegisterApi(addressToUpdate: arr)
                }
                
            }
            
        }
                else if(selectedAdd["subTypeCode"] as! String == "Commercial"){
                    UserAddressesDatabaseModel.shareInstance.UpdateAddressAsActive(for: PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String, forCustomerId: iBaseCodeTextFieldView.iBaseTextField.text!)
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "updateAddresses"), object: nil)
                    //self.dismiss(animated: true, completion: nil)
                    navigationController?.popViewController(animated: true)
                }
                
            
        }else{
                self.callRegisterApi(addressToUpdate: [])
        }
    }
    
    
    func callRegisterApi(addressToUpdate address:NSMutableArray){
        self.view.endEditing(true)
        if NetworkChecker.isConnectedToNetwork() {
            if validateFields() {
                showPlaceHolderView()
                
                var userType: String
                var company: String
                if addressTypeView.btnResidential.isSelected {
                    userType = "Residential"
                    company = ""

                } else {
                    userType = "Commercial"
                    company = (companyNameTextField.text?.trim())! 

                }
                
                var values: Dictionary<String, AnyObject> = [:]
                var user: Dictionary<String, AnyObject> = PlistManager.sharedInstance.getValueForKey("user") as! Dictionary<String, AnyObject>
                print("===========================//////////=================")
                print(PlistManager.sharedInstance.getValueForKey("user"))
                user .removeValue(forKey: "ibaseNumber")
                user .removeValue(forKey: "pin")
                user .removeValue(forKey: "preferedCallingNumber")
                user .removeValue(forKey: "alternateNoPreference")
                user .removeValue(forKey: "alternatemobilenumber")
                
                let addresses: NSMutableArray = []
                //= user["addresses"] as! NSMutableArray
                
                var addressLine2Text : String
                if addressLine2.textView.text?.trim() == "Address Line 2" {
                    addressLine2Text = ""
                } else {
                    addressLine2Text = (addressLine2.textView.text?.trim())!
                }
                
                var newAddress = ["address1":(address1TextField.textView.text?.trim())!,
                                  "address2" : addressLine2Text,
                                  "locality":(address1LocalityTextField.text?.trim())!,
                                  "city":(address1CityTextField.text?.trim())!,
                                  "state": selectedStateCode,
                                  "pinCode":(address1PincodeTextField.text?.trim())!,
                                  //  "ibaseno":(iBaseTextField.text?.trim())!,
                    "subTypeCode" : userType,
                    "companyName" : company,
                    "residentialConfiguration":selectedResConfig]
                //                                  "isPrimaryAddress":primary]
                
//                if ((self.navigationBarTitle == "Edit Address")) {
//
//                    addresses.replaceObject(at:addressTag , with: newAddress)
//                    //                    if newAddress["isPrimaryAddress"]!! == "true"{
//                    //                        if((self.iBaseTextField.text!.trim()) != "" ) {
//                    //                            user["ibaseNumber"] = self.iBaseTextField.text as AnyObject?
//                    //                        }else{
//                    //                            user["ibaseNumber"] = (self.iBaseTextField.text?.trim())! as AnyObject?
//                    //                        }
//                    //                    }
//                } else {
                    //                    if(addresses.value(forKey != newAddress["ibaseno"]){
                    addresses.add(newAddress)
                    //                    }
                    //                    else{
                    //                        DataManager.shareInstance.showAlert(self, title: messageTitle, message: "IBase no. is already exist")
                    //                    }
                    //
                
//                }
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
                if(address != nil && address.count > 0){
                    user["addresses"] = address
                }else{
                    addresses.add(newAddress)
                    user["addresses"] = addresses
                }
                
                values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
                values["user"] = user as AnyObject?
                values["platform"] = platform as AnyObject?
                values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
                //      values["ibaseno"] = iBaseTextField.text?.trim() as AnyObject?
                
                if(iBaseCodeTextFieldView.iBaseTextField.placeholder == "Customer ID"){
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
                                    var custID = ""
                                    for id in addressesList {
                                        if let aaa = id as? [String: Any], let customerId = aaa["customerId"] as? String {
                                            custID = customerId
                                        }
                                    }
                                    if(custID.count > 0){
//                                        UserAddressesDatabaseModel.shareInstance.UpdateAddressAsInActive(for: PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String, forCustomerId: custID)
//                                        let whereStr = "%\"customerId\":\"" + custID + "\"%"
                                        let whereStr = """
                                            %"customerId":"
                                            """
                                        let quoteStr = """
                                            "
                                            """
                                        let str = whereStr + custID + quoteStr
                                        print(str + str.replacingOccurrences(of: "\n", with: ""))
                                        let older = UserAddressesDatabaseModel.shareInstance.getUserAddrressToUpdate(PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String, (custID))
                                        print(older)
                                        if(older.count > 0){
                                            let idd = older.lastObject;
                                            print("Updating", addressesList , idd)
                                            UserAddressesDatabaseModel.shareInstance.UserAddrressToUpdate(PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String, idd as! String, addressesList.lastObject)
                                            if(self.editSelectedAdd.count == 0){
                                                UserAddressesDatabaseModel.shareInstance.UpdateAddressAsActive(for: PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String, forCustomerId: self.iBaseCodeTextFieldView.iBaseTextField.text!)
                                                NotificationCenter.default.post(name: Notification.Name(rawValue: "updateAddresses"), object: nil)
                                                //self.dismiss(animated: true, completion: nil)
                                                self.navigationController?.popViewController(animated: true)
                                                return
                                            }
                                        }
                                        
                                    }
                                    else{
                                        
                                        // Subscribe to new customer id
                                        
                                        if let customerId = result?.value(forKey: "customerId"){
                                            Messaging.messaging().subscribe(toTopic: customerId as! String) { error in
                                                print("Subscribed to new Customer Id topic")
                                            }
                                            newAddress["customerId"] = result?.value(forKey: "customerId") as! String
                                            addressesList.add(newAddress)
                                        }
                                        user["addresses"] = addressesList
                                    
                                    
                                    
                                    PlistManager.sharedInstance.saveValue(user as AnyObject, forKey: "user")
                                    //UserAddressesDatabaseModel.shareInstance.addUserAddress(PlistManager.sharedInstance.getValueForKey("mobileNumber"), <#T##addresses: NSArray##NSArray#>, active: <#T##String#>)
                                    UserAddressesDatabaseModel.shareInstance.addNewAddressFor(PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String, address: newAddress as NSDictionary)
                                        
                                    }
                                    
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
        let pinCode = (address1PincodeTextField.text?.trim())!

        if isCompanyNameDisplayed {
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
        else if(address1TextField.textView.text?.trim() == "") {
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
            
        else if address1CityTextField.text?.trim() == "" {
            DataManager.shareInstance.showAlert(self, title: invalidCityTitle, message: invalidCityMessage)
            return false
        } else if pinCode == "" {
            DataManager.shareInstance.showAlert(self, title: invalidPincodeTitle, message: invalidPincodeMessage)
            return false
        } else if pinCode.count != 6 {
            DataManager.shareInstance.showAlert(self, title: invalidPincodeTitle, message: invalidPincodeMessage)
            return false
        } else if !pinCode.isNumeric {
            DataManager.shareInstance.showAlert(self, title: invalidPincodeTitle, message: invalidPincodeMessage)
        } else if address1StateTextField.text?.trim() == "" {
            DataManager.shareInstance.showAlert(self, title: invalidStateTitle, message: invalidStateMessage)
            return false
        } 
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
    
    func mapmyindiaTokenGeneration(_ pinCodeNumber: String) {
        let tokenGenerationURL = "https://outpost.mapmyindia.com/api/security/oauth/token?grant_type=client_credentials&client_id=-FBFRUYrXVO_Jb_JI8Z3OnA2uuulesfotFXsztwvFUr4qguYErn_Vg==&client_secret=Pt4sF8w2-heAYpFxAdjVbPKOvUSB2fHttaIDjMnK-iDC1TEmALdRFEoS8n5Zxy2H"
        
        let emptydict: Dictionary<String, Any> = [:]
        var tokencode = String()
        DataManager.shareInstance.postRequest(urlString: tokenGenerationURL, parameters: emptydict){ (result, error) -> Void in

            if error == nil {
                DispatchQueue.main.async {
                    if let responseDictionary: NSDictionary = result as? NSDictionary {
                        tokencode = responseDictionary.value(forKey: "access_token") as! String
                        self.serviceCallForGetCityAndStateFromPincode(pinCodeNumber, tokencode: tokencode)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    if error?.code != -999 {
                        DataManager.shareInstance.showAlert(self, title: (error?.domain)!, message: (error?.localizedDescription)!)
                    }
                }
            }

        }
    }
    
    
    func serviceCallForGetCityAndStateFromPincode(_ pinCodeNumber: String, tokencode: String) {
        
        if NetworkChecker.isConnectedToNetwork() {
            
            let values: Dictionary<String, AnyObject> = [:]
            
            let queryItems = [URLQueryItem(name: "access_token", value: tokencode)]
            var urlComps = URLComponents(string: "https://explore.mapmyindia.com/apis/O2O/entity/" + pinCodeNumber)!
            urlComps.queryItems = queryItems

            let mapMyIndiaURL = urlComps.string!
            
            DataManager.shareInstance.getRequest(urlString: mapMyIndiaURL){ (result, error) -> Void in

                if error == nil {

                    DispatchQueue.main.async {

                        if let localAddress: NSDictionary = result as? NSDictionary {

                            let newCity = localAddress.value(forKey: "city") as! String?
                                let newState = localAddress.value(forKey: "state") as! String?


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
//                            }
                        }
                    }
                }
            }
        }
        else {
            
            DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
        }
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
