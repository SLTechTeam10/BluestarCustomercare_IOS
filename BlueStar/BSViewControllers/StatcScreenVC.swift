//
//  StatcScreenVC.swift
//  Blue Star
//
//  Created by Kamlesh on 11/21/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class StatcScreenVC: UIViewController,UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    var isPrivacy:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doAdditionalViewSetUp()
        
        showPlaceHolderView()
        loadHtmlPage()
        // Do any additional setup after loading the view.
    }
    
    func doAdditionalViewSetUp()  {
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
        
        webView.delegate = self
        if isPrivacy {
            self.title = "Privacy Policy"
        }else{
            self.title = "Terms of Use"
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let screenClass = self.classForCoder.description()
        if isPrivacy{
            Analytics.setScreenName("Privacy Policy Screen", screenClass: screenClass)
            Analytics.logEvent("page_view",parameters: ["page":"Privacy Policy Screen"])
        }else{
            Analytics.setScreenName("Terms of Use Screen", screenClass: screenClass)
            Analytics.logEvent("page_view",parameters: ["page":"Terms of Use Screen"])
        }
        
    }
    func loadHtmlPage() {
        if isPrivacy {
            let htmlFile = Bundle.main.path(forResource: "privacy", ofType: "html")
            let html = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)
            webView.loadHTMLString(html!, baseURL: nil)
        }else{
            let htmlFile = Bundle.main.path(forResource: "terms", ofType: "html")
            let html = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)
            webView.loadHTMLString(html!, baseURL: nil)
        }
    }
    
    func webViewDidStartLoad(_ webView : UIWebView) {
        //UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
    }
    
    func webViewDidFinishLoad(_ webView : UIWebView) {
        //UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        hidePlaceHolderView()
    }
    
    
    @objc func moveBackToDashboard() {
        navigationController?.popViewController(animated: true)
    }
    
    
    func showPlaceHolderView() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller:UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "PlaceHolderView")
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
