//
//  AboutUsVC.swift
//  Blue Star
//
//  Created by Kamlesh on 11/22/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class AboutUsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableAboutUs: UITableView!

    @IBOutlet weak var tableAboutUs2: UITableView!
    //    let arrayMenu = [["icon":"logo_without_bottom_text", "label":"v 1.8"], ["icon":"at", "label":"https://www.bluestarindia.com"], ["icon":"linkedin", "label":"bluestarindia"], ["icon":"twitter", "label":"@bluestarindia"]]
    let arrayMenu = [["icon":"bluestar_logo_new", "label":"v 1.2.0"], ["icon":"at", "label":"https://www.bluestarindia.com"]]
    let nsObject: AnyObject?  = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        doAdditionalViewSetUp()
        // Do any additional setup after loading the view.
        //let nsObject: AnyObject? = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]
        
         tableAboutUs.tableFooterView = UIView()
        let nib = UINib(nibName: "AboutUsCell", bundle: nil)
        self.tableAboutUs.register(nib, forCellReuseIdentifier:"AboutUsCell")
        // data hammer
        tableAboutUs.reloadData()
         
        /*
        tableAboutUs2.tableFooterView = UIView()
        let nib = UINib(nibName: "AboutUsCell", bundle: nil)
        self.tableAboutUs2.register(nib, forCellReuseIdentifier:"AboutUsCell")
        // data hammer
        tableAboutUs2.reloadData()
         */

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let screenClass = self.classForCoder.description()
        Analytics.setScreenName("About Us Screen", screenClass: screenClass)
        Analytics.logEvent("page_view",parameters: ["page":"About Us Screen"])
    }
    func doAdditionalViewSetUp()  {
        self.title = "About"
        
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
        return arrayMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutUsCell") as! AboutUsCell
        let data = arrayMenu[indexPath.row]
        //cell.menuIconImageView.image = UIImage(named: data["icon"]!)
        cell.imageViewLogo.image = UIImage(named: data["icon"]!)
        cell.labelText.text = data["label"]
        
        if indexPath.row == 0 {
            let version = nsObject as! String
            cell.labelText.text = "v " + version
        }
        else if indexPath.row == 1 {
            cell.topSpaceConstrain.constant = 5
            cell.separatorInset = UIEdgeInsets.init(top: 0, left: self.view.bounds.size.width, bottom: 0, right: 0);


            let handler = {
                (hyperLabel: FRHyperLabel?, substring: String?) -> Void in
                UIApplication.shared.openURL(URL(string:data["label"]!)!)
            }

            cell.labelText.setLinksForSubstrings([data["label"]!], withLinkHandler: handler)

        }
        return cell
        
    }
    
    
    @objc func moveBackToDashboard() {
        navigationController?.popViewController(animated: true)
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
