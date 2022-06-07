//
//  TicketViewController.swift
//  BlueStar
//
//  Created by tarun.kapil on 29/07/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class TicketViewController: UIViewController  {
    
    @IBOutlet weak var ticketView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ticketStatusLabel: UILabel!
    @IBOutlet weak var ticketNumberLabel: UILabel!
    //@IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var buttonShare: UIButton!
    @IBOutlet weak var buttonCancelTicket: UIButton!
    
    @IBOutlet weak var modelNoLabel: UILabel!
    @IBOutlet weak var serialNoLabel: UILabel!
    
    var productName: String!
    var ticketNumber: String!
    var date: String!
    var status: String!
    var isAlreadyGenerated: Bool!
    var productId: String!
    var productImage: String!
    var displayAddress: NSDictionary!
    var modelNo: String?
    var serialNo: String?
    //var updatedOn: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nc = NotificationCenter.default

        setNavigationBar()
        let user = PlistManager.sharedInstance.getValueForKey("user") as! NSDictionary
//        let addresses = user["addresses"] as! NSArray
//        var address: Dictionary<String, AnyObject>!
//        for (_, value) in addresses.enumerated() {
//            address = value as! Dictionary<String, AnyObject>
//            let isPrimary = address["isPrimaryAddress"] as! String
//            if isPrimary == "true" {
//                break
//            }
//
//        }
        var addressString: String = "Address : "
//        if address["address"] as! String != "" {
//            addressString += "\(address["address"]!)"
//        }
//        if address["locality"] as! String != "" {
//            addressString += ", \(address["locality"]!)"
//        }
//        if address["city"] as! String != "" {
//            addressString += ", \(address["city"]!)"
//        }
//        if address["state"] as! String != "" {
//            addressString += ", \(address["state"]!)"
//        }
//        if address["pinCode"] as! String != "" {
//            addressString += " - \(address["pinCode"]!)"
//        }
        if let local = (displayAddress.value(forKey: "address1") as? String){
            addressString += local + ","
        }
        if let local = (displayAddress.value(forKey: "address2") as? String){
            addressString += local + ","
        }
        if let local = (displayAddress.value(forKey: "locality") as? String) {
            addressString += local + ","
        }
        if let local = (displayAddress.value(forKey: "city") as? String) {
            addressString += local + ","
        }
        if let local = (displayAddress.value(forKey: "state") as? String) {
            addressString += local + ",\n"
        }
        if let local = (displayAddress.value(forKey: "pinCode") as? String) {
            addressString += local
        }
        addressLabel.text = addressString
        //"Address : \(address["address"]!), \(address["locality"]!), \(address["city"]!), \(address["state"]!) \(address["pinCode"]!)"
        productLabel.text = "Product : \(productName!)"
        ticketNumberLabel.text = "Reference No : \(ticketNumber!)"
        //dateLabel.text = "Date : \(date!)"
        statusLabel.text = "Status : \(status!)"
        if(modelNo == "" || modelNo == nil){
//            modelNoLabel.frame = CGRect(x: modelNoLabel.frame.origin.x, y: modelNoLabel.frame.origin.y, width: modelNoLabel.frame.size.width, height: 0)
//            serialNoLabel.frame = CGRect(x: serialNoLabel.frame.origin.x, y: serialNoLabel.frame.origin.y, width: serialNoLabel.frame.size.width, height: 0)
            modelNoLabel.isHidden = true
            serialNoLabel.isHidden = true
        }else{
            modelNoLabel.text = "Model No :\( modelNo!)"
            serialNoLabel.text = "Serial No :\(serialNo!)"
        }
        ticketView.backgroundColor = UIColor(netHex: 0x246cb0)
        
        buttonShare.layer.cornerRadius = buttonShare.frame.size.height/2
        buttonCancelTicket.layer.cornerRadius = buttonCancelTicket.frame.size.height/2
        
