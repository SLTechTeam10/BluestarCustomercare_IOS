//
//  TicketStatusFeedbackVC.swift
//  Blue Star
//
//  Created by Kamlesh on 11/21/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class TicketStatusFeedbackVC: UIViewController {
    
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
    
    var comment: String! = ""
    var isArrivalTime: Bool = false
    var isService: Bool = false
    var isOther: Bool = false
    var ticketNum: String! = ""
    var ticketDetails:NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let notificationsList = PlistManager.sharedInstance.getValueForKey("notificationList") as! NSArray
//        if notificationsList.count>0 {
//            let data = notificationsList[0]
//            let date = data["date"] as? String
//            let ticketNumber = data["ticketNumber"] as? String
//            ticketNum = ticketNumber
//            dateTimeLabel.text = date!
//            ticketNumberLabel.text = "Ticket no : " + ticketNumber!
//        }
        print("Ticket details \(ticketDetails)")
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
//        if notificationsList.count > 1 {
//            submitButton.setTitle("Next", forState: .Normal)
//        } else {
//            submitButton.setTitle("Submit", forState: .Normal)
//        }
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(updateRatingLabel), name: NSNotification.Name(rawValue: "updateRatingLabel"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let screenClass = self.classForCoder.description()
        Analytics.setScreenName("Ticket Feedback Screen", screenClass: screenClass)
        Analytics.logEvent("page_view",parameters: ["page":"Ticket Feedback Screen"])
    }
    @IBAction func leaveCommentAction(_ sender: AnyObject) {
        
        let controller:CommentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommentView") as! CommentViewController

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
                values["cause"] = cause as AnyObject?
                DataManager.shareInstance.getDataFromWebService(feedbackURLMize, dataDictionary:values as NSDictionary) { (result, error) -> Void in
                    if error == nil {
                        DispatchQueue.main.async {
                            self.hidePlaceHolderView()
                            FeedbackModel.shareInstance.parseResponseObject(result)
                            let message = FeedbackModel.shareInstance.errorMessage!
                            let status = FeedbackModel.shareInstance.status!
                            if status == "error" {
                                DataManager.shareInstance.showAlert(self, title: messageTitle, message: message)
                            } else {
                                //service success now back to previous view
                                
                                
                                /*
                                let notificationsList = PlistManager.sharedInstance.getValueForKey("notificationList") as! NSMutableArray
                                notificationsList.removeObjectAtIndex(0)
                                PlistManager.sharedInstance.saveValue(notificationsList, forKey: "notificationList")
                                if notificationsList.count > 0 {
                                    self.getFeedbackForNextTicket()
                                } else {
                                    PlistManager.sharedInstance.saveValue(false, forKey: "showFeedback")
                                    let nc = NSNotificationCenter.defaultCenter()
                                    nc.postNotificationName("removeFeedbackView", object: nil)
                                    self.willMoveToParentViewController(nil)
                                    self.view.removeFromSuperview()
                                    self.removeFromParentViewController()
                                }
                                */
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
        }
        return true
    }
    
    @objc func updateRatingLabel() {
        switch ratingControl.rating {
        case 0:
            ratingLabel.text = "Bad"
        case 1:
            ratingLabel.text = "Ok"
        case 2:
            ratingLabel.text = "Satisfactory"
        case 3:
            ratingLabel.text = "Good"
        case 4:
            ratingLabel.text = "Very Good"
        case 5:
            ratingLabel.text = "Excellent"
        default:
            ratingLabel.text = "Good"
        }
    }
    
    /*
    func getFeedbackForNextTicket() {
        let notificationsList = PlistManager.sharedInstance.getValueForKey("notificationList") as! NSArray
        let data = notificationsList[0]
        let date = data["date"] as? String
        let ticketNumber = data["ticketNumber"] as? String
        ticketNum = ticketNumber
        dateTimeLabel.text = date!
        ratingLabel.text = ""
        ticketNumberLabel.text = "Ticket no : " + ticketNumber!
        ratingControl.rating = 0
        leaveCommentButton.setTitle("Leave a comment", forState: .Normal)
        arrivalTimeButton.layer.borderWidth = 1
        arrivalTimeButton.backgroundColor = UIColor.whiteColor()
        arrivalTimeButton.tintColor = UIColor(netHex: 0x666666)
        isArrivalTime = false
        serviceButton.layer.borderWidth = 1
        serviceButton.backgroundColor = UIColor.whiteColor()
        serviceButton.tintColor = UIColor(netHex: 0x666666)
        isService = false
        otherButton.layer.borderWidth = 1
        otherButton.backgroundColor = UIColor.whiteColor()
        otherButton.tintColor = UIColor(netHex: 0x666666)
        isOther = false
        if notificationsList.count > 1 {
            submitButton.setTitle("Next", forState: .Normal)
        } else {
            submitButton.setTitle("Submit", forState: .Normal)
        }
    }
    */
    
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
    
}
