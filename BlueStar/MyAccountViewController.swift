//
//  MyAccountViewController.swift
//  BlueStar
//
//  Created by tarun.kapil on 12/08/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class MyAccountViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate,ProfileProductTokenViewDelegate,UITableViewDelegate,UITableViewDataSource , MyProductTokenViewDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerNameLabel: UILabel!
    @IBOutlet weak var headerEmailLabel: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var addressesButton: UIButton!
    
    @IBOutlet weak var tableAddress: UITableView!
    
    
    // var profileView = ProfileView()
    var addressesView = AddressesView()
    
    var userData: NSDictionary!
    let dateFormatter = DateFormatter()
    var fromDate: Date!
    var toDate : Date!
    var fromAmPm : String!
    var toAmPm :String!
    //var dateDiff : int
    var setScroll = true
    var gotoAddress : Bool = false
    let checkedImage = UIImage(named: "check_box")! as UIImage
    let uncheckedImage = UIImage(named: "uncheck_box")! as UIImage
    var alternateNoPreference : String! = nil
    var  tokenViewheight:CGFloat = 50.0
    var cellProfileView:ProfileViewCell!
    var user:Dictionary<String, AnyObject> = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableAddress.isEditing=true
        setNavigationBar()
        headerView.backgroundColor = UIColor(netHex: 0x246cb0)
        
        setProfileHeaderData()
        //let user = PlistManager.sharedInstance.getValueForKey("user") as! NSDictionary
