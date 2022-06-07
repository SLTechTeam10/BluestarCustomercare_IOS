//
//  FAQViewController.swift
//  BlueStar
//
//  Created by tarun.kapil on 05/08/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class FAQViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var selectedIndex : Int! = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let screenClass = self.classForCoder.description()
        Analytics.setScreenName("FAQ Screen", screenClass: screenClass)
        Analytics.logEvent("page_view",parameters: ["page":"FAQ Screen"])
    }
    func setNavigationBar() {
        self.title = "FAQs"
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return FAQData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell : FAQTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "FAQCell", for: indexPath) as? FAQTableViewCell)!
        let data = FAQData[indexPath.row]
        cell.FAQLabel.text = data["question"]!
        cell.FAQLabel.textColor = UIColor(netHex: 0x666666)
        cell.bottomLineLabel.backgroundColor = UIColor(netHex: 0xDEDFE0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateCells()
        let currentCell = tableView.cellForRow(at: indexPath)! as! FAQTableViewCell
        let data = FAQData[indexPath.row]
        let viewHeight = calculateHeightForString(data["answer"]!)
        print(viewHeight)
        var answerView = FAQAnswerView()
        answerView = Bundle.main.loadNibNamed("FAQAnswerView", owner: self, options: nil)?[0] as! FAQAnswerView
        answerView.answerTextView.text = data["answer"]
        answerView.answerTextView.isUserInteractionEnabled = false
        answerView.answerTextView.font = UIFont(name: fontQuicksandBookRegular, size: 12)
        answerView.answerTextView.textColor = UIColor(netHex: 0x246cb0)
        answerView.answerTextView.backgroundColor = UIColor(netHex: 0xE9F2FF)
        answerView.answerView.backgroundColor = UIColor(netHex: 0xE9F2FF)
        let imageView = UIImageView(image: UIImage(named: IMG_FAQTriangle))
        imageView.frame = CGRect(x: 20, y: -19, width: 25, height: 25)
        answerView.addSubview(imageView)
        answerView.frame = CGRect(x: 0,y: 60,width: self.tableView.frame.size.width, height: viewHeight)
        answerView.tag = 1234
        if indexPath.row == selectedIndex {
            selectedIndex = -1
        } else {
            currentCell.addSubview(answerView)
            selectedIndex = indexPath.row
        }
        self.tableView.reloadData()
        self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.none, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == selectedIndex {
            let data = FAQData[indexPath.row]
            let viewHeight = calculateHeightForString(data["answer"]!)
            return viewHeight+90
        } else {
            return 62
        }
    }
    
    func calculateHeightForString(_ inString:String) -> CGFloat {
        let messageString = inString
        let attributes = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: fontQuicksandBookRegular, size: 12)!]
        let attrString:NSAttributedString? = NSAttributedString(string: messageString, attributes: convertToOptionalNSAttributedStringKeyDictionary(attributes))
        let rect:CGRect = attrString!.boundingRect(with: CGSize(width: 300.0,height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, context:nil )
        let requredSize:CGRect = rect
        return requredSize.height
    }
    
    func updateCells() {
        for index in 0...FAQData.count {
            let indexPath = IndexPath(row: index, section: 0)
            let cell = self.tableView.cellForRow(at: indexPath)
            if cell != nil {
                cell!.viewWithTag(1234)?.removeFromSuperview()
            }
        }
    }

    @objc func moveBackToDashboard() {
        navigationController?.popViewController(animated: true)
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
