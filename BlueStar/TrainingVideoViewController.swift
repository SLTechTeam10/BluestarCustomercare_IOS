//
//  TrainingVideoViewController.swift
//  BlueStar
//
//  Created by aditya.chitaliya on 01/10/18.
//  Copyright © 2018 BlueStar. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class TrainingVideoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {
    @IBOutlet weak var languageListView: UITableView!
    @IBOutlet weak var videoListView: UITableView!
    @IBOutlet weak var lblSelectedLanguage: UILabel!
    @IBOutlet weak var selectLanguageListHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var hiddenView: UIView!
    var hindiVideoURLList: NSMutableArray = []
    var englishVideoURLList: NSMutableArray = []
    var languageList:NSMutableArray = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Training Videos"
        languageListView.separatorStyle = .none
        videoListView.separatorStyle = .none
        lblSelectedLanguage.drawText(in: lblSelectedLanguage.frame)
        //lblSelectedLanguage.
        hindiVideoURLList = ["o-LI4fjriRA"]
        englishVideoURLList = ["4ZJTEAHeKwY"]
        languageList = ["English","Hindi"]
        //print(ProductList.shareInstance.ProductData)
        //languageListView.isHidden = true
        hiddenView.isHidden = true
        lblSelectedLanguage.text = "English"
        
         lblSelectedLanguage.draw(lblSelectedLanguage.frame.inset(by: UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 0)))
        videoListView.register(UINib(nibName: "videoCellTableViewCell", bundle: nil), forCellReuseIdentifier: "videoCell")
        languageListView.register(UINib(nibName: "SelectLanguageTableViewCell", bundle: nil), forCellReuseIdentifier: "languageCell")
                //languageListView.frame = CGRect(x: languageListView.frame.origin.x, y: languageListView.frame.origin.y, width: languageListView.frame.size.width, height: 30)
        if(self.view.frame.size.height > CGFloat(languageList.count*30) - 80){
            selectLanguageListHeightConstraint.constant = CGFloat(languageList.count*30)
            
        }else{
             selectLanguageListHeightConstraint.constant = self.view.frame.size.height - 80
        }
        
        //Add Tap Gesture To hide language listView
        let hideLanguageListViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(hideLanguageListView))
        self.hiddenView.addGestureRecognizer(hideLanguageListViewTapGesture)
        hideLanguageListViewTapGesture.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let screenClass = self.classForCoder.description()
        Analytics.setScreenName("Training Videos Screen", screenClass: screenClass)
        Analytics.logEvent("page_view",parameters: ["page":"Training Videos Screen"])
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool{
        if (touch.view?.isDescendant(of: languageListView))!{
            return false;
        }
        return true;
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func displayDropDown(_ sender: Any) {
        if(hiddenView.isHidden){
            self.view.bringSubviewToFront(hiddenView)
            //languageListView.isHidden = false
            hiddenView.isHidden = false
            languageListView.reloadData()
            
        }
        else{
            hiddenView.isHidden = true
            //languageListView.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == languageListView){
            if(languageListView.isHidden){
                return 0
            }else{
                return languageList.count
            }
            
        }else{
            if lblSelectedLanguage.text == "Hindi"{
                return hindiVideoURLList.count
            }else{
                return englishVideoURLList.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == languageListView){
            return 30
        }else{
            return 250
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tableView == languageListView){
            // let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! videoCellTableViewCell
            var cell = tableView.dequeueReusableCell(withIdentifier: "languageCell", for: indexPath) as! SelectLanguageTableViewCell
            cell = setupSelectLanguageCell(forCell: cell, onIndex: indexPath)
            return cell
        }else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! videoCellTableViewCell
            cell.btnPlayVideo.tag = indexPath.row
            //            if(lblSelectedLanguage.text == "Hindi"){
            cell = self.setupVideoCell(forCell: cell, onIndex: indexPath)
            //            }else{
            //               cell = self.setupSelectLanguageCell(forCell: cell, onIndex: indexPath)
            //            }
            cell.btnPlayVideo.addTarget(self, action: #selector(playVideo(for:)), for: .touchUpInside)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == languageListView){
            let cell = tableView.cellForRow(at: indexPath) as! SelectLanguageTableViewCell
            lblSelectedLanguage.text = cell.lblLanguageName.text!
            //languageListView.isHidden = true
            hiddenView.isHidden = true
            videoListView.reloadData()
        }else{
            if NetworkChecker.isConnectedToNetwork() {
                let youtubeId: NSString!
                if(lblSelectedLanguage.text == "Hindi"){
                    youtubeId = hindiVideoURLList.object(at: indexPath.row) as? NSString
                    //"SxTYjptEzZs"
                }else{
                    youtubeId = englishVideoURLList.object(at: indexPath.row) as? NSString
                }
                
                var youtubeUrl = NSURL(string:"www.youtube://\(youtubeId!)")!
                if UIApplication.shared.canOpenURL(youtubeUrl as URL){
                    // UIApplication.shared.openURL(youtubeUrl as URL)
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(youtubeUrl as URL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(youtubeUrl as URL)
                    }
                } else{
                    youtubeUrl = NSURL(string:"https://www.youtube.com/watch?v=\(youtubeId!)")!
                    // UIApplication.shared.openURL(youtubeUrl as URL)
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(youtubeUrl as URL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(youtubeUrl as URL)
                        // Fallback on earlier versions
                    }
                }
            } else {
                DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
            }
        }
    }
    
    func setupSelectLanguageCell(forCell cell:SelectLanguageTableViewCell,onIndex indexPath:IndexPath) -> SelectLanguageTableViewCell {
        cell.lblLanguageName.text = languageList.object(at: indexPath.row) as? String
        return cell
    }
    
    func setupVideoCell(forCell cell:videoCellTableViewCell,onIndex indexPath:IndexPath) -> videoCellTableViewCell {
        
        //cell.LblVideoName.text = lblSelectedLanguage.text!+" Video" + String(indexPath.row)
        //cell.videoImage.im
        var ImgURL: String
        if(lblSelectedLanguage.text == "Hindi"){
            cell.LblVideoName.text = "Blue Star AC Remote Control Functions (Hindi)"
           // ImgURL = "https://img.youtube.com/vi/" + String(describing:hindiVideoURLList.object(at: indexPath.row))
           // let imageUrl = URL(string: ImgURL+"/0.jpg")
           // cell.videoImage.af_setImage(withURL: imageUrl!, placeholderImage: nil)
        }else{
           cell.LblVideoName.text =  "Blue Star AC Remote Control Functions"
          //  ImgURL = "https://img.youtube.com/vi/" + String(describing:englishVideoURLList.object(at: indexPath.row))
           // let imageUrl = URL(string: ImgURL+"/0.jpg")
           // cell.videoImage.af_setImage(withURL: imageUrl!, placeholderImage: nil)
        }
        return cell
    }
    
    @objc func playVideo(for button: UIButton){
         if NetworkChecker.isConnectedToNetwork() {
        let youtubeId: NSString!
        if(lblSelectedLanguage.text == "Hindi"){
            youtubeId = hindiVideoURLList.object(at: button.tag) as? NSString
            //"SxTYjptEzZs"
        }else{
            youtubeId = englishVideoURLList.object(at: button.tag) as? NSString
        }
        
        var youtubeUrl = NSURL(string:"www.youtube://\(youtubeId!)")!
        if UIApplication.shared.canOpenURL(youtubeUrl as URL){
            // UIApplication.shared.openURL(youtubeUrl as URL)
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(youtubeUrl as URL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            } else {
                UIApplication.shared.openURL(youtubeUrl as URL)
            }
        } else{
            youtubeUrl = NSURL(string:"https://www.youtube.com/watch?v=\(youtubeId!)")!
            // UIApplication.shared.openURL(youtubeUrl as URL)
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(youtubeUrl as URL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            } else {
                UIApplication.shared.openURL(youtubeUrl as URL)
                // Fallback on earlier versions
            }
        }
         } else {
            DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
        }
    }
    func moveBackToDashboard() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func hideLanguageListView(recognizer: UITapGestureRecognizer) {
        hiddenView.isHidden = true
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
