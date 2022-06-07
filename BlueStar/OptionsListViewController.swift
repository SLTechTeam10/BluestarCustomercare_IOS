//
//  OptionsListViewController.swift
//
//
//  Created by Ankush on 25/02/17.
//
//

import UIKit
import FirebaseAnalytics

class OptionsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate, UITextViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noOrCancelButton : UIButton!
    @IBOutlet weak var yesOrOKButton : UIButton!
    
    var optionsType : NSString!
    var optionsList :  [String] = []
    var presentationController1: PresentationController?
    var optionSelected : String = ""
    var selectedIndexPath : IndexPath?
    var ticketNumber : NSString!
    var desc : NSString!
    var cellTextView : OptionsListTextTableViewCell!
    var cell : OptionsListTableViewCell!
    var flag : Bool!
    let dataSource1 = ["Logged the call accidentally" , "Other"]
    let dataSource2 = ["Logged the call accidentally", "Other","UserComment"]
    // MARK: - UIViewControllerTransitioningDelegate
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        presentationController1 = PresentationController(presentedViewController: presented, presenting: presenting)
        return presentationController1!
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /********** adjust popup size **********/
        
        noOrCancelButton.layer.cornerRadius = noOrCancelButton.frame.size.height/2
        yesOrOKButton.layer.cornerRadius = yesOrOKButton.frame.size.height/2
        
        noOrCancelButton.addTarget(self, action: #selector(noOrCancelButtonAction), for: .touchUpInside)
        yesOrOKButton.addTarget(self, action: #selector(submitButtonAction), for: .touchUpInside)
        optionsList = dataSource1
        titleLabel.text = "Cancel ticket"
        optionSelected = "Logged the call accidentally"
        desc = "Logged the call accidentally"
        let indexPath = IndexPath(item: 0, section: 0)
        selectedIndexPath = indexPath
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        layoutPresentationViewForHeight(180)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let screenClass = self.classForCoder.description()
        Analytics.setScreenName("Cancel Ticket Option Screen", screenClass: screenClass)
        Analytics.logEvent("page_view",parameters: ["page":"Cancel Ticket Option Screen"])
    }
    @objc func noOrCancelButtonAction(){
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func layoutPresentationViewForHeight(_ sourceheight : CGFloat) {
        if optionsType .isEqual(to: "cancel") {
            presentationController1?.height = sourceheight
        }
        presentationController1?.presentationTransitionWillBegin()
    }
    
    @objc func submitButtonAction() {
        
        DispatchQueue.main.async {
            if(self.flag == true) {
                
                self.cancelTicket(self.ticketNumber)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cancelTicketReload"), object: nil)
            }
            else {
                
                self.cancelTicket(self.ticketNumber)
                // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cancelTicketReload"), object: nil)
                self.presentedViewController?.dismiss(animated: true,completion: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITableView Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.optionsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 2 {
            cellTextView = self.tableView.dequeueReusableCell(withIdentifier: "optionsListTextTableViewCell") as! OptionsListTextTableViewCell!
            cellTextView.textView.delegate = self
            cellTextView.addDoneButtonOnKeyboard()
            return cellTextView
        }
        else {
            
            // create a new cell if needed or reuse an old one
            cell = self.tableView.dequeueReusableCell(withIdentifier: "optionsListTableViewCell") as! OptionsListTableViewCell!
            
            // set the text from the data model
            cell?.label.text = optionsList[indexPath.row]
            
            cell?.imageview.image = UIImage(named: "radio_off")
            if selectedIndexPath == indexPath {
                
                cell?.imageview.image = UIImage(named: "radio_on")
            }
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let optionsSelectedByUser = optionsList[indexPath.row] as? String
        if indexPath.row == 0 {
            optionsList = dataSource1
            selectedIndexPath = indexPath
            layoutPresentationViewForHeight(180)
            optionSelected = optionsSelectedByUser!
        } else if let correctValue = optionsSelectedByUser , correctValue == "Other" {
            optionsList = dataSource2
            selectedIndexPath = indexPath
            layoutPresentationViewForHeight(280)
            optionSelected = correctValue
        }
        tableView.reloadData()
    }
    
    func cancelTicket(_ ticketNumber: NSString!) {
        
        self.view.endEditing(true)
        if (optionSelected == "Other") {
            
            desc = cellTextView.textView.text as NSString!
            if (cellTextView.textView.textColor?.isEqual(UIColor.lightGray))! {
                
                desc = ""
            }
        }
        if NetworkChecker.isConnectedToNetwork() {
            
            if validateFields() {
                
                self.showPlaceHolderView()
                
                var values: Dictionary<String, AnyObject> = [:]
                values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
                values["platform"] = platform as AnyObject?
                values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
                values["ticketNumber"] = ticketNumber
                values["description"] = desc as AnyObject?
                
                DataManager.shareInstance.getDataFromWebService(cancelTicketURLMize, dataDictionary:values as NSDictionary) { (result, error) -> Void in
                    if(error == nil) {
                        
                        DispatchQueue.main.async {
                            
                            self.hidePlaceHolderView()
                            cancelTicketModel.shareInstance.parseResponseObject(result)
                            let message = cancelTicketModel.shareInstance.message!
                            let status = cancelTicketModel.shareInstance.status!
                            if status == "error" {
                                
                                DataManager.shareInstance.showAlert(self, title: messageTitle, message: message)
                            }
                            else {
                                
                                let alert = UIAlertController(title:messageTitle, message:message, preferredStyle: .alert)
                                alert.view.frame = UIScreen.main.applicationFrame
                                let action = UIAlertAction(title:oKey, style: .default)
                                { _ in
                                    self.dismiss(animated: true, completion: nil)
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "displayHistoryView"), object: nil)
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cancelTicketReload"), object: nil)
                                }
                                alert.addAction(action)
                                self.present(alert, animated: true)
                                {}
                            }
                        }
                    }
                    else {
                        
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
        else {
            
            self.hidePlaceHolderView()
            DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
        }
    }
    
    func validateFields() -> Bool {
        
        if(optionSelected == "Other") {
            
            if(desc!.isEqual(to: "")) {
                
                let alert = UIAlertController(title:ticketCancelErrorTitle, message:ticketCancelMessage, preferredStyle: .alert)
                alert.view.frame = UIScreen.main.applicationFrame
                let action = UIAlertAction(title:oKey, style: .default)
                { _ in
                }
                alert.addAction(action)
                self.present(alert, animated: true)
                {}
                return false
            }
        }
        else if(optionSelected == "") {
            
            DataManager.shareInstance.showAlert(self, title: ticketCancelSelectTitle, message: ticketCancelSelectMessage)
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
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if (textView.text == "Reason for ticket cancellation.") {
            textView.text = ""
            //            self.view.frame = CGRect(x:self.fra)
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text == "" {
            var placeholder:String = "Reason for ticket cancellation."
            let loc: Int = placeholder.characters.count
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: placeholder as String, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor(netHex:0x666666)]))
            myMutableString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: fontQuicksandBookRegular, size: 14)!, range: NSRange(location:0,length:placeholder.characters.count))
            textView.attributedText = myMutableString
        }
        
        return true
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