//        let addresses = user["addresses"] as! NSArray
//        UserAddressesDatabaseModel.shareInstance.addUserAddress(PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String, addresses)
//       let fetchAddrerss = UserAddressesDatabaseModel.shareInstance.getUserAddrress(PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String)
//        print(fetchAddrerss)
        //        headerLastSeenLabel.text = "Last seen 1 min ago"
       // let user: Dictionary<String,AnyObject> = UserDetailsDatabaseModel.shareInstance.getUserDetails(PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String )
       //print(user)
        //UserDetailsDatabaseModel.shareInstance.ParseUserDataToString(PlistManager.sharedInstance.getValueForKey("user") as! Dictionary<String, AnyObject>)
        //UserDetailsDatabaseModel.shareInstance.addUserDetails(PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String? ?? "", PlistManager.sharedInstance.getValueForKey("user") as! Dictionary<String, AnyObject>)
        
        setProfileView()
        setTabButtons()
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(updateAddresses), name: NSNotification.Name(rawValue: "updateAddresses"), object: nil)
         nc.addObserver(self, selector: #selector(self.getAddressFromMizeServer(_:)), name: NSNotification.Name(rawValue: "getAllAddressFromMize"), object: user)

        nc.addObserver(self, selector: #selector(updateProductSelection), name: NSNotification.Name(rawValue: "updateProductSelection"), object: nil)
        
        nc.addObserver(self, selector: #selector(alternateNumberSelection), name: NSNotification.Name(rawValue: "alternateNumber"), object: nil)
        
        if  ProductBL.shareInstance.resultProductData.allKeys.count > 0{
            
            ProductBL.shareInstance.selectedProducts.removeAllObjects()
            ProductBL.shareInstance.products.removeAllObjects()
            ProductBL.shareInstance.parseProductDataWithUserAlreadySelectedProducts(ProductBL.shareInstance.resultProductData)
            
        }else{
            serviceCallForProductList()
        }
        
        if (TicketHistoryModel.shareInstance.status != "success"){
            serviceCallToGetTicketStatus()
        }
        
        tableAddress.delegate = self
        tableAddress.dataSource = self
        tableAddress.tableFooterView = UIView()
        let nib = UINib(nibName: "ProfileViewCell", bundle: nil)
        tableAddress.register(nib, forCellReuseIdentifier:"ProfileViewCell")
        
        let nib2 = UINib(nibName: "TokenViewCell", bundle: nil)
        tableAddress.register(nib2, forCellReuseIdentifier: "TokenViewCell")
        
        
        self.tableAddress.estimatedRowHeight = 100.0;
        self.tableAddress.rowHeight = UITableView.automaticDimension;
        //tableAddress.reloadData()
        if(gotoAddress){
            self.addressesButtonAction(UIButton.init())
        }
//        addressesButtonAction(<#T##sender: AnyObject##AnyObject#>)
    }
    
    // #MARK:-  UITableView Delegates
    // #MARK:-
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let screenClass = self.classForCoder.description()
        Analytics.setScreenName("My Account Screen", screenClass: screenClass)
        Analytics.logEvent("page_view",parameters: ["page":"My Account Screen"])
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2//swiftBlogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            cellProfileView = tableView.dequeueReusableCell(withIdentifier: "ProfileViewCell") as! ProfileViewCell
            cellProfileView.titleTextField.delegate = self
            cellProfileView.firstNameTextField.delegate = self
            cellProfileView.lastNameTextField.delegate = self
            cellProfileView.alternateMobileNoTextField.delegate = self
            cellProfileView.emailTextField.delegate = self
            //cellProfileView.preferredTimeStartTextField.delegate = self
           // cellProfileView.preferredTimeEndTextField.delegate = self
            cellProfileView.buttonChooseProduct.addTarget(self, action: #selector(openProductList), for:.touchUpInside)
            //cellProfileView.buttonInfoTime.addTarget(self, action:#selector(timeInfoButtonAction), for: .touchUpInside)
            alternateNoPreference = userData["preferedCallingNumber"] as? String
            cellProfileView.titleTextField.text = (userData["title"] as! String).getTitleForCode()
            cellProfileView.firstNameTextField.text = userData["firstName"] as? String
            cellProfileView.lastNameTextField.text = userData["lastName"] as? String
            cellProfileView.primaryNoTextField.text=PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String?
            cellProfileView.gender.text = userData["gender"] as? String
            cellProfileView.ageGroup.text = userData["age"] as? String
            cellProfileView.alternateMobileNoTextField.text = userData["alternatemobilenumber"] as? String
            //print(alternateNoPreference)
            cellProfileView.emailTextField.text = userData["email"] as? String
            //print(userData)
//            if(cellProfileView.alternateMobileNoTextField.text != "")
//            {
//                cellProfileView.isChecked=false
//                cellProfileView.btn.setImage(uncheckedImage, for: .normal)
//                cellProfileView.primaryNoBtn.setImage(checkedImage, for: .normal)
//                
//            }
//            else
//            {
//                cellProfileView.isChecked=true
//                cellProfileView.btn.setImage(checkedImage, for: .normal)
//                cellProfileView.primaryNoBtn.setImage(uncheckedImage, for: .normal)
//            }
//            if(userData["alternateNoPreference"] == cellProfileView.primaryNoTextField.text){
//                
//            }
            
            if(cellProfileView.alternateMobileNoTextField.text != "")
            {
                cellProfileView.primaryNoBtn.isEnabled = true
                cellProfileView.btn.isEnabled = true
            }
            else
            {
                cellProfileView.primaryNoBtn.isEnabled = false
                cellProfileView.btn.isEnabled = false
            }
            //print("AlternPreference Number is:-\(alternateNoPreference)")
            if(alternateNoPreference == cellProfileView.primaryNoTextField.text){
                cellProfileView.btn.setImage(uncheckedImage, for: .normal)
                cellProfileView.primaryNoBtn.setImage(checkedImage, for: .normal)
                cellProfileView.isChecked=false
                
            }
            else{
                cellProfileView.btn.setImage(checkedImage, for: .normal)
                cellProfileView.primaryNoBtn.setImage(uncheckedImage, for: .normal)
                cellProfileView.isChecked=true
                cellProfileView.primaryNoBtn.isEnabled = true
                cellProfileView.btn.isEnabled = true
            }
            if let _ = userData["prefferedTimingFrom"] {
                let startTime = userData["prefferedTimingFrom"] as! String
                
                if startTime != "" {
                    dateFormatter.dateFormat = "HH:mm:ss"
                    let startDate = dateFormatter.date(from: startTime)
                    dateFormatter.dateFormat = "HH:mm"
                    let newStartTime = dateFormatter.string(from: startDate!)
                    cellProfileView.preferredTimeStartTextField.text = newStartTime
                    fromDate = dateFormatter.date(from: newStartTime)
                    dateFormatter.dateFormat = "HH"
                    //let hour:Int? = Int(dateFormatter.string(from: startDate!))
                    let calendar = NSCalendar.current
                    let components = calendar.component(.hour , from: startDate!)

                    if(components >= 00 && components <= 11){
                        fromAmPm = "am"
                    }
                    else
                    {
                        fromAmPm = "pm"
                    }
                    
                    //let dateDiff = Calendar.current.dateComponents([.hour, .minute], from: fromDate, to: toDate!).hour!
                }
            }
            
//            if let _ = userData["prefferedTimingTo"] {
//                let endTime = userData["prefferedTimingTo"] as! String
//
//                if endTime != "" {
//                    dateFormatter.dateFormat = "HH:mm:ss"
//                    let endDate = dateFormatter.date(from: endTime)
//                    dateFormatter.dateFormat = "HH:mm"
//                    let newEndTime = dateFormatter.string(from: endDate!)
//                    cellProfileView.preferredTimeEndTextField.text = newEndTime
//                    toDate = dateFormatter.date(from: newEndTime)
//                    //let hour:Int? = Int(dateFormatter.string(from: endDate!))
//                    let calendar = NSCalendar.current
//                    let components = calendar.component(.hour , from: endDate!)
//
//                    if(components >= 00 && components <= 11){
//                     toAmPm = "am"
//                    }
//                    else
//                    {
//                        toAmPm = "pm"
//                    }
//                   // print("\(toAmPm)")
//                }
//            }
            
            return cellProfileView
        }
        else if indexPath.row == 1{
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "TokenViewCell") as! TokenViewCell
            cell2.controller = self
            cell2.tokens = ProductBL.shareInstance.selectedProducts
            cell2.reloadTokenData()
            return cell2
        }
        let cell3 = tableView.dequeueReusableCell(withIdentifier: "TokenViewCell") as! TokenViewCell
        
        return cell3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    //
    //
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    }
    
    override func viewDidLayoutSubviews() {
//        var scrollViewInsets = UIEdgeInsets.zero
//        scrollViewInsets.top = -10
//        //        //scrollViewInsets.top -= profileView.contentView.bounds.size.height/10.0;
//        //        scrollViewInsets.bottom = scrollView.bounds.size.height
//        //        scrollViewInsets.bottom -= profileView.contentView.bounds.size.height*0.2;
//        //        scrollViewInsets.bottom -= 10
//        scrollView.contentInset = scrollViewInsets
//        if setScroll {
//            //scrollView.contentSize = CGSize(width: scrollView.bounds.size.width, height:profileView.tokenField.frame.origin.y+profileView.tokenField.frame.size.height+20)
//
//            //            scrollView.contentSize = CGSize(width: scrollView.bounds.size.width, height: 625)
//        }
////        scrollView.contentSize = CGSize(width: scrollView.bounds.size.width, height:ProfileView.tokenField.frame.origin.y+ProfileView.tokenField.frame.size.height+20)
    }
    
    func setProfileView() {
        //        tableAddress.reloadData()
        //        let rightButton = UIButton()
        //        rightButton.setTitle(" Save", forState: .Normal)
        //        rightButton.setImage(UIImage(named: IMG_Tick), forState: .Normal)
        //        rightButton.titleLabel?.font = UIFont(name: fontQuicksandBookRegular, size: 15)
        //        rightButton.frame = CGRectMake(0, 0, 70, 25)
        //        let lineViewLeft = UIView(frame: CGRectMake(0, 0, 1, rightButton.frame.size.height))
        //        lineViewLeft.backgroundColor = UIColor(netHex: 0x4F90D9)
        //        rightButton.addSubview(lineViewLeft)
        //        rightButton.addTarget(self, action: #selector(saveUserData), forControlEvents: .TouchUpInside)
        //        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        
        //            profileView = NSBundle.mainBundle().loadNibNamed("ProfileView", owner: self, options: nil)[0] as! ProfileView
        //            profileView.frame = CGRectMake(0, 10, scrollView.bounds.size.width,450)
        //
        //            //        scrollView.contentSize = CGSize(width: scrollView.bounds.size.width, height: 450)
        //
        //            profileView.tag = 1234
        //        scrollView.backgroundColor = UIColor.greenColor()
        //        profileView.contentView.backgroundColor = UIColor(red: 230, green: 230, blue: 230, alpha: 1.0)
        
        //        profileView.firstNameLabel.textColor = UIColor(netHex: 0x666666)
        //        let firstNameLabelTap = UITapGestureRecognizer(target: self, action: #selector(startEditingFirstName))
        //        profileView.firstNameLabel.userInteractionEnabled = true
        //        profileView.firstNameLabel.addGestureRecognizer(firstNameLabelTap)
        
        //        profileView.firstNameTextField.layer.addSublayer(createBorder(profileView.firstNameTextField, bottomColor: "grey"))
        //        profileView.firstNameTextField.layer.masksToBounds = true
        //        cellProfileView.firstNameTextField.text = userData["firstName"] as? String
        //
        //        profileView.lastNameLabel.textColor = UIColor(netHex: 0x666666)
        //        let lastNameLabelTap = UITapGestureRecognizer(target: self, action: #selector(startEditingLastName))
        //        profileView.lastNameLabel.userInteractionEnabled = true
        //        profileView.lastNameLabel.addGestureRecognizer(lastNameLabelTap)
        //        profileView.lastNameTextField.layer.addSublayer(createBorder(profileView.lastNameTextField, bottomColor: "grey"))
        //        profileView.lastNameTextField.layer.masksToBounds = true
        //        cellProfileView.lastNameTextField.text = userData["lastName"] as? String
        //
        //        profileView.alternateMobileNoLabel.textColor = UIColor(netHex: 0x666666)
        //        let alternateMobileNoLabelTap = UITapGestureRecognizer(target: self, action: #selector(startEditingAlternateMobileNo))
        //        profileView.alternateMobileNoLabel.userInteractionEnabled = true
        //        profileView.alternateMobileNoLabel.addGestureRecognizer(alternateMobileNoLabelTap)
        //        profileView.alternateMobileNoTextField.layer.addSublayer(createBorder(profileView.alternateMobileNoTextField, bottomColor: "grey"))
        //        profileView.alternateMobileNoTextField.layer.masksToBounds = true
        //        cellProfileView.alternateMobileNoTextField.text = userData["alternatemobilenumber"] as? String
        //
        //        profileView.emailLabel.textColor = UIColor(netHex: 0x666666)
        //        let emailLabelTap = UITapGestureRecognizer(target: self, action: #selector(startEditingEmail))
        //        profileView.emailLabel.userInteractionEnabled = true
        //        profileView.emailLabel.addGestureRecognizer(emailLabelTap)
        //        profileView.emailTextField.layer.addSublayer(createBorder(profileView.emailTextField, bottomColor: "grey"))
        //        profileView.emailTextField.layer.masksToBounds = true
        //        cellProfileView.emailTextField.text = userData["email"] as? String
        //
        //        profileView.preferredTimeLabel.textColor = UIColor(netHex: 0x666666)
        //        let preferredTimeLabelTap = UITapGestureRecognizer(target: self, action: #selector(startEditingPreferredTime))
        //        profileView.preferredTimeLabel.userInteractionEnabled = true
        //        profileView.preferredTimeLabel.addGestureRecognizer(preferredTimeLabelTap)
        //        profileView.preferredTimeHiphenLabel.textColor = UIColor(netHex: 0x666666)
        //        profileView.preferredTimeStartTextField.layer.addSublayer(createBorder(profileView.preferredTimeStartTextField, bottomColor: "grey"))
        //        profileView.preferredTimeStartTextField.layer.masksToBounds = true
        
        //        if let _ = userData["prefferedTimingFrom"] {
        //            let startTime = userData["prefferedTimingFrom"] as! String
        //
        //            if startTime != "" {
        //                dateFormatter.dateFormat = "HH:mm:ss"
        //                let startDate = dateFormatter.dateFromString(startTime)
        //                dateFormatter.dateFormat = "hh:mm a"
        //                let newStartTime = dateFormatter.stringFromDate(startDate!)
        //                cellProfileView.preferredTimeStartTextField.text = newStartTime
        //            }
        //        }
        
        //        profileView.preferredTimeEndTextField.layer.addSublayer(createBorder(profileView.preferredTimeEndTextField, bottomColor: "grey"))
        //        profileView.preferredTimeEndTextField.layer.masksToBounds = true
        
        //        if let _ = userData["prefferedTimingTo"] {
        //            let endTime = userData["prefferedTimingTo"] as! String
        //
        //            if endTime != "" {
        //                dateFormatter.dateFormat = "HH:mm:ss"
        //                let endDate = dateFormatter.dateFromString(endTime)
        //                dateFormatter.dateFormat = "hh:mm a"
        //                let newEndTime = dateFormatter.stringFromDate(endDate!)
        //                cellProfileView.preferredTimeEndTextField.text = newEndTime
        //            }
        //        }
        
        //        profileView.firstNameTextField.delegate = self
        //        profileView.lastNameTextField.delegate = self
        //        profileView.alternateMobileNoTextField.delegate = self
        //        profileView.emailTextField.delegate = self
        //        profileView.preferredTimeStartTextField.delegate = self
        //        profileView.preferredTimeEndTextField.delegate = self
        //        profileView.delegate = self
        //        if ProductBL.shareInstance.selectedProducts.count>0 {
        //            profileView.tokens = ProductBL.shareInstance.selectedProducts
        //            profileView.reloadTokenData()
        //        }
        //        profileView.buttonChooseProduct.addTarget(self, action: #selector(openProductList), forControlEvents:.TouchUpInside)
        //        scrollView.addSubview(profileView)
        //        scrollView.bringSubviewToFront(profileView.tokenField)
        //        scrollView.setContentOffset(CGPointZero, animated:false)
        //        scrollView.contentSize = CGSize(width: scrollView.bounds.size.width, height:profileView.tokenField.frame.origin.y+profileView.tokenField.frame.size.height+20)
        
    }
    
    func setProfileHeaderData() {
        let user = PlistManager.sharedInstance.getValueForKey("user") as! NSDictionary
        userData = user
        if (user["firstName"]! as! String).count != 0 {
            let firstName = user["firstName"] as! String
            let lastName = user["lastName"] as! String
            headerNameLabel.text = firstName + " " + lastName
            headerNameLabel.isHidden = false
        } else {
            headerNameLabel.isHidden = true
        }
        
        if (user["email"]! as! String).count != 0 {
            let email = user["email"] as! String
            headerEmailLabel.text = email
            headerEmailLabel.isHidden = false
        } else {
            headerEmailLabel.isHidden = true
        }

    }
    func setNavigationBar() {
        self.title = "My Account"
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
        
        let rightButton = UIButton()
        rightButton.setTitle(" Save", for: UIControl.State())
        rightButton.setImage(UIImage(named: IMG_Tick), for: UIControl.State())
        rightButton.titleLabel?.font = UIFont(name: fontQuicksandBookRegular, size: 15)
        rightButton.frame = CGRect(x: 0, y: 0, width: 70, height: 25)
        let lineViewLeft = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: rightButton.frame.size.height))
        lineViewLeft.backgroundColor = UIColor(netHex: 0x4F90D9)
        rightButton.addSubview(lineViewLeft)
        rightButton.addTarget(self, action: #selector(saveUserData), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        
    }
    
    func setTabButtons() {
        profileButton.backgroundColor = UIColor(netHex: 0x246cb0)
        addressesButton.backgroundColor = UIColor(netHex: 0x246cb0)
        let lineViewBottom = UIView(frame: CGRect(x: 0, y: profileButton.frame.size.height-2, width: view.bounds.size.width/2, height: 2))
        lineViewBottom.backgroundColor = UIColor(netHex: 0x00A98A)
        lineViewBottom.tag = 8765
        profileButton.addSubview(lineViewBottom)
    }
    
    func createBorder(_ textField: UITextField, bottomColor: String) -> CALayer {
        let border = CALayer()
        let width = CGFloat(1.0)
        if bottomColor == "grey" {
            border.borderColor = UIColor(netHex: 0xDEDFE0).cgColor
        } else if bottomColor == "blue" {
            border.borderColor = UIColor(netHex: 0x246cb0).cgColor
        }
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  view.bounds.size.width-40, height: textField.frame.size.height)
        border.borderWidth = width
        return border
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(textField == cellProfileView.alternateMobileNoTextField ) {
            
            let maxLength = 10
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            if(newLength == maxLength) {
               
                cellProfileView.primaryNoBtn.isEnabled = true
                cellProfileView.btn.isEnabled = true
                //cellProfileView.isChecked = true
                //cellProfileView.btn.setImage(checkedImage, for: .normal)
                //cellProfileView.primaryNoBtn.setImage(uncheckedImage, for: .normal)
            }
            else if(newLength < maxLength) {
                
                cellProfileView.primaryNoBtn.isEnabled = false
                cellProfileView.btn.isEnabled = false
                cellProfileView.isChecked = false
                cellProfileView.btn.setImage(uncheckedImage, for: .normal)
                cellProfileView.primaryNoBtn.setImage(checkedImage, for: .normal)
            }
            return newLength <= maxLength
        }
        else if(textField == cellProfileView.firstNameTextField || textField == cellProfileView.lastNameTextField)
        {
            let maxLength = 50
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            if  newLength <= maxLength{
                
                let inverseSet = CharacterSet(charactersIn:" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.&").inverted
                
                let components = string.components(separatedBy: inverseSet)
                
                let filtered = components.joined(separator: "")  // use join("", components) if you are using Swift 1.2
                
                return string == filtered
                
            }
            else{
                return false
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == cellProfileView.preferredTimeStartTextField {
//            startTimeAction()
//        } else if textField == cellProfileView.preferredTimeEndTextField {
//            endTimeAction()
//        }
        textField.layer.addSublayer(createBorder(textField, bottomColor: "blue"))
        textField.layer.masksToBounds = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.addSublayer(createBorder(textField, bottomColor: "grey"))
        textField.layer.masksToBounds = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func numberOfComponentsInPickerView(_ pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return securityQuestions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let data = securityQuestions[row]
        let pickerLabel = UILabel()
        pickerLabel.text = data["question"]
        pickerLabel.font = UIFont(name: fontQuicksandBookRegular, size: 15)
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let data = securityQuestions[row]
        
        //profileView.questionTextField.text = data["question"]
    }
        
    func endTimeAction() {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.time
        datePickerView.locale = Locale(identifier: "en_GB")
        datePickerView.minuteInterval=30
        cellProfileView.preferredTimeEndTextField.inputView = datePickerView
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(netHex:0x4F90D9)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(TextFieldTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(TextFieldTapped))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        cellProfileView.preferredTimeEndTextField.inputAccessoryView = toolBar
        
        datePickerView.addTarget(self, action: #selector(datePickerValueChangedTwo), for: UIControl.Event.valueChanged)
        
        dateFormatter.dateFormat =  "HH:mm"
        if let dates = dateFormatter.date(from: cellProfileView.preferredTimeEndTextField.text!){
            datePickerView.date = dates
        }
    }
    
    func startTimeAction() {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.time
        datePickerView.minuteInterval=30
        datePickerView.locale = Locale(identifier: "en_GB")

        cellProfileView.preferredTimeStartTextField.inputView = datePickerView
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(netHex:0x4F90D9)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(TextFieldTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(TextFieldTapped))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        cellProfileView.preferredTimeStartTextField.inputAccessoryView = toolBar
        
        datePickerView.addTarget(self, action: #selector(datePickerValueChangedOne), for: UIControl.Event.valueChanged)
        

        dateFormatter.dateFormat =  "HH:mm"
        if let dates = dateFormatter.date(from: cellProfileView.preferredTimeStartTextField.text!){
            datePickerView.date = dates
        }
        }
    
    @objc func datePickerValueChangedOne(_ sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        cellProfileView.preferredTimeStartTextField.text = dateFormatter.string(from: sender.date)
        cellProfileView.preferredTimeEndTextField.text = dateFormatter.string(from: sender.date.addingTimeInterval(3600))
        fromDate = dateFormatter.date(from: dateFormatter.string(from: sender.date))
        toDate = dateFormatter.date(from:  cellProfileView.preferredTimeEndTextField.text!)
        //let hour:Int? = Int(dateFormatter.string(from: fromDate!))!
        let calendar = NSCalendar.current
        let components = calendar.component(.hour , from: dateFormatter.date(from: dateFormatter.string(from: sender.date))!)
        
        if(components >= 00 && components <= 11){
            fromAmPm = "am"
        }
        else
        {
            fromAmPm = "pm"
        }
//        print("print here \(fromAmPm)")
       //datePickerView.setDate(NSDate(timeInterval: 0, since:sender.date) as Date, animated: false)
    }
    
    @objc func datePickerValueChangedTwo(_ sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        cellProfileView.preferredTimeEndTextField.text = dateFormatter.string(from: sender.date)
        let selectedDate = cellProfileView.preferredTimeStartTextField.text!
//        print("\(dateFormatter.string(from: sender.date))")
//        print("Seleted from is:-\(selectedDate)")
          toDate = dateFormatter.date(from: dateFormatter.string(from: sender.date))
        if(toDate.timeIntervalSince(fromDate) < 3600)
        {
            DataManager.shareInstance.showAlert(self, title: invaidDateTitle, message: invalidDateMessage)
        }
        //let hour:Int? = Int(dateFormatter.string(from: toDate!))!
        let calendar = NSCalendar.current
        let components = calendar.component(.hour , from: dateFormatter.date(from: dateFormatter.string(from: sender.date))!)
        
        if(components >= 00 && components <= 11){
            toAmPm = "am"
        }
        else
        {
            toAmPm = "pm"
        }
//        print("print here \(toAmPm)")
//        print("\(Calendar.current.dateComponents([.hour, .minute], from: fromDate, to: toDate!).hour!)")
//    
//                print("\((Calendar.current.dateComponents([.hour, .minute], from: fromDate, to: toDate!).minute!))")
//        let components = calendar.components([.Month, .Day], fromDate: date)
//        let dateDiff = calendar.dateComponents(Hour, from: fromDate, to:toDate )
//        let dateDiff = Calendar.current.dateComponents([.hour, .minute], from: fromDate, to: toDate!).hour!
    }

    @objc func TextFieldTapped(){
        //cellProfileView.preferredTimeStartTextField.resignFirstResponder()
       // cellProfileView.preferredTimeEndTextField.resignFirstResponder()
    }
    
    /*
     func securityQuestionAction() {
     let pickerView = UIPickerView()
     pickerView.delegate = self
     profileView.questionTextField.inputView = pickerView
     let toolBar = UIToolbar()
     toolBar.barStyle = UIBarStyle.Default
     toolBar.translucent = true
     toolBar.tintColor = UIColor(netHex:0x4F90D9)
     toolBar.sizeToFit()
     let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(questionTextFieldTapped))
     let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
     let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(questionTextFieldTapped))
     toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
     toolBar.userInteractionEnabled = true
     profileView.questionTextField.inputAccessoryView = toolBar
     }
     
     func questionTextFieldTapped(){
     profileView.questionTextField.resignFirstResponder()
     }
     
     func editQuestion() {
     profileView.questionTextField.becomeFirstResponder()
     }
     
     func showPin() {
     if profileView.pinTextField.secureTextEntry {
     profileView.pinTextField.secureTextEntry = false
     } else {
     profileView.pinTextField.secureTextEntry = true
     }
     }
     */
    
    @objc func moveBackToDashboard() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addressesButtonAction(_ sender: AnyObject) {
        
        self.view.endEditing(true)
        tableAddress.isHidden = true
        scrollView.isHidden = false
        setScroll = false
        profileButton.viewWithTag(8765)?.removeFromSuperview()
        for view in scrollView.subviews {
            if view.tag == 1234 {
                view.removeFromSuperview()
            }
        }
        
        let lineViewBottom = UIView(frame: CGRect(x: 0, y: addressesButton.frame.size.height-2, width: addressesButton.frame.size.width, height: 2))
        lineViewBottom.backgroundColor = UIColor(netHex: 0x00A98A)
        lineViewBottom.tag = 5678
        addressesButton.addSubview(lineViewBottom)
//         var user: Dictionary<String, AnyObject> = PlistManager.sharedInstance.getValueForKey("user") as! Dictionary<String, AnyObject>
        
        setAddressesView()
    }
    
    @IBAction func profileButtonAction(_ sender: AnyObject) {
        
        let rightButton = UIButton()
        rightButton.setTitle(" Save", for: UIControl.State())
        rightButton.setImage(UIImage(named: IMG_Tick), for: UIControl.State())
        rightButton.titleLabel?.font = UIFont(name: fontQuicksandBookRegular, size: 15)
        rightButton.frame = CGRect(x: 0, y: 0, width: 70, height: 25)
        let lineViewLeft = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: rightButton.frame.size.height))
        lineViewLeft.backgroundColor = UIColor(netHex: 0x4F90D9)
        rightButton.addSubview(lineViewLeft)
        rightButton.addTarget(self, action: #selector(saveUserData), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        
        tableAddress.isHidden = false
        scrollView.isHidden = true
        setScroll = true;
        addressesButton.viewWithTag(5678)?.removeFromSuperview()
        for view in scrollView.subviews {
            if view.tag == 4321 {
                view.removeFromSuperview()
            }
        }
        
        let lineViewBottom = UIView(frame: CGRect(x: 0, y: profileButton.frame.size.height-2, width: profileButton.frame.size.width, height: 2))
        lineViewBottom.backgroundColor = UIColor(netHex: 0x00A98A)
        lineViewBottom.tag = 8765
        profileButton.addSubview(lineViewBottom)
        setProfileView()
    }
    
    func startEditingFirstName() {
        cellProfileView.firstNameTextField.becomeFirstResponder()
    }
    
    func startEditingLastName() {
        cellProfileView.lastNameTextField.becomeFirstResponder()
    }
    
    func startEditingAlternateMobileNo() {
        cellProfileView.alternateMobileNoTextField.becomeFirstResponder()
    }
    
    func startEditingEmail() {
        cellProfileView.emailTextField.becomeFirstResponder()
    }
    
    func startEditingPreferredTime() {
        cellProfileView.preferredTimeStartTextField.becomeFirstResponder()
    }
    
    /*
     func startEditingQuestion() {
     profileView.questionTextField.becomeFirstResponder()
     }
     
     func startEditingAnswer() {
     profileView.answerTextField.becomeFirstResponder()
     }
     
     func startEditingPin() {
     profileView.pinTextField.becomeFirstResponder()
     }
     */
    
    
    func setAddressesView() {
        self.navigationItem.rightBarButtonItem = nil
        
        for view in scrollView.subviews {
            if view.tag == 4321 {
                view.removeFromSuperview()
            }
        }
        
        let addresses = UserAddressesDatabaseModel.shareInstance.getUserAddrress(PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String)
            //userData["addresses"] as! NSArray
        addressesView = Bundle.main.loadNibNamed("AddressesView", owner: self, options: nil)?[0] as! AddressesView
        addressesView.frame = CGRect(x: 0, y: 5, width: scrollView.bounds.size.width,height: 80+(138*CGFloat(addresses.count)))
        scrollView.contentSize = CGSize(width: scrollView.bounds.size.width, height: 80+(138*CGFloat(addresses.count)))
        addressesView.tag = 4321
        
        addressesView.addNewAddressButton.backgroundColor = UIColor(netHex: 0x00A98A)
        let tap = UITapGestureRecognizer(target: self, action: #selector(moveToAddAddressView))
        addressesView.addNewAddressButton.isUserInteractionEnabled = true
        addressesView.addNewAddressButton.addGestureRecognizer(tap)
        for (index, value) in addresses.enumerated() {
            let address = value as! Dictionary<String, AnyObject>
            let addressView = Bundle.main.loadNibNamed("AddressView", owner: self, options: nil)?[0] as! AddressView
            addressView.tag = 3456+index
            addressView.frame = CGRect(x: 20, y: 80+(138*CGFloat(index)), width: scrollView.bounds.size.width-40,height: 122)
            addressView.contentView.backgroundColor = UIColor(netHex: 0xF5F5F5)
            addressView.contentView.layer.cornerRadius = 3
            addressView.contentView.layer.borderColor = UIColor(netHex: 0xF1F1F2).cgColor
            addressView.contentView.layer.borderWidth = 1
//            if address["isPrimaryAddress"] as! String == "true" {
//                addressView.enableSwitch.isOn = true
//                addressView.deleteButton.isUserInteractionEnabled = false
//                addressView.deleteButton.setImage(UIImage(named: IMG_DeleteDisabled), for: UIControlState())
//            } else {
//                addressView.enableSwitch.isOn = false
//                addressView.deleteButton.isUserInteractionEnabled = true
//                addressView.deleteButton.setImage(UIImage(named: IMG_DeleteEnabled), for: UIControlState())
//            }
            addressView.addressLine1Label.textColor = UIColor(netHex: 0x666666)
            addressView.addressLine2Label.textColor = UIColor(netHex: 0x666666)
            addressView.addressLine3Label.textColor = UIColor(netHex: 0x666666)
            
            if let addd = address["address2"] {
                    addressView.addressLine1Label.text = "\(address["address1"]!), \(addd)"
                
            }else{
                addressView.addressLine1Label.text = "\(address["address1"]!)"
            }
            
            
            var locality = ""
            if let local = address["locality"]{
                locality = local as! String
            }
            var city = ""
            if let local = address["city"] {
                city = local as! String
            }
            if locality.trim() != "" {
                if(city.count>0){
                    addressView.addressLine2Label.text = "\(address["locality"]!), \(address["city"]!)"
                }else{
                    addressView.addressLine2Label.text = "\(address["locality"]!)"
                }
                
            }else{
                addressView.addressLine2Label.text = city
            }
            
            addressView.addressLine3Label.text = "\(address["state"]!) - \(address["pinCode"]!)"
            
            if let subType = address["subTypeCode"]{
                if(subType as! String == "Residential"){
                   
                    if let resConfig = address["residentialConfiguration"]{
                        print(resConfig)
                        if(resConfigs.contains(resConfig as! String)){
                            addressView.resConfigLabel.text = "Residential Configuration: " + (resConfig as! String)
                            addressView.editButton.isHidden = true
                        }else{
                            addressView.resConfigLabel.text = "Residential Configuration:"
                            addressView.editButton.isHidden = false
                        }
                        
                    }else{
                        addressView.resConfigLabel.text = "Residential Configuration:"
                        addressView.editButton.isHidden = false
                    }
                }else{
                    addressView.resConfigLabel.text = ""
                    if let comp = address["companyName"]{
                        addressView.resConfigLabel.text = comp as! String
                    }
                    
                }
            }
            
            
            addressView.editButton.addTarget(self, action: #selector(moveToEditAddressView(_:)), for: UIControl.Event.touchUpInside)
            if let custID = address["customerId"]{
                addressView.editButton.accessibilityLabel = custID as! String
                addressView.customerID.text = custID as! String
            }
            
            addressView.deleteButton.addTarget(self, action: #selector(deleteAddress(_:)), for: UIControl.Event.touchUpInside)
            addressView.deleteButton.tag = index
            addressView.editButton.setImage(UIImage(named: IMG_EditEnabled), for: UIControl.State())
            addressView.editButton.isUserInteractionEnabled = true
            addressView.enableSwitch.onTintColor = UIColor(netHex: 0x00A98A)
            addressView.enableSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            addressView.enableSwitch.tag = 3456+index
            if(addressView.enableSwitch.isOn == true) {
               
                addressView.enableSwitch.isUserInteractionEnabled = false
                addressView.enableSwitch.isOn = true
            }
            else {
                
                addressView.enableSwitch.isUserInteractionEnabled = true
                addressView.enableSwitch.addTarget(self, action: #selector(switchIsChanged(_:)), for: UIControl.Event.valueChanged)
            }
                        //hide switch if there is only one address
            if addresses.count == 1 {
                addressView.enableSwitch.isHidden = true
            }
            else {
                addressView.enableSwitch.isHidden = false
            }
            addressView.enableSwitch.isHidden = true   // NEW REQUIREMENT ALWAYS HIDE THIS BUTTON

            addressesView.addSubview(addressView)
            
            if addresses.count == 1 {
                addressView.deleteButton.isHidden = true
            }
        }
        
        scrollView.addSubview(addressesView)
        scrollView.setContentOffset(CGPoint.zero, animated:false)
    }
    
    @objc func switchIsChanged(_ enableSwitch: UISwitch) {
            let tag = enableSwitch.tag
            let addressView = addressesView.viewWithTag(tag) as! AddressView
            if enableSwitch.isOn {
                
                addressView.deleteButton.isUserInteractionEnabled = false
                addressView.deleteButton.setImage(UIImage(named: IMG_DeleteDisabled), for: UIControl.State())
            }
            else {
                
                addressView.deleteButton.isUserInteractionEnabled = true
                addressView.deleteButton.setImage(UIImage(named: IMG_DeleteEnabled), for: UIControl.State())
            }
            if NetworkChecker.isConnectedToNetwork() {
                showPlaceHolderView()
                var values: Dictionary<String, AnyObject> = [:]
                var user: Dictionary<String, AnyObject> = PlistManager.sharedInstance.getValueForKey("user") as! Dictionary<String, AnyObject>
                let addressIndex = tag-3456
                let addresses = user["addresses"] as! NSMutableArray
                if addresses.count > 1 {
                    let newAddresses: NSMutableArray = []
                    for (index, value) in addresses.enumerated() {
                        var address: Dictionary<String, AnyObject> = value as! Dictionary<String, AnyObject>
                        if index == addressIndex {
                            if enableSwitch.isOn {
                                address["isPrimaryAddress"] = "true" as AnyObject?
                                user["ibaseNumber"] = address["ibaseno"] as AnyObject?
                            } else {
                                address["isPrimaryAddress"] = "false" as AnyObject?
                            }
                        } else {
                            address["isPrimaryAddress"] = "false" as AnyObject?
                        }
                        newAddresses.add(address)
                    }
                    user["addresses"] = newAddresses
                    values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
                    values["user"] = user as AnyObject?
                    values["platform"] = platform as AnyObject?
                    values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
                    DataManager.shareInstance.getDataFromWebService(registerUserURL, dataDictionary:values as NSDictionary) { (result, error) -> Void in
                        if error == nil {
                            DispatchQueue.main.async {
                                self.hidePlaceHolderView()
                                RegisterUserModel.shareInstance.parseResponseObject(result)
                                let message = RegisterUserModel.shareInstance.errorMessage!
                                let status = RegisterUserModel.shareInstance.status!
                                if status == "error" {
                                    if message.lowercased().range(of: "index") != nil {
                                        DataManager.shareInstance.showAlert(self, title: primaryAddressTitle, message: onePrimaryAddressMessage)
                                    } else {
                                        DataManager.shareInstance.showAlert(self, title: messageTitle, message: message)
                                    }
                                    self.getAddress(user)
                                    //self.updateAddresses()
                                } else {
                                    self.getAddress(user)
                                    PlistManager.sharedInstance.saveValue(user as AnyObject, forKey: "user")
                                    //self.updateAddresses()
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
                    self.hidePlaceHolderView()
                    self.updateAddresses()
                    DataManager.shareInstance.showAlert(self, title: primaryAddressTitle, message: onePrimaryAddressMessage)
                }
            } else {
                DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
            }

}
    func getAddress(_ user:Dictionary<String, AnyObject>){
        var userdetail = user 
        var mobilenumber: Dictionary<String, AnyObject> = [:]
        mobilenumber["mobileno"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
        DataManager.shareInstance.getDataFromWebService(getCustomerAddressesURL, dataDictionary:mobilenumber as NSDictionary) { (result, error) -> Void in
            if error == nil {
                DispatchQueue.main.async {
                    getAddressModel.shareInstance.parseResponseObject(result)
                    let message = getAddressModel.shareInstance.errorMessage!
                    let status = getAddressModel.shareInstance.status!
                    if(status == "error"){
                    }else{
                        //var user: Dictionary<String, AnyObject> = PlistManager.sharedInstance.getValueForKey("user") as! Dictionary<String, AnyObject>
                        let adddreses = getAddressModel.shareInstance.addresses!
//                        print(adddresses)
                        userdetail["addresses"] = adddreses as AnyObject?
                        //print(userdetail["addresses"])
                        PlistManager.sharedInstance.saveValue(userdetail as AnyObject, forKey: "user")
                        var userData: NSDictionary!
                        userData = PlistManager.sharedInstance.getValueForKey("user") as! NSDictionary
                        //print(userData)
                        let nc = NotificationCenter.default
                        self.updateAddresses()
                    }
                }
            }else {
                DispatchQueue.main.async {
                    //self.hidePlaceHolderView()
                    if error?.code != -999 {
                        DataManager.shareInstance.showAlert(self, title: (error?.domain)!, message: (error?.localizedDescription)!)
                    }
                }
            }
        }
}
    
    @objc func getAddressFromMizeServer(_ user:Dictionary<String, AnyObject>){
        var userdetail = user
        var mobilenumber: Dictionary<String, AnyObject> = [:]
        mobilenumber["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
        mobilenumber["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
        DataManager.shareInstance.getDataFromWebService(getAllAddressURLMize, dataDictionary:mobilenumber as NSDictionary) { (result, error) -> Void in
            if error == nil {
                DispatchQueue.main.async {
                    getAddressModel.shareInstance.parseResponseObject(result)
                    let status = getAddressModel.shareInstance.status!
                    if(status == "error"){
                        let message = getAddressModel.shareInstance.errorMessage!
                    }else{
                        let adddreses = getAddressModel.shareInstance.addresses!
                        userdetail["addresses"] = adddreses as AnyObject?
                        PlistManager.sharedInstance.saveValue(userdetail as AnyObject, forKey: "user")
                        var userData: NSDictionary!
                        userData = PlistManager.sharedInstance.getValueForKey("user") as! NSDictionary
                       // let nc = NotificationCenter.default
//                        self.updateAddresses()
                        //let user = PlistManager.sharedInstance.getValueForKey("user") as! NSDictionary
                        self.userData = userData
                        self.setAddressesView()
                    }
                }
            }else {
                DispatchQueue.main.async {
                    //self.hidePlaceHolderView()
                    if error?.code != -999 {
                        DataManager.shareInstance.showAlert(self, title: (error?.domain)!, message: (error?.localizedDescription)!)
                    }
                }
            }
        }
    }
    
    @objc func moveToAddAddressView() {
//        let next = self.storyboard?.instantiateViewController(withIdentifier: "AddEditAddressView") as! AddAddressViewController
        let next = self.storyboard?.instantiateViewController(withIdentifier: "AddNewAddressViewController") as! AddNewAddressViewController

        navigationController?.pushViewController(next, animated: true)
    }
    
    @objc func saveUserData() {
        self.view.endEditing(true)
        if NetworkChecker.isConnectedToNetwork() {
            if validateFields() {
                showPlaceHolderView()
                var values: Dictionary<String, AnyObject> = [:]
                var user: Dictionary<String, AnyObject> = userData as! Dictionary<String, AnyObject>
                user["title"] = cellProfileView.titleTextField.text?.getTitleCode() as AnyObject//(cellProfileView.titleTextField.text?.trim())! as AnyObject?
                user["firstName"] = (cellProfileView.firstNameTextField.text?.trim())! as AnyObject?
                user["lastName"] = (cellProfileView.lastNameTextField.text?.trim())! as AnyObject?
//                user["primarymobilenumber"] = (cellProfileView.primaryNoTextField.text?.trim())! as AnyObject?
                user["alternatemobilenumber"] = (cellProfileView.alternateMobileNoTextField.text?.trim())! as AnyObject?
//                if(cellProfileView.isChecked == true)
//                {
//
//                    user["preferedCallingNumber"] = (cellProfileView.alternateMobileNoTextField.text?.trim())! as AnyObject?
//                }
//                else
//                {
//                    user["preferedCallingNumber"] = (cellProfileView.primaryNoTextField.text?.trim())! as AnyObject?
//                }
                /*
                 if(profileView.questionTextField.text?.trim() != "") {
                 var securityQuestionId: String! = ""
                 for value in securityQuestions {
                 if value["question"] == (profileView.questionTextField.text?.trim())! {
                 if value["id"]! != "0" {
                 securityQuestionId = value["id"]!
                 }
                 }
                 }
                 user["securityQuestionId"] = securityQuestionId
                 user["securityQuestionAnswer"] = (profileView.answerTextField.text?.trim())!
                 }
                 user["pin"] = (profileView.pinTextField.text?.trim())!
                 */
                
                user["email"] = (cellProfileView.emailTextField.text?.trim())! as AnyObject?
//                if((cellProfileView.preferredTimeStartTextField.text?.trim()) != "") {
//                    let time = (cellProfileView.preferredTimeStartTextField.text?.trim())!
//                    dateFormatter.dateFormat = "HH:mm"
//                    let date = dateFormatter.date(from: time)
//                    dateFormatter.dateFormat = "HH:mm:ss"
//                    let newTime = dateFormatter.string(from: date!)
//                    user["prefferedTimingFrom"] = newTime as AnyObject?
//                }
//                if((cellProfileView.preferredTimeEndTextField.text?.trim()) != "") {
//                    let time = (cellProfileView.preferredTimeEndTextField.text?.trim())!
//                    dateFormatter.dateFormat = "HH:mm"
//                    let date = dateFormatter.date(from: time)
//                    dateFormatter.dateFormat = "HH:mm:ss"
//                    let newTime = dateFormatter.string(from: date!)
//                    user["prefferedTimingTo"] = newTime as AnyObject?
//                }
                values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
                
                var productIds : String = ""
                if (ProductBL.shareInstance.selectedProducts.count>0) {
                    
                    for  product in ProductBL.shareInstance.selectedProducts {
                        let selectedProduct = product as! ProductData
                        productIds = productIds + selectedProduct.productId! + ","
                    }
                    if productIds.characters.count>1 {
                        productIds = String(productIds.characters.dropLast())
                    }
                    //print(productIds)
                }
                if productIds.characters.count>0 {
                    user["registeredProductsIds"] = productIds as AnyObject?
                }
                user .removeValue(forKey: "ibaseNumber")
                user .removeValue(forKey: "pin")
                user .removeValue(forKey: "preferedCallingNumber")
                user .removeValue(forKey: "alternateNoPreference")
                user .removeValue(forKey: "alternatemobilenumber")
                user["addresses"] = [] as NSArray
                values["user"] = user as AnyObject?
                values["platform"] = platform as AnyObject?
                values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
                
                //print("c \(values)")
                
                DataManager.shareInstance.getDataFromWebService(registerUserURLMize, dataDictionary:values as NSDictionary) { (result, error) -> Void in
                    if error == nil {
                        DispatchQueue.main.async {
                            self.hidePlaceHolderView()
                            RegisterUserModel.shareInstance.parseResponseObject(result)
                            let status = RegisterUserModel.shareInstance.status!
                            if status == "error" {
                                let message = RegisterUserModel.shareInstance.errorMessage!
                                DataManager.shareInstance.showAlert(self, title: messageTitle, message: message)
                            } else {
                                PlistManager.sharedInstance.saveValue(user as AnyObject, forKey: "user")
                                let refreshAlert = UIAlertController(title: "Success", message:"Profile has been updated.", preferredStyle: UIAlertController.Style.alert)
                                
                                self.tableAddress.reloadData()
                                self.setProfileHeaderData()
                                
                                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                    
                                    let nc = NotificationCenter.default
                                    nc.post(name: Notification.Name(rawValue: "reloadData"), object: nil)
                                    self.navigationController?.popViewController(animated: true)
                                    
                                    nc.post(name: Notification.Name(rawValue: "refreshProductsList"), object: nil)//refresh dashboard data
                                }))
                                self.present(refreshAlert, animated: true, completion: nil)
//                                self.tableAddress.reloadData()
//                                self.setProfileHeaderData()
//                                DataManager.shareInstance.showAlert(self, title:"Success", message: "Profile Updated Successfully")
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
            }
        } else {
            DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
        }
    }
    
    func validateFields() -> Bool {
        let number = (cellProfileView.alternateMobileNoTextField.text?.trim())!
        //var pin: String! = ""
//        let alternateNumber = (cellProfileView.alternateMobileNoTextField.text?.trim())!
//        if(cellProfileView.firstNameTextField.text?.trim() == "") {
//            DataManager.shareInstance.showAlert(self, title: invalidFirstNameTitle, message: invalidFirstNameMessage)
//            return false
//        }
//        else if(cellProfileView.firstNameTextField.text?.trim() != "" && !containsOnlyLetters((cellProfileView.firstNameTextField.text?.trim())!)) {
//            DataManager.shareInstance.showAlert(self, title: invalidFirstNameTitle, message: invalidNameMessage)
//            return false
//        }
        if(cellProfileView.lastNameTextField.text?.trim() == "") {
            DataManager.shareInstance.showAlert(self, title: invalidLastNameTitle, message: invalidLastNameMessage)
            return false
        }
//        else if(cellProfileView.lastNameTextField.text?.trim() != "" && !containsOnlyLetters((cellProfileView.lastNameTextField.text?.trim())!)) {
//            DataManager.shareInstance.showAlert(self, title: invalidLastNameTitle, message: invalidNameMessage)
//            return false
//        }
            /*
             else if((Calendar.current.dateComponents([.hour, .minute], from: fromDate, to: toDate!).hour! < 1 && (fromAmPm == toAmPm))){
             //            if((Calendar.current.dateComponents([.hour, .minute], from: fromDate, to: toDate!).hour! < 1)){
             //
             //                DataManager.shareInstance.showAlert(self, title: invaidDateTitle, message: invalidTimeMessage)
             //
             //            }
             //            else
             //            {
             DataManager.shareInstance.showAlert(self, title: invaidDateTitle, message: invalidDateMessage)
             // }
             }
             else if(((Calendar.current.dateComponents([.hour, .minute, ], from: fromDate, to: toDate!).hour! == -23) && ((Calendar.current.dateComponents([.minute], from: fromDate, to: toDate!).minute! == -30))) && (fromAmPm != toAmPm)){
             DataManager.shareInstance.showAlert(self, title: invaidDateTitle, message: invalidDateMessage)
             
             }
             //        else if((Calendar.current.dateComponents([.hour, .minute], from: fromDate, to: toDate!).hour! < 1 ) && ){
             //            DataManager.shareInstance.showAlert(self, title: invaidDateTitle, message: invalidDateMessage)
             //
             //        }
             
             //        else if((Calendar.current.dateComponents([.hour], from: fromDate).hour!) < (Calendar.current.dateComponents([.hour], from: toDate).hour!) && (fromAmPm == toAmPm)){
             //            
             //            DataManager.shareInstance.showAlert(self, title: invaidDateTitle, message: invalidTimeMessage)
             //
             //        }
 */
//        else if((Calendar.current.dateComponents([.hour, .minute], from: fromDate, to: toDate!).hour! < 1 && (fromAmPm == toAmPm))){
//            //if((Calendar.current.dateComponents([.hour, .minute], from: fromDate, to: toDate!).hour! < 1)){
//                
//                        DataManager.shareInstance.showAlert(self, title: invaidDateTitle, message: invalidTimeMessage)
//                
//                           // }
////            else
////            {
////                    DataManager.shareInstance.showAlert(self, title: invaidDateTitle, message: invalidDateMessage)
////            }
//            
//        }
// this--->       else if((Calendar.current.dateComponents([.hour, .minute], from: fromDate, to: toDate!).hour! < 1) && (fromAmPm == toAmPm)){
//            DataManager.shareInstance.showAlert(self, title: invaidDateTitle, message: invalidDateMessage)
// --->       }
// --->       else if((Calendar.current.dateComponents([.hour], from: fromDate).hour! > 12 && (Calendar.current.dateComponents([.hour], from: fromDate).hour! < 20) && (Calendar.current.dateComponents([.hour], from: toDate).hour! > ){
// --->       }
//        else if((Calendar.current.dateComponents([.hour, .minute], from: fromDate, to: toDate!).hour! == -23) && (Calendar.current.dateComponents([.hour, .minute], from: fromDate, to: toDate!).minute! == -30) && (fromAmPm != toAmPm)){
//            DataManager.shareInstance.showAlert(self, title: invaidDateTitle, message: invalidDateMessage)
//            
//        }
//        else if((Calendar.current.dateComponents([.hour, .minute], from: fromDate, to: toDate!).hour! == 0) && ((Calendar.current.dateComponents([.hour, .minute], from: fromDate, to: toDate!).minute! == 30) || (Calendar.current.dateComponents([.hour, .minute], from: fromDate, to: toDate!).minute! == 30) || (Calendar.current.dateComponents([.hour, .minute], from: fromDate, to: toDate!).minute! == -30) || (Calendar.current.dateComponents([.hour, .minute], from: fromDate, to: toDate!).minute! == 0))){
//            DataManager.shareInstance.showAlert(self, title: invaidDateTitle, message: invalidDateMessage)
//            return false
//        }
//        else if(((Calendar.current.dateComponents([.hour, .minute], from: fromDate, to: toDate!).hour! < 1))){
//            DataManager.shareInstance.showAlert(self, title: invaidDateTitle, message: invalidDateMessage)
//            return false
//
//        }
//        else if((Calendar.current.dateComponents([.hour], from: fromDate).hour!) >= 0 && (Calendar.current.dateComponents([.hour], from: fromDate).hour!) <= 12){
//           else if((Calendar.current.dateComponents([.hour], from: fromDate).hour!) > (Calendar.current.dateComponents([.hour], from: toDate!).hour!)){
//               // print("From Date is:-\((Calendar.current.dateComponents([.hour], from: fromDate).hour!))")
//           // print("to Date is:-\((Calendar.current.dateComponents([.hour], from: toDate!).hour!))")
//
//                DataManager.shareInstance.showAlert(self, title: invaidDateTitle, message: invalidDateMessage)
//                return false
//
//              }
     //   }
//            else if((Calendar.current.dateComponents([.hour], from: fromDate).hour!) > 12 && (Calendar.current.dateComponents([.hour], from: fromDate).hour!) <= 23){
//                if((Calendar.current.dateComponents([.hour], from: toDate).hour!) < (Calendar.current.dateComponents([.hour], from: fromDate).hour!)){
//                    DataManager.shareInstance.showAlert(self, title: invaidDateTitle, message: invalidDateMessage)
//                    return false
//            }
//        }
//        else if(cellProfileView.isChecked==true){
//               if (cellProfileView.alternateMobileNoTextField.text?.trim() != "" || cellProfileView.alternateMobileNoTextField.text?.trim() == ""){
//                       if(!number.isNumeric || alternateNumber.characters.count < 10) {
//                        DataManager.shareInstance.showAlert(self, title: invalidAlternateNumberTitle, message:invalidAlternateNumberMessage)
//                return false
//                }
//               }
//
//            }
//        else if(alternateNumber != nil && alternateNumber.characters.count > 0 && alternateNumber.characters.count < 10){
//            DataManager.shareInstance.showAlert(self, title: invalidAlternateNumberTitle, message:invalidAlternateNumberMessage)
//            return false
//        }
//        else if(cellProfileView.emailTextField.text?.trim() != "" && !isValidEmail(cellProfileView.emailTextField.text!.trim())) {
//            DataManager.shareInstance.showAlert(self, title: invalidEmailTitle, message: invalidEmailMessage)
//            return false
//        }
        else if(ProductBL.shareInstance.selectedProducts.count==0){
            DataManager.shareInstance.showAlert(self, title: "Product", message:"Please select at least one product from the dropdown list.")
            return false
        }
        
        /*
         else if(profileView.questionTextField.text?.trim() != "" && profileView.questionTextField.text?.trim() != "Security Question" && profileView.answerTextField.text?.trim() == "") {
         DataManager.shareInstance.showAlert(self, title: invalidAnswerTitle, message: invalidAnswerMessage)
         return false
         }
         else if(profileView.pinTextField.text?.trim() != "") {
         pin = (profileView.pinTextField.text?.trim())!
         if(pin.characters.count < 4 || !pin.isNumeric) {
         DataManager.shareInstance.showAlert(self, title: invalidPinTitle, message: invalidPinMessage)
         return false
         } else if(pin.characters.count == 4 && (profileView.questionTextField.text?.trim() == "" || profileView.questionTextField.text?.trim() == "Security Question")) {
         DataManager.shareInstance.showAlert(self, title: invalidQuestionTitle, message: invalidQuestionMessage)
         return false
         }
         }
         */
        return true
    }
    
    func isValidEmail(_ emailId:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
         //"/^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,3})$/"
        
        //let emailRegEx = "[_a-z0-9-]+[_a-z0-9-]*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,3})$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailId)
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
    
    @objc func moveToEditAddressView(_ editButton: UIButton) {
        let tag = editButton.accessibilityLabel
        print("Edit-->",tag)
        
//        let addresses = userData["addresses"] as! NSArray
        let addresses = UserAddressesDatabaseModel.shareInstance.getUserAddrress(PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String)
        for id in addresses {
            if let aaa = id as? [String: Any], let customerId = aaa["customerId"] as? String {
                if(customerId == tag){
                    let address = aaa as NSDictionary
                    let next = self.storyboard?.instantiateViewController(withIdentifier: "AddNewAddressViewController") as! AddNewAddressViewController
                    next.editSelectedAdd = address as! [String : Any]
                    navigationController?.pushViewController(next, animated: true)
                    break
                }
            }
        }
        
        
        /*next.navigationBarTitle = "Edit Address"
        next.ibaseCode = address["ibaseno"] as? String
        next.address = address["address"] as? String
        next.pincode = address["pinCode"] as? String
        next.locality = address["locality"] as? String
        next.city = address["city"] as? String
        next.state = address["state"] as? String
        next.primary = address["isPrimaryAddress"] as? String
        next.editAddressID = (address.value(forKey: "addressid") as? String)
        next.addressTag = tag*/
        
        
        //print(next.editAddressID)
    }
    
    @objc func deleteAddress(_ deleteButton: UIButton) {
        let refreshAlert = UIAlertController(title: "", message: "Are you sure you want to delete this address?", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            let tag = deleteButton.tag
           
            let address: NSArray = UserAddressesDatabaseModel.shareInstance.getUserAddrress(PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String)
            if(address.count>1){
                if let custID = (address.object(at: tag) as! NSDictionary).value(forKey: "customerId"){
                    UserAddressesDatabaseModel.shareInstance.UpdateAddressAsInActive(for: PlistManager.sharedInstance.getValueForKey("mobileNumber") as! String, forCustomerId: (address.object(at: tag) as! NSDictionary).value(forKey: "customerId") as! String)
                }
                
                self.updateAddresses()
            }else{
                 DataManager.shareInstance.showAlert(self, title: errorTitle, message: "One address must be active")
            }
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
//    func apiCallForDeleteAddress(){
//        if NetworkChecker.isConnectedToNetwork() {
//            if self.validateFields() {
//                self.showPlaceHolderView()
//                var values: Dictionary<String, AnyObject> = [:]
//                var user: Dictionary<String, AnyObject> = PlistManager.sharedInstance.getValueForKey("user") as! Dictionary<String, AnyObject>
//                let addresses = user["addresses"] as! NSMutableArray
//                addresses.removeObject(at: tag)
//                user["addresses"] = addresses
//                values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
//                values["user"] = user as AnyObject?
//                values["platform"] = platform as AnyObject?
//                values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
//
//                DataManager.shareInstance.getDataFromWebService(registerUserURL, dataDictionary:values as NSDictionary) { (result, error) -> Void in
//                    if error == nil {
//                        DispatchQueue.main.async {
//                            self.hidePlaceHolderView()
//                            RegisterUserModel.shareInstance.parseResponseObject(result)
//                            let message = RegisterUserModel.shareInstance.errorMessage!
//                            let status = RegisterUserModel.shareInstance.status!
//                            if status == "error" {
//                                if message.lowercased().range(of: "index") != nil {
//                                    DataManager.shareInstance.showAlert(self, title: primaryAddressTitle, message: primaryAddressMessage)
//                                } else {
//                                    DataManager.shareInstance.showAlert(self, title: messageTitle, message: message)
//                                }
//                                self.updateAddresses()
//                            } else {
//                                PlistManager.sharedInstance.saveValue(user as AnyObject, forKey: "user")
//                                self.updateAddresses()
//                            }
//                        }
//                    } else {
//                        DispatchQueue.main.async {
//                            self.hidePlaceHolderView()
//                            if error?.code != -999 {
//                                DataManager.shareInstance.showAlert(self, title: errorTitle, message: errorMessage)
//                            }
//                        }
//                    }
//                }
//            }
//        } else {
//            DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
//        }
//    }
    
    @objc func updateAddresses() {
        let user = PlistManager.sharedInstance.getValueForKey("user") as! NSDictionary
        self.userData = user
        self.setAddressesView()
    }
    
    func containsOnlyLetters(_ input: String) -> Bool {
        for chr in input.characters {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                return false
            }
        }
        return true
    }

    @objc func openProductList() {
        //open product List
        let vc : ProductListPickerVC =  ProductListPickerVC(nibName: "ProductListPickerVC", bundle: nil)
        self.present(vc, animated: true, completion: nil)
    }
    func timeInfoButtonAction() {
        DataManager.shareInstance.showAlert(self, title: "Preferred time", message:"Enter your preferred time of technician visit.")
    }
   
    @objc func updateProductSelection(_ notification:Notification)  {
        DispatchQueue.main.async {
            UIView.performWithoutAnimation {
                self.tableAddress.beginUpdates()
                let indexPath = IndexPath(item: 1, section: 0)
                self.tableAddress.reloadRows(at: [indexPath], with: .none)//        }
                self.tableAddress.endUpdates()
               // self.scrollToBottom()
            }
        }
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 1, section: 0)
            self.tableAddress.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    @objc func alternateNumberSelection(_ notification:Notification) {
        
        DispatchQueue.main.async {
            
            self.tableAddress.reloadData()
        }
    }
    
    func tokenViewTotalHeight(_ tokenViewSize: CGSize) {
        //        tokenViewheight = tokenViewSize.height+16
        //        var productTokenViewFrame:CGRect = cellProfileView.tokenField.frame
        //        productTokenViewFrame.size.height = tokenViewSize.height
        //        cellProfileView.tokenField.frame = productTokenViewFrame
        //
        //        scrollView.contentSize = CGSize(width: scrollView.bounds.size.width, height:cellProfileView.tokenField.frame.origin.y+cellProfileView.tokenField.frame.size.height+20)
    }
    
    // #MARK:-
    // #MARK:-  Api call
    func serviceCallForProductList() {
        
        if NetworkChecker.isConnectedToNetwork() {
            var values: Dictionary<String, AnyObject> = [:]
            values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
            values["platform"] = platform as AnyObject?
            values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
            showPlaceHolderView()
            
            DataManager.shareInstance.getDataFromWebService(productListURLMize, dataDictionary:values as NSDictionary) { (result, error) -> Void in
                if error == nil {
                    DispatchQueue.main.async {
                        self.hidePlaceHolderView()
                        
                        if let responseDictionary: NSDictionary = result as? NSDictionary {
                            if(checkKeyExist(KEY_Status, dictionary: responseDictionary)) {
                                if let responseStatus : String = (responseDictionary.object(forKey: KEY_Status) as? String) {
                                    if responseStatus == "success"{
                                        
                                        ProductBL.shareInstance.selectedProducts.removeAllObjects()
                                        ProductBL.shareInstance.products.removeAllObjects()
                                        ProductBL.shareInstance.parseProductDataWithUserAlreadySelectedProducts(result)
                                        
                                        ProductBL.shareInstance.resultProductData = responseDictionary
                                        
                                        //self.profileView.reloadTokenData()
                                        self.tableAddress.reloadData()
                                        
                                        
                                    }else{
                                        DataManager.shareInstance.showAlert(self, title: errorTitle, message: errorMessage)
                                    }
                                    
                                } else {
                                    DataManager.shareInstance.showAlert(self, title: errorTitle, message: errorMessage)
                                    
                                }
                            }
                        }
                        /*
                         ProductListModel.shareInstance.parseResponseObject(result)
                         let status: String = ProductListModel.shareInstance.status!
                         if status == "success" {
                         //                            self.productList = ProductListModel.shareInstance.products!
                         //                            self.refactorData()
                         } else {
                         DataManager.shareInstance.showAlert(self, title: errorTitle, message: errorMessage)
                         }
                         //                        self.registerDeviceToken()
                         */
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
    
    func serviceCallToGetTicketStatus(){
        
        self.showPlaceHolderView()
        if NetworkChecker.isConnectedToNetwork() {
            var values: Dictionary<String, AnyObject> = [:]
            values["mobileNumber"] = PlistManager.sharedInstance.getValueForKey("mobileNumber")
            values["platform"] = platform as AnyObject?
            values["authKey"] = PlistManager.sharedInstance.getValueForKey("authKey")
            DataManager.shareInstance.getDataFromWebService(ticketHistoryURLMize, dataDictionary:values as NSDictionary) { (result, error) -> Void in
                if error == nil {
                    DispatchQueue.main.async {
                        self.hidePlaceHolderView()
                        TicketHistoryModel.shareInstance.parseResponseObject(result)
//                        let status: String = TicketHistoryModel.shareInstance.status!
//                        if status == "success" {
//                            
//                        } else {
//                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.hidePlaceHolderView()
                        if error?.code != -999 {
                            // DataManager.shareInstance.showAlert(self, title: errorTitle, message: errorMessage)
                        }
                    }
                }
            }
        } else {
            self.hidePlaceHolderView()
            DataManager.shareInstance.showAlert(self, title: noInternetTitle, message: noInternetMessage)
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
