//
//  FeedbackViewController.swift
//  BlueStar
//
//  Created by tarun.kapil on 09/08/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class FeedbackViewController: UIViewController {

    @IBOutlet weak var feedbackView: UIView!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var borderLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var ticketNumberLabel: UILabel!
    @IBOutlet weak var leaveCommentButton: UIButton!
    @IBOutlet weak var arrivalTimeButton: UIButton!
    @IBOutlet weak var serviceButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var whatWentWrong: UILabel!
    
    var comment: String! = ""
    var isArrivalTime: Bool = false
    var isService: Bool = false
    var isOther: Bool = false
    var ticketNum: String! = ""
    
    var isFromTicketStatus: Bool = false
    var ticketDetails:NSDictionary?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        enableDisableFeedBackButtons()
        
        if !isFromTicketStatus {
            let notificationsList = PlistManager.sharedInstance.getValueForKey("notificationList") as! NSArray
            if notificationsList.count>0 {
                let data = notificationsList[0] as! NSDictionary
                let date = data["date"] as? String
                let ticketNumber = data["ticketNumber"] as? String
                ticketNum = ticketNumber
                dateTimeLabel.text = date!
                ticketNumberLabel.text = "Reference no : " + ticketNumber!
            }
            
            if notificationsList.count > 1 {
                submitButton.setTitle("Next", for: UIControl.State())
            } else {
                submitButton.setTitle("Submit", for: UIControl.State())
            }

        }else{
            submitButton.setTitle("Submit", for: UIControl.State())
            let date = ticketDetails!["lastUpdatedDate"] as! String
            dateTimeLabel.text = date
            ticketNum = ticketDetails!["ticketNumber"] as! String
            ticketNumberLabel.text = "Reference no : " + ticketNum
        }
        
        feedbackView.layer.cornerRadius = 12
        dateTimeLabel.textColor = UIColor(netHex: 0x666666)
        borderLabel.backgroundColor = UIColor(netHex: 0xDEDFE0)
        ratingLabel.text = ""
        ratingLabel.textColor = UIColor(netHex: 0x666666)
        leaveCommentButton.backgroundColor = UIColor(netHex: 0xF1F1F2)
        leaveCommentButton.tintColor = UIColor(netHex: 0xDEDFE0)
        leaveCommentButton.layer.cornerRadius = 2
        leaveCommentButton.layer.borderWidth = 1
        leaveCommentButton.layer.borderColor = UIColor(netHex: 0xDEDFE0).cgColor
        arrivalTimeButton.tintColor = UIColor(netHex: 0x666666)
        arrivalTimeButton.layer.cornerRadius = 2
        arrivalTimeButton.layer.borderWidth = 1
        arrivalTimeButton.layer.borderColor = UIColor(netHex: 0x666666).cgColor
        serviceButton.tintColor = UIColor(netHex: 0x666666)
        serviceButton.layer.cornerRadius = 2
        serviceButton.layer.borderWidth = 1
        serviceButton.layer.borderColor = UIColor(netHex: 0x666666).cgColor
        otherButton.tintColor = UIColor(netHex: 0x666666)
        otherButton.layer.cornerRadius = 2
        otherButton.layer.borderWidth = 1
        otherButton.layer.borderColor = UIColor(netHex: 0x666666).cgColor
        submitButton.setPreferences()
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(updateRatingLabel), name: NSNotification.Name(rawValue: "updateRatingLabel"), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let screenClass = self.classForCoder.description()
        Analytics.setScreenName("Ticket Feedback Screen", screenClass: screenClass)
        Analytics.logEvent("page_view",parameters: ["page":"Ticket Feedback Screen"])
    }
    func setNavigationBar() {
        
        self.title = "Feedback"
        
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
        leftButton.setImage(UIImage(named: IMG_Back), for: UIControl.State())
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.addTarget(self, action: #selector(moveBackToTicketStatus), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @IBAction func leaveCommentAction(_ sender: AnyObject) {
        let controller:CommentViewController = self.storyboard!.instantiateViewController(withIdentifier: "CommentView") as! CommentViewController
        
        controller.view.frame = self.view.bounds;
        controller.view.backgroundColor = UIColor(white: 0.1, alpha: 0.65)
        controller.willMove(toParent: self)
        self.view.addSubview(controller.view)
        self.addChild(controller)
        controller.didMove(toParent: self)
        if leaveCommentButton.titleLabel?.text != "Leave a comment" {
            controller.commentTextView.text = leaveCommentButton.titleLabel?.text!
        }
    }
    
    @IBAction func arrivalTimeButtonAction(_ sender: AnyObject) {
        if isArrivalTime {
            arrivalTimeButton.layer.borderWidth = 1
            arrivalTimeButton.backgroundColor = UIColor.white
            arrivalTimeButton.tintColor = UIColor(netHex: 0x666666)
            isArrivalTime = false
        } else {
            arrivalTimeButton.layer.borderWidth = 0
            arrivalTimeButton.backgroundColor = UIColor(netHex:0x0672EB)
            arrivalTimeButton.tintColor = UIColor.white
            isArrivalTime = true
        }
    }

    @IBAction func serviceButtonAction(_ sender: AnyObject) {
        if isService {
            serviceButton.layer.borderWidth = 1
            serviceButton.backgroundColor = UIColor.white
            serviceButton.tintColor = UIColor(netHex: 0x666666)
            isService = false
        } else {
            serviceButton.layer.borderWidth = 0
            serviceButton.backgroundColor = UIColor(netHex:0x0672EB)
            serviceButton.tintColor = UIColor.white
            isService = true
        }
    }
    
    @IBAction func otherButtonAction(_ sender: AnyObject) {
        if isOther {
            otherButton.layer.borderWidth = 1
            otherButton.backgroundColor = UIColor.white
            otherButton.tintColor = UIColor(netHex: 0x666666)
            isOther = false
        } else {
            otherButton.layer.borderWidth = 0
            otherButton.backgroundColor = UIColor(netHex:0x0672EB)
            otherButton.tintColor = UIColor.white
            isOther = true
        }
    }
    
    @IBAction func submitButtonAction(_ sender: AnyObject) {
         if validateFields() {
            if NetworkChecker.isConnectedToNetwork() {
                showPlaceHolderView()
                var values: Dictionary<String, AnyObject> = [:]
                values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
                values["platform"] = platform as AnyObject?
                values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
                
                values["ticketNumber"] = ticketNum as AnyObject?
                
                values["rating"] = ratingControl.rating as AnyObject?
                values["comment"] = comment as AnyObject?
                var cause: String = ""
                
                if ratingControl.rating <= 2 {
                    if isArrivalTime {
                        cause += "Arrival Time"
                    }
                    if isService {
                        if cause != "" {
                            cause += ", "
                        }
                        cause += "Service"
                    }
                    if isOther {
                        if cause != "" {
                            cause += ", "
                        }
                        cause += "Other"
                    }
                }
                
                values["cause"] = cause as AnyObject?
                
                DataManager.shareInstance.getDataFromWebService(feedbackURL, dataDictionary:values as NSDictionary) { (result, error) -> Void in
                    if error == nil {
                        DispatchQueue.main.async {
                            self.hidePlaceHolderView()
                            FeedbackModel.shareInstance.parseResponseObject(result)
                            let message = FeedbackModel.shareInstance.errorMessage!
                            let status = FeedbackModel.shareInstance.status!
                            if status == "error" {
                                DataManager.shareInstance.showAlert(self, title: messageTitle, message: message)
                            } else {
                                
                                if !self.isFromTicketStatus{
                                    let notificationsList = PlistManager.sharedInstance.getValueForKey("notificationList") as! NSMutableArray
                                    notificationsList.removeObject(at: 0)
                                    PlistManager.sharedInstance.saveValue(notificationsList, forKey: "notificationList")
                                    if notificationsList.count > 0 {
                                        self.getFeedbackForNextTicket()
                                    } else {
                                        PlistManager.sharedInstance.saveValue(false as AnyObject, forKey: "showFeedback")
                                        let nc = NotificationCenter.default
                                        nc.post(name: Notification.Name(rawValue: "removeFeedbackView"), object: nil)
                                        self.willMove(toParent: nil)
                                        self.view.removeFromSuperview()
                                        self.removeFromParent()
                                    }
                                }else{
                                    let message = FeedbackModel.shareInstance.message!
                                    
                                    let refreshAlert = UIAlertController(title: "Success", message:message, preferredStyle: UIAlertController.Style.alert)
                                    
                                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                        self.navigationController?.popViewController(animated: true)
                                    }))
                                    self.present(refreshAlert, animated: true, completion: nil)
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
    }
    
    func validateFields() -> Bool {
        if ratingControl.rating == 0 {
            DataManager.shareInstance.showAlert(self, title: invalidRatingTitle, message: invalidRatingMessage)
            return false
        }else if (ratingControl.rating <= 2 && !isService && !isArrivalTime && !isOther ){
            DataManager.shareInstance.showAlert(self, title:"What went wrong", message:whatWentWrongSelectionMessage)
            return false
        }else if (ratingControl.rating <= 2 && comment.trim() == "" && isOther){
            DataManager.shareInstance.showAlert(self, title:"Comment", message:"Please enter a comment for this rating.")
            return false
        }
        return true
    }
    
    @objc func updateRatingLabel() {
        switch ratingControl.rating {
        case 0:
            ratingLabel.text = "Bad"
        case 1:
            ratingLabel.text = "Poor"
        case 2:
            ratingLabel.text = "Not satisfactory"
        case 3:
            ratingLabel.text = "Average"
        case 4:
            ratingLabel.text = "Good"
        case 5:
            ratingLabel.text = "Excellent"
        default:
            ratingLabel.text = "Good"
        }
        
        enableDisableFeedBackButtons()
    }
    
    func enableDisableFeedBackButtons() {
        if(ratingControl.rating < 5){
            whatWentWrong.isHidden = false
        }else{
            whatWentWrong.isHidden = true
            
        }
        if ratingControl.rating <= 2{
            
            arrivalTimeButton.isHidden = false;
            serviceButton.isHidden = false
            otherButton.isHidden = false
            whatWentWrong.isHidden = false
            arrivalTimeButton.layer.borderColor = UIColor(netHex:0x666666).cgColor
            serviceButton.layer.borderColor = UIColor(netHex:0x666666).cgColor
            otherButton.layer.borderColor = UIColor(netHex:0x666666).cgColor
            
            isService = false
            isOther = false
            isArrivalTime = false
            
        }else{
            //disable what went wrong buttons
            arrivalTimeButton.isHidden = true;
            serviceButton.isHidden = true
            otherButton.isHidden = true
            whatWentWrong.isHidden = true
            arrivalTimeButton.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
            serviceButton.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
            otherButton.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        }
        
        serviceButton.layer.borderWidth = 1
        serviceButton.backgroundColor = UIColor.white
        serviceButton.tintColor = UIColor(netHex:0x666666)
        
        otherButton.layer.borderWidth = 1
        otherButton.backgroundColor = UIColor.white
        otherButton.tintColor =   UIColor(netHex:0x666666)
        
        arrivalTimeButton.layer.borderWidth = 1
        arrivalTimeButton.backgroundColor = UIColor.white
        arrivalTimeButton.tintColor =  UIColor(netHex:0x666666)

    }
    
    func getFeedbackForNextTicket() {
        let notificationsList = PlistManager.sharedInstance.getValueForKey("notificationList") as! NSArray
        let data = notificationsList[0] as! NSDictionary
        let date = data["date"] as? String
        let ticketNumber = data["ticketNumber"] as? String
        ticketNum = ticketNumber
        dateTimeLabel.text = date!
        ratingLabel.text = ""
        ticketNumberLabel.text = "Reference no : " + ticketNumber!
        ratingControl.rating = 0
        leaveCommentButton.setTitle("Leave a comment", for: UIControl.State())
        arrivalTimeButton.layer.borderWidth = 1
        arrivalTimeButton.backgroundColor = UIColor.white
        arrivalTimeButton.tintColor = UIColor(netHex: 0x666666)
        isArrivalTime = false
        serviceButton.layer.borderWidth = 1
        serviceButton.backgroundColor = UIColor.white
        serviceButton.tintColor = UIColor(netHex: 0x666666)
        isService = false
        otherButton.layer.borderWidth = 1
        otherButton.backgroundColor = UIColor.white
        otherButton.tintColor = UIColor(netHex: 0x666666)
        isOther = false
        if notificationsList.count > 1 {
            submitButton.setTitle("Next", for: UIControl.State())
        } else {
            submitButton.setTitle("Submit", for: UIControl.State())
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

    @objc func moveBackToTicketStatus() {
        self.navigationController?.popViewController(animated: true)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
