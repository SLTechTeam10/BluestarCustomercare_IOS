//
//  ViewController.swift
//  BlueStar
//
//  Created by tarun.kapil on 18/07/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit
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


class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var welcomeView: UIView!
    @IBOutlet weak var goButton: UIButton!
    
    var chooseCountryTextField = TextFieldView()
    var mobileNumberTextField = LoginTextField()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  setChooseCountryTextField()
        //mobileNumberTextField()
        setMobileNumberTextField()
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(showRegistrationView), name: NSNotification.Name(rawValue: "showRegistrationView"), object: nil)
        nc.addObserver(self, selector: #selector(showAlreadyRegisteredView), name: NSNotification.Name(rawValue: "showAlreadyRegisteredView"), object: nil)
        
//        mobileNumberTextField.textField.text = "8469742111"
        
        //showRegistrationView()
        assignBackground()
//        self.mobileNumberTextField.textField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let screenClass = self.classForCoder.description()
        Analytics.setScreenName("Login Screen", screenClass: screenClass)
        Analytics.logEvent("page_view",parameters: ["page":"Login Screen"])
    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        DispatchQueue.main.async {
//            self.mobileNumberTextField.textField.becomeFirstResponder()
//        }
//        
//    }
  
    
    override func viewDidLayoutSubviews() {
        goButton.setPreferences()
        goButton.frame = CGRect(x: 10, y: (UIScreen.main.bounds.size.height/2)-90+70 , width: UIScreen.main.bounds.size.width-20,height: 50)
    }
    
    func assignBackground() {
        let background = UIImage(named: IMG_Welcome)
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    //    func setChooseCountryTextField(){
    //        chooseCountryTextField = Bundle.main.loadNibNamed("TextFieldView", owner: self, options: nil)?[0] as! TextFieldView
    //        chooseCountryTextField.frame = CGRect(x: 10, y: (UIScreen.main.bounds.size.height/2)-90 , width: UIScreen.main.bounds.size.width-20,height: 50)
    //        chooseCountryTextField.leftImageView.image = UIImage(named: IMG_Country)
    //        chooseCountryTextField.textFieldView.layer.borderColor = UIColor(netHex:0xDEDFE0).cgColor
    //        chooseCountryTextField.label.backgroundColor = UIColor(netHex:0xDEDFE0)
    //        chooseCountryTextField.textFieldView.layer.cornerRadius = 3.0
    //        chooseCountryTextField.textFieldView.layer.borderWidth = 1.0
    //        chooseCountryTextField.rightFirstImageView.isHidden = true
    ////        chooseCountryTextField.rightFirstImageView.image = UIImage(named: IMG_DownArrow)
    //        chooseCountryTextField.textField.textColor = UIColor(netHex:0x666666)
    //        chooseCountryTextField.textField.font = UIFont(name: fontQuicksandBookRegular, size: 16)
    //        chooseCountryTextField.textField.attributedPlaceholder = NSAttributedString(string:"Choose Country", attributes:[NSForegroundColorAttributeName: UIColor(netHex:0x666666)])
    //        let paddingForFirst = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: chooseCountryTextField.textField.frame.size.height))
    //        chooseCountryTextField.textField.leftView = paddingForFirst
    //        chooseCountryTextField.textField.leftViewMode = UITextFieldViewMode .always
    //        chooseCountryTextField.textField.isUserInteractionEnabled = true
    //        chooseCountryTextField.textFieldView.backgroundColor = UIColor(netHex: 0xF5F5F5)
    //        chooseCountryTextField.textField.text = "India (+91)"
    //        chooseCountryTextField.textField.isUserInteractionEnabled = false
    //        view.addSubview(chooseCountryTextField)
    //        let pickerView = UIPickerView()
    //        pickerView.delegate = self
    //        chooseCountryTextField.textField.inputView = pickerView
    //        let toolBar = UIToolbar()
    //        toolBar.barStyle = UIBarStyle.default
    //        toolBar.isTranslucent = true
    //        toolBar.tintColor = UIColor(netHex:0x4F90D9)
    //        toolBar.sizeToFit()
    //        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ViewController.TextFieldTapped))
    //        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
    //        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ViewController.TextFieldTapped))
    //        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
    //        toolBar.isUserInteractionEnabled = true
    //        chooseCountryTextField.textField.inputAccessoryView = toolBar
    //
    ////        let arrowTap = UITapGestureRecognizer(target: self, action: #selector(editQuestion))
    ////        chooseCountryTextField.rightFirstImageView.userInteractionEnabled = true
    ////        chooseCountryTextField.rightFirstImageView.addGestureRecognizer(arrowTap)
    //
    //        chooseCountryTextField.textField.delegate = self
    //    }
    
    func setMobileNumberTextField(){
        mobileNumberTextField = Bundle.main.loadNibNamed("LoginTextField", owner: self, options: nil)?[0] as! LoginTextField
        mobileNumberTextField.frame = CGRect(x: 10, y: (UIScreen.main.bounds.size.height/2)-90 , width: UIScreen.main.bounds.size.width-20,height: 50)
        mobileNumberTextField.leftImageView.image = UIImage(named: IMG_Mobile)
        mobileNumberTextField.textFieldView.layer.borderColor = UIColor(netHex:0xDEDFE0).cgColor
        mobileNumberTextField.label.backgroundColor = UIColor.white
        //mobileNumberTextField.label.frame = CGRect(x: 37, y: 0, width: 40, height: 50)
        mobileNumberTextField.label.text="+91"
        mobileNumberTextField.label.font = UIFont(name: fontQuicksandBookRegular, size: 16)
        
        mobileNumberTextField.textFieldView.layer.cornerRadius = 3.0
        mobileNumberTextField.textFieldView.layer.borderWidth = 1.0
        //mobileNumberTextField.rightFirstImageView.isHidden = true
        mobileNumberTextField.textField.textColor = UIColor(netHex:0x666666)
        mobileNumberTextField.textField.font = UIFont(name: fontQuicksandBookRegular, size: 16)
        mobileNumberTextField.textField.attributedPlaceholder = NSAttributedString(string:"Enter Your Mobile No", attributes:convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(netHex:0x666666)]))
        let paddingForFirst = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: mobileNumberTextField.textField.frame.size.height))
        mobileNumberTextField.textField.leftView = paddingForFirst
        mobileNumberTextField.textField.leftViewMode = UITextField.ViewMode .always
        mobileNumberTextField.textField.isUserInteractionEnabled = true
        mobileNumberTextField.textField.keyboardType = .numberPad
        mobileNumberTextField.backgroundColor = UIColor.white
