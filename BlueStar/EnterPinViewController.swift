//
//  EnterPinViewController.swift
//  BlueStar
//
//  Created by tarun.kapil on 19/07/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class EnterPinViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var secureAccessLabel: UILabel!
    @IBOutlet weak var pin1TextField: UITextField!
    @IBOutlet weak var pin2TextField: UITextField!
    @IBOutlet weak var pin3TextField: UITextField!
    @IBOutlet weak var pin4TextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var forgotPinLabel: UIButton!
    @IBOutlet weak var answerQuestionLabel: UIButton!
    @IBOutlet weak var buidingsImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pin1TextField.delegate = self
        pin2TextField.delegate = self
        pin3TextField.delegate = self
        pin4TextField.delegate = self
        
        pin1TextField.nextField = pin2TextField
        pin2TextField.nextField = pin3TextField
        pin3TextField.nextField = pin4TextField
        
        pin1TextField.becomeFirstResponder()
        
        secureAccessLabel.textColor = UIColor(netHex: 0x4F90D9)
        view.sendSubviewToBack(buidingsImageView)
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(showRegistrationView), name: NSNotification.Name(rawValue: "showRegistrationViewFromEnterPin"), object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        submitButton.setPreferences()
        
        pin1TextField.layer.borderWidth = 1
        pin2TextField.layer.borderWidth = 1
        pin3TextField.layer.borderWidth = 1
        pin4TextField.layer.borderWidth = 1
        pin1TextField.layer.borderColor = UIColor(netHex: 0xDEDFE0).cgColor
        pin2TextField.layer.borderColor = UIColor(netHex: 0xDEDFE0).cgColor
        pin3TextField.layer.borderColor = UIColor(netHex: 0xDEDFE0).cgColor
        pin4TextField.layer.borderColor = UIColor(netHex: 0xDEDFE0).cgColor
        pin1TextField.layer.cornerRadius = 3
        pin2TextField.layer.cornerRadius = 3
        pin3TextField.layer.cornerRadius = 3
        pin4TextField.layer.cornerRadius = 3
        
        forgotPinLabel.setTitleColor(UIColor(netHex: 0x4F90D9), for: UIControl.State())
        answerQuestionLabel.setTitleColor(UIColor(netHex: 0x4F90D9), for: UIControl.State())
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == pin1TextField || textField == pin2TextField || textField == pin3TextField || textField == pin4TextField) {
            let maxLength = 1
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            if newLength >= maxLength {
                let delayInSeconds = 0.2
                let delay = DispatchTime.now() + Double(Int64(delayInSeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    textField.nextField?.becomeFirstResponder()
                }
            } else if newLength == 0 {
                let delayInSeconds = 0.1
                let delay = DispatchTime.now() + Double(Int64(delayInSeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    if textField == self.pin4TextField {
                        self.pin3TextField.becomeFirstResponder()
                    } else if textField == self.pin3TextField {
                        self.pin2TextField.becomeFirstResponder()
                    } else if textField == self.pin2TextField {
                        self.pin1TextField.becomeFirstResponder()
                    }
                }
            }
            return newLength <= maxLength
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func submitButtonAction(_ sender: AnyObject) {
        self.view.endEditing(true)
        if(pin1TextField.text?.trim() == "" || pin2TextField.text?.trim() == "" || pin3TextField.text?.trim() == "" || pin4TextField.text?.trim() == "") {
            let alert = UIAlertController(title: invalidPinTitle, message: enterCorrectPinMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: oKey, style: UIAlertAction.Style.default, handler: nil))
            alert.show()
            //DataManager.shareInstance.showAlert(self, title: invalidPinTitle, message: enterCorrectPinMessage)
        } else if((pin1TextField.text?.trim() != "" && pin2TextField.text?.trim() != "" && pin3TextField.text?.trim() != "" && pin4TextField.text?.trim() != "")) {
            let pin = (pin1TextField.text?.trim())!+(pin2TextField.text?.trim())!+(pin3TextField.text?.trim())!+(pin4TextField.text?.trim())!
            let user = PlistManager.sharedInstance.getValueForKey("user") as? NSDictionary
            let validPin: String! = user!["pin"] as! String
            if(pin.characters.count < 4) {
                let alert = UIAlertController(title: invalidPinTitle, message: enterCorrectPinMessage, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: oKey, style: UIAlertAction.Style.default, handler: nil))
                alert.show()
                //DataManager.shareInstance.showAlert(self, title: invalidPinTitle, message: enterCorrectPinMessage)
            } else if(pin != validPin) {
                let alert = UIAlertController(title: invalidPinTitle, message: enterCorrectPinMessage, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: oKey, style: UIAlertAction.Style.default, handler: nil))
                alert.show()
                //DataManager.shareInstance.showAlert(self, title: invalidPinTitle, message: enterCorrectPinMessage)
            } else {
                let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardView") as! DashboardViewController
                let SideBarVC = self.storyboard?.instantiateViewController(withIdentifier: "SidebarMenu") as! SideBarMenuVC
                let nvc: UINavigationController = UINavigationController(rootViewController: mainVC)
                
                let slideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: SideBarVC)
                UIApplication.shared.keyWindow?.rootViewController = slideMenuController
            }
        }
    }
    
    @IBAction func acsessSecurityQuestionAction(_ sender: AnyObject) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "AnswerSecurityQuestionView") as! AnswerSecurityQuestionViewController
        self.present(next, animated: true, completion: nil)
    }
    
    @IBAction func forgotPinAction(_ sender: AnyObject) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "AnswerSecurityQuestionView") as! AnswerSecurityQuestionViewController
        self.present(next, animated: true, completion: nil)
    }
    
    @objc func showRegistrationView() {
        let controller:RegistrationViewController = self.storyboard!.instantiateViewController(withIdentifier: "RegistrationView") as! RegistrationViewController
        controller.view.frame = self.view.bounds;
        controller.willMove(toParent: self)
        self.view.addSubview(controller.view)
        self.addChild(controller)
        controller.didMove(toParent: self)
    }
    
}
