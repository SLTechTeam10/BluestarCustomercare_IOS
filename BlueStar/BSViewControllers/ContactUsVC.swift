//
//  AboutUsVC.swift
//  Blue Star
//
//  Created by Kamlesh on 11/22/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit
import MessageUI
import FirebaseAnalytics

class ContactUsVC: UIViewController,MFMailComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableAboutUs: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        doAdditionalViewSetUp()
        // Do any additional setup after loading the view.
        tableAboutUs.tableFooterView = UIView()
        let nib = UINib(nibName: "ContactUsHeaderCell", bundle: nil)
        self.tableAboutUs.register(nib, forCellReuseIdentifier:"ContactUsHeaderCell")
        
        let nib2 = UINib(nibName: "VisitCell", bundle: nil)
        self.tableAboutUs.register(nib2, forCellReuseIdentifier:"VisitCell")
        
        let nib3 = UINib(nibName: "CallCell", bundle: nil)
        self.tableAboutUs.register(nib3, forCellReuseIdentifier:"CallCell")
        
//        let nib4 = UINib(nibName: "BuyHereCell", bundle: nil)
//        self.tableAboutUs.registerNib(nib4, forCellReuseIdentifier:"BuyHereCell")
        
        tableAboutUs.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let screenClass = self.classForCoder.description()
        Analytics.setScreenName("Contact Us Screen", screenClass: screenClass)
        Analytics.logEvent("page_view",parameters: ["page":"Contact Us Screen"])
    }
    func doAdditionalViewSetUp()  {
        self.title = "Contact Us"
        
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
        leftButton.addTarget(self, action: #selector(moveBackToDashboard), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItem = leftBarButton
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactUsHeaderCell") as! ContactUsHeaderCell
            return cell
        }
        else if (indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: "VisitCell") as! VisitCell
            if indexPath.row == 3 {
                cell.imageViewIcon.image = UIImage(named:"globe")
                cell.labelText.text = "Or visit"
                cell.buttonEmail.tag = 7
                cell.buttonEmail.setTitle("https://www.bluestarindia.com", for:UIControl.State())
                cell.buttonEmail.addTarget(self, action:#selector(openLinkUrl), for:.touchUpInside)
            }else if indexPath.row == 1{
                cell.imageViewIcon.image = UIImage(named:"Email")
                cell.labelText.text = "Write to us at"
                cell.buttonEmail.tag = 6
                cell.buttonEmail.setTitle("customerservice@bluestarindia.com", for:UIControl.State())
                cell.buttonEmail.addTarget(self, action:#selector(sendMail), for:.touchUpInside)
            }
            else if indexPath.row == 2{
                cell.imageViewIcon.image = UIImage(named:"Mobile")
                cell.labelText.text = "Call us at"
                cell.buttonEmail.tag = 8
                cell.buttonEmail.setTitle("1800 209 1177", for:UIControl.State())
                cell.buttonEmail.addTarget(self, action:#selector(callOnMobileNumber), for:.touchUpInside)
            }
            return cell
        }
//        else if indexPath.row == 2{
//            let cell = tableView.dequeueReusableCellWithIdentifier("CallCell") as! CallCell
//            return cell
//        }
//        else if indexPath.row == 4{
//            let cell = tableView.dequeueReusableCellWithIdentifier("BuyHereCell") as! BuyHereCell
//           // cell.separatorInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, cell.bounds.size.width)
//            cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0);
//            return cell
//        }
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        //CGFloat rowHeight = 137.0
        var  rowHeight:CGFloat = 129.0
        if indexPath.row == 0 {
            rowHeight = 137.0
        }
//        else if indexPath.row == 2 {
//            rowHeight = 241
//        }
        else if indexPath.row == 4 {
            rowHeight = 60
        }
        return rowHeight
        
    }
    
    @objc func moveBackToDashboard() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func openLinkUrl() {
     UIApplication.shared.openURL(URL(string:"https://www.bluestarindia.com")!)
    }

    @objc func callOnMobileNumber() {
        let phone = "18002091177"
        if let phoneCallURL:URL = URL(string: "tel://\(phone)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
            }
        }
    }

    @objc func sendMail() {
        let mailComposeViewController = configuredMailComposeViewController()
        
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion:nil)
        } else {
            //   self.showSendMailErrorAlert()
        }

    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["customerservice@bluestarindia.com"])
        // mailComposerVC.setToRecipients([emailtxtField.text!])
        //mailComposerVC.setSubject("Sending you an in-app e-mail...")
        //        mailComposerVC.setMessageBody(self.messageTextView.text, isHTML: false)
        
        return mailComposerVC
    }

    
    internal func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        controller.dismiss(animated: true, completion:nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