//        mobileNumberTextField.textField.text = "8087603494"
        view.addSubview(mobileNumberTextField)
        mobileNumberTextField.textField.delegate = self
       
    }
    
    func editQuestion() {
        chooseCountryTextField.textField.becomeFirstResponder()
    }
    
    func TextFieldTapped(){
        chooseCountryTextField.textField.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chooseCountryTextField.textField.text = countries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.text = countries[row]
        pickerLabel.font = UIFont(name: fontQuicksandBookRegular, size: 15)
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 10
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
    
    @IBAction func goButtonAction(_ sender: AnyObject) {
        self.view.endEditing(true)
        
//        let controller:RegistrationViewController = self.storyboard!.instantiateViewController(withIdentifier: "RegistrationView") as! RegistrationViewController
//        controller.view.frame = self.view.bounds;
//        controller.willMove(toParent: self)
//        self.view.addSubview(controller.view)
//        self.addChild(controller)
//        controller.didMove(toParent: self)
        
       // UserAddressesDatabaseModel.shareInstance.UpdateAddressAsActive(for: "7276433824",forCustomerId: "M1304043171904333")
        if NetworkChecker.isConnectedToNetwork() {
            if sender as! UIButton == goButton {
                if validateFields() {
                    showPlaceHolderView()
                    var values: Dictionary<String, AnyObject> = [:]
                    values["mobileNumber"] = (mobileNumberTextField.textField.text?.trim())! as AnyObject?
                    values["platform"] = platform as AnyObject?
                    DataManager.shareInstance.getDataFromWebService(requestOTPURLMize, dataDictionary:values as NSDictionary) { (result, error) -> Void in
                        if error == nil {
                            DispatchQueue.main.async {
                                self.hidePlaceHolderView()
                                RequestOTPModel.shareInstance.parseResponseObject(result)
                                let status: String = RequestOTPModel.shareInstance.status!
//                                let message = RequestOTPModel.shareInstance.errorMessage!
//                                if let message = RequestOTPModel.shareInstance.errorMessage! {
//                                    print("Contains a value!!")
//                                }
                                var message :String
                                if RequestOTPModel.shareInstance.errorMessage != nil {
                                    message = RequestOTPModel.shareInstance.errorMessage!
                                } else {
                                    message = ""
                                }
                                
                                if status == "success" {
                                    PlistManager.sharedInstance.saveValue((self.mobileNumberTextField.textField.text?.trim())! as AnyObject, forKey: "mobileNumber")
                                    PlistManager.sharedInstance.saveValue(RequestOTPModel.shareInstance.authKey! as AnyObject, forKey: "authKey")
                                    let controller:PopUpViewController = self.storyboard!.instantiateViewController(withIdentifier: "PopUpView") as! PopUpViewController
                                    controller.view.frame = self.view.bounds;
                                    controller.view.backgroundColor = UIColor(white: 0.1, alpha: 0.65)
                                    controller.willMove(toParent: self)
                                    self.view.addSubview(controller.view)
                                    self.addChild(controller)
                                    controller.didMove(toParent: self)
                                    controller.messageLabel.text = "Please enter the One Time Password (OTP) sent to your mobile number ******\(self.mobileNumberTextField.textField.text!.substring(from: self.mobileNumberTextField.textField.text!.characters.index(self.mobileNumberTextField.textField.text!.endIndex, offsetBy: -4)))"
                                    controller.popupButton.setTitle("Submit", for: UIControl.State())
                                    controller.popupButton.tag = 0
                                } else {
                                    let alert = UIAlertController(title: errorTitle, message: message, preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: oKey, style: UIAlertAction.Style.default, handler: nil))
                                    alert.show()
                                    //DataManager.shareInstance.showAlert(self, title: errorTitle, message: message)
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
            }
        } else {
            let alert = UIAlertController(title: noInternetTitle, message: noInternetMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: oKey, style: UIAlertAction.Style.default, handler: nil))
            alert.show()
            //            DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
        }
    }
    
    func validateFields() -> Bool {
        let number = (mobileNumberTextField.textField.text?.trim())!
        //        if chooseCountryTextField.textField.text?.trim() == "" || chooseCountryTextField.textField.text?.trim() == "Choose Country" {
        //            let alert = UIAlertController(title: invalidCountryTitle, message: invalidCountryMessage, preferredStyle: UIAlertControllerStyle.alert)
        //            alert.addAction(UIAlertAction(title: oKey, style: UIAlertActionStyle.default, handler: nil))
        //            alert.show()
        ////            DataManager.shareInstance.showAlert(self, title: invalidCountryTitle, message: invalidCountryMessage)
        //            return false
        //        } else
        if mobileNumberTextField.textField.text?.trim() == "" || mobileNumberTextField.textField.text?.trim().characters.count < 10 || !number.isNumeric {
            let alert = UIAlertController(title: invalidMobileNumberTitle, message: invalidMobileNumberMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: oKey, style: UIAlertAction.Style.default, handler: nil))
            alert.show()
            //            DataManager.shareInstance.showAlert(self, title: invalidMobileNumberTitle, message: invalidMobileNumberMessage)
            return false
        }
        return true
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
    
    @objc func showRegistrationView() {
        let controller:RegistrationViewController = self.storyboard!.instantiateViewController(withIdentifier: "RegistrationView") as! RegistrationViewController
        controller.view.frame = self.view.bounds;
        controller.willMove(toParent: self)
        self.view.addSubview(controller.view)
        self.addChild(controller)
        controller.didMove(toParent: self)
    }
    
    @objc func showAlreadyRegisteredView() {
        let controller:AlreadyRegisteredPopUpViewController = self.storyboard!.instantiateViewController(withIdentifier: "AlreadyRegisteredPopUpView") as! AlreadyRegisteredPopUpViewController
        controller.view.frame = self.view.bounds;
        controller.view.backgroundColor = UIColor(white: 0.1, alpha: 0.65)
        controller.willMove(toParent: self)
        self.view.addSubview(controller.view)
        self.addChild(controller)
        controller.didMove(toParent: self)
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
