//
//  FAQVC.swift
//  Blue Star
//
//  Created by Kamlesh on 1/3/17.
//  Copyright © 2017 BlueStar. All rights reserved.
//

import UIKit
import WebKit
import FirebaseAnalytics

class FAQVC: UIViewController, WKUIDelegate,WKNavigationDelegate {
    var webView: WKWebView!

    @IBOutlet weak var webViewContainer: UIView!

    fileprivate func setUI(){
        self.title = "FAQs"

        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: IMG_Back), for: UIControl.State())
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.addTarget(self, action: #selector(moveBackToDashboard), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let screenClass = self.classForCoder.description()
        Analytics.setScreenName("FAQ Screen", screenClass: screenClass)
        Analytics.logEvent("page_view",parameters: ["page":"FAQ Screen"])
    }
    @objc func moveBackToDashboard() {
        if(webView.canGoBack){
            webView.goBack()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.loadFaqWebView()
    }
    
    fileprivate func loadFaqWebView(){
        //Script for scale page to fit. Set this scrpit in configuration
        let jScript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
        let wkUScript = WKUserScript(source: jScript, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
        let wkUController = WKUserContentController()
        wkUController.addUserScript(wkUScript)
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController = wkUController
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView

        /*
        let fileURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("faqLp", ofType: "html")!)
        if #available(iOS 9.0, *) {
            webView.loadFileURL(fileURL, allowingReadAccessToURL: fileURL)
        } else {
            DataManager.shareInstance.showAlert(self, title: "", message: "The FAQ section will work on iOS 9+ for local html files")
        }        
        */
        
        showPlaceHolderView()
        //let myURL = NSURL(string: "https://www.apple.com")
        let myRequest = URLRequest(url:URL(string:FAQsURL)!)
        webView.load(myRequest)
        
    }
    
    /* Start the network activity indicator when the web view is loading */
    func webView(_ webView: WKWebView,didStartProvisionalNavigation navigation: WKNavigation){
         
    }
    
    /* Stop the network activity indicator when the loading finishes */
    func webView(_ webView: WKWebView,didFinish navigation: WKNavigation){
        hidePlaceHolderView()
    }
    
//    func webView(webView: WKWebView,
//                 decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse,decisionHandler: ((WKNavigationResponsePolicy) -> Void)){
//        //print(navigationResponse.response.MIMEType)
//        decisionHandler(.Allow)
//        
//    }

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
}
