//
//  AnswerSecurityQuestionViewController.swift
//  BlueStar
//
//  Created by tarun.kapil on 20/07/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class AnswerSecurityQuestionViewController: UIViewController {

    @IBOutlet weak var secureAccessLabel: UILabel!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    //@IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var enterPinButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var buildingsImageView: UIImageView!
    
    var answer: String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var question: String! = ""
        let user = PlistManager.sharedInstance.getValueForKey("user") as! NSDictionary
        let questionID = user["securityQuestionId"] as! String
        for value in securityQuestions {
            if value["id"] == questionID {
                question = value["question"]!
            }
        }
        answer = user["securityQuestionAnswer"] as! String
        questionLabel.text = question
        
        secureAccessLabel.textColor = UIColor(netHex: 0x4F90D9)
        view.sendSubviewToBack(buildingsImageView)
    }
    
    override func viewDidLayoutSubviews() {
        submitButton.setPreferences()
        
        questionView.layer.borderWidth = 1
        answerTextField.layer.borderWidth = 1
        questionView.layer.borderColor = UIColor(netHex: 0x4F90D9).cgColor
        questionLabel.textColor = UIColor(netHex: 0x4F90D9)
        answerTextField.layer.borderColor = UIColor(netHex: 0xDEDFE0).cgColor
        answerTextField.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0);
        questionView.layer.cornerRadius = 3
        answerTextField.layer.cornerRadius = 3
        
        enterPinButton.setTitleColor(UIColor(netHex: 0x4F90D9), for: UIControl.State())
        registerButton.setTitleColor(UIColor(netHex: 0x4F90D9), for: UIControl.State())
        
        let alreadyRegisteredUser = PlistManager.sharedInstance.getValueForKey("alreadyRegisteredUser") as! Bool
        if alreadyRegisteredUser{
            enterPinButton.isHidden = true
        }
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
        if(answerTextField.text?.trim() == "" || answer.lowercased() != answerTextField.text?.trim().lowercased()) {
            let alert = UIAlertController(title: invalidAnswerTitle, message: enterCorrectAnswerMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: oKey, style: UIAlertAction.Style.default, handler: nil))
            alert.show()
//            DataManager.shareInstance.showAlert(self, title: invalidAnswerTitle, message: enterCorrectAnswerMessage)
        } else {
            PlistManager.sharedInstance.saveValue(true as AnyObject, forKey: "registered")
            PlistManager.sharedInstance.saveValue(false as AnyObject, forKey: "alreadyRegisteredUser")
            let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardView") as! DashboardViewController
            let SideBarVC = self.storyboard?.instantiateViewController(withIdentifier: "SidebarMenu") as! SideBarMenuVC
            let nvc: UINavigationController = UINavigationController(rootViewController: mainVC)
            
            let slideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: SideBarVC)
            UIApplication.shared.keyWindow?.rootViewController = slideMenuController
        }
    }
    
    @IBAction func enterPinButtonAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerButtonAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name(rawValue: "showRegistrationViewFromEnterPin"), object: nil)

    }

}