//        self.addTicketToDB()
        
        nc.addObserver(self, selector: #selector(historyView), name: NSNotification.Name(rawValue: "displayHistoryView"), object: nil)
        nc.addObserver(self, selector: #selector(dismissView), name: NSNotification.Name(rawValue: "closeViewController"), object: nil)
        nc.post(name: Notification.Name(rawValue: "dismissNatureOfProblem"), object: nil)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let screenClass = self.classForCoder.description()
        Analytics.setScreenName("Ticket View Screen", screenClass: screenClass)
        Analytics.logEvent("page_view",parameters: ["page":"Ticket View Screen"])
        
    }
    @objc func historyView(){
        
        DispatchQueue.main.async {
            let nc = NotificationCenter.default
            //nc.addObserver(self, selector: #selector(historyView), name: NSNotification.Name(rawValue: "dissmissView"), object: nil)
            nc.post(name: Notification.Name(rawValue: "closeViewController"), object: nil)
            
            let next = self.storyboard?.instantiateViewController(withIdentifier: "HistoryView") as! HistoryViewController
            next.cancelTicketReload = true
            //self.present(next, animated: true, completion: nil)
            self.navigationController?.pushViewController(next, animated: true)
            //self.presentedViewController?.dismiss(animated: true, completion: { _ in })
        }
    }
    
    @objc func dismissView(){

        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    func addTicketToDB(){
        let fileURL = DBManager.shareInstance.getPath()
        let db1 = FMDatabase(path: fileURL)
        db1?.open()
        if(date.trim() == "" ){
            date = ""
        } else if(status.trim() == "") {
            status = ""
        }
        
        let isinserted = db1?.executeUpdate("INSERT INTO ticketHistory (ticketNumber,lastUpdatedDate,productId,progressStatus,productName,productImage) VALUES (?,?,?,?,?,?)", withArgumentsIn: [ticketNumber,date,productId,status,productName,productImage])
        
        if(!isinserted!){
            print("Database failure: \(db1?.lastErrorMessage())")
        }
        
        db1?.close()
        
    }
    


    func setNavigationBar() {
        self.title = ""
        let nav = self.navigationController?.navigationBar
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
        nav!.titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.font.rawValue: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)])
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: IMG_CrossButton), for: UIControl.State())
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.addTarget(self, action: #selector(moveBackToDashboard), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc func moveBackToDashboard() {
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name(rawValue: "refreshTicketStatus"), object: nil)
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareButtonAction(_ buttonShare : UIButton)
    {
        let message = "Your ticket reference number for Blue Star "+productName!+" is "+ticketNumber!+"\nStatus: "+status!+"\nSent via: Blue Star Customer Care Application"
        
        let textToShare = [ message ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func cancelTicketAction(_ buttonCancelTicket : UIButton)
    {
        let optionsListViewController = self.storyboard?.instantiateViewController(withIdentifier: "OptionsListViewController") as! OptionsListViewController
        optionsListViewController.optionsType = "cancel"
        optionsListViewController.ticketNumber = ticketNumber! as String as NSString!
        optionsListViewController.flag = true
        self.present(optionsListViewController, animated: true, completion: nil)
        //self.cancelTicket(ticketNumber as NSString!)
        //self.presentedViewController?.dismiss(animated: true, completion: { _ in })
    }
    func cancelTicket(_ ticketNumber: NSString!){
        self.view.endEditing(true)
        if NetworkChecker.isConnectedToNetwork() {
            var values: Dictionary<String, AnyObject> = [:]
            values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
            values["platform"] = platform as AnyObject?
            values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
            values["ticketNumber"] = ticketNumber//ticketDetail?["ticketNumber"] as! String as AnyObject?
            values["description"] = "Logged the call accidentally" as AnyObject?
            //            print(values["mobileNumber"])
            //            print(values["platform"])
            //            print(values["authKey"])
            //            print(values["ticketNumber"])
            //            print(values["description"])
            DataManager.shareInstance.getDataFromWebService(cancelTicketURLMize, dataDictionary:values as NSDictionary) { (result, error) -> Void in
                if(error == nil){
                    DispatchQueue.main.async {
                        cancelTicketModel.shareInstance.parseResponseObject(result)
                        let message = cancelTicketModel.shareInstance.message!
                        let status = cancelTicketModel.shareInstance.status!
                        if status == "error"{
                            DataManager.shareInstance.showAlert(self, title: messageTitle, message: message)
                            //self.presentedViewController?.dismiss(animated: true, completion: { _ in })
                        } else{
                            DataManager.shareInstance.showAlert(self, title: messageTitle, message: message)
                            //self.presentedViewController?.dismiss(animated: true, completion: { _ in })
                            
                        }
                        
                    }
                } else {
                    DispatchQueue.main.async {
                        //self.hidePlaceHolderView()
                        if error?.code != -999 {
                            DataManager.shareInstance.showAlert(self, title: (error?.domain)!, message: (error?.localizedDescription)!)
                            //self.presentedViewController?.dismiss(animated: true, completion: { _ in })
                        }
                    }
                }
            }
        } else {
            DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
            //self.presentedViewController?.dismiss(animated: true, completion: { _ in })
        }
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
