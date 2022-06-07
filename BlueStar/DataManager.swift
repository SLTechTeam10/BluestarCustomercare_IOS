 //
//  DataManager.swift
//  BlueStar
//
//  Created by Tarun on 19/07/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import Foundation
import Alamofire

let KEY_DATA_HANDLER = "webHandlerQueue"

class DataManager: NSObject
{
    static let shareInstance = DataManager()
    var manager = Alamofire.SessionManager.self
    
    let headersForMize: HTTPHeaders =
        [
            "Content-Type": "application/json",
            "x-api-key" : x_api_key,
            "Accept" : "application/json"
    ]
    
    let headersForBSL: HTTPHeaders =
        [
            "Content-Type": "application/json"
    ]
    
    //Common Method to call post services
    func getDataFromWebService(_ url:String,dataDictionary:NSDictionary,completionHandler:@escaping (_ result: AnyObject?,_ error:NSError?) -> Void)
    {
        
//        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
//        configuration.timeoutIntervalForRequest = 400 // seconds
//        configuration.timeoutIntervalForResource = 400
//        manager = Alamofire.Manager(configuration: configuration)

        print("Server URL :: \(url)")
        print("PACKET :: \(dataDictionary)")
        
        let headers : HTTPHeaders
        headers = headersForMize
        
//        if url.range(of:"m-ize") != nil {
//            headers = headersForMize
//        } else {
//            headers = headersForBSL
//        }
        
//        let headers: HTTPHeaders =
//        [
//            "Content-Type": "application/json"
//        ]
      

     Alamofire.request(url, method: .post, parameters: dataDictionary as? [String : AnyObject], encoding: JSONEncoding(options: []), headers: headers).responseJSON(queue: DispatchQueue.global(), options: .allowFragments)
       {
            response in
            debugPrint(response)
        
        if(response.response?.statusCode != 200){
            let msg = response.result.value as! NSDictionary

            if (url == generateTicketURLMize && response.response?.statusCode == 400 && checkKeyExist("errorInfo", dictionary: msg)) {
                let errMsg = msg.value(forKey: "errorInfo") as! String
                if errMsg == "Service Ticket already exist with this combination." {
                    let error = NSError(domain: "Error", code: 0, userInfo: [NSLocalizedDescriptionKey : "A service ticket is already open for this equipment. Please call the helpline for details."])
                    completionHandler(nil, error)
                } else {
                    let error = NSError(domain: "Error", code: 0, userInfo: [NSLocalizedDescriptionKey : "Unable to generate ticket. Please contact customer care for more details."])
                    completionHandler(nil, error)
                }
                return
            }
            
//            if msg.value(forKey: "errorMessage") != nil {
//                print("EORRasdasd")
//            }
//            DataManager.shareInstance.showAlert1(title: "Error", message: msg.value(forKey: "errorMessage") as! String)

            
            if(checkKeyExist("errorMessage", dictionary: msg)) {
                let errMsg = msg.value(forKey: "errorMessage") as! String
                if errMsg == "Mobile Number and AuthKey combination is not valid." {
                    print("INVALID CRED")
                    DispatchQueue.main.async {
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.logoutFromApp()
                    }
                    return
                }
            }
            /********************* LOGIC FOR ANDROID *************************/
//            if (retrofitError.getUrl().equals("https://api.m-ize.com/bluestarccapp-dev/ccapp/generateTicket") &&
//                retrofitError.getResponse().getStatus() == 400 && errorModel.errorsInfo != null) {
//
//                if (errorModel.errorsInfo.equals("Service Ticket already exist with this combination."))
//                errorModel.errorMessage = "A service ticket is already open for this equipment. Please call the helpline for details.";
//                else if (!errorModel.errorsInfo.equals("Service Ticket already exist with this combination.")) {
//                    errorModel.errorMessage = "Unable to generate ticket. Please contact customer care for more details";
//                }
//            }
            
            if (url == generateTicketURLMize && response.response?.statusCode == 400 && checkKeyExist("errorsInfo", dictionary: msg)) {
                let errMsg = msg.value(forKey: "errorsInfo") as! String
                if errMsg == "Service Ticket already exist with this combination." {
                    let error = NSError(domain: "Error", code: 0, userInfo: [NSLocalizedDescriptionKey : "A service ticket is already open for this equipment. Please call the helpline for details."])
                    completionHandler(nil, error)
                } else {
                    let error = NSError(domain: "Error", code: 0, userInfo: [NSLocalizedDescriptionKey : "Unable to generate ticket. Please contact customer care for more details."])
                    completionHandler(nil, error)
                }
                //                completionHandler(response.result.value! as AnyObject?, nil)
                return
            }
          
            if(checkKeyExist("errorMessage", dictionary: msg)) {
                
                
                let error = NSError(domain: "Error", code: 0, userInfo: [NSLocalizedDescriptionKey : msg.value(forKey: "errorMessage") as! String])
                completionHandler(nil, error)
            } else {
                let error = NSError(domain: "Error", code: 0, userInfo:[NSLocalizedDescriptionKey : "There was an error, please try again later"])
                completionHandler(nil, error)
            }
            
            return
        }
        
            if(response.result.error == nil)
            {
                completionHandler(response.result.value! as AnyObject?, nil)
            }
            else
            {
                completionHandler(nil, response.result.error! as NSError?)
            }
        
        }
    }
    
    func getDataFromMizeWebService(_ url:String,dataDictionary:NSDictionary,completionHandler:@escaping (_ result: AnyObject?,_ error:NSError?) -> Void)
    {
        
        print("Server URL :: \(url)")
        print("PACKET :: \(dataDictionary)")

        let headers: HTTPHeaders =
            [
                "Content-Type": "application/json",
                "x-api-key":x_api_key,
                "Accept":"application/json"
        ]
        
        
        Alamofire.request(url, method: .post, parameters: dataDictionary as? [String : AnyObject], encoding: JSONEncoding(options: []), headers: headers).responseJSON(queue: DispatchQueue.global(), options: .allowFragments)
        {
            response in
            debugPrint(response)
            
            if(response.response?.statusCode != 200){
                
                let msg = response.result.value! as! NSDictionary
                
                if(checkKeyExist("errorMessage", dictionary: msg)) {
                    let errMsg = msg.value(forKey: "errorMessage") as! String
                    if errMsg == "Mobile Number and AuthKey combination is not valid." {
                        print("INVALID CRED")
                        DispatchQueue.main.async {
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.logoutFromApp()
                        }
                        return
                    }
                }
                
                /********************* LOGIC FOR ANDROID *************************/
                //            if (retrofitError.getUrl().equals("https://api.m-ize.com/bluestarccapp-dev/ccapp/generateTicket") &&
                //                retrofitError.getResponse().getStatus() == 400 && errorModel.errorsInfo != null) {
                //
                //                if (errorModel.errorsInfo.equals("Service Ticket already exist with this combination."))
                //                errorModel.errorMessage = "A service ticket is already open for this equipment. Please call the helpline for details.";
                //                else if (!errorModel.errorsInfo.equals("Service Ticket already exist with this combination.")) {
                //                    errorModel.errorMessage = "Unable to generate ticket. Please contact customer care for more details";
                //                }
                //            }
                
                if (url == generateTicketURLMize && response.response?.statusCode == 400 && checkKeyExist("errorsInfo", dictionary: msg)) {
                    let errMsg = msg.value(forKey: "errorsInfo") as! String
                    if errMsg == "Service Ticket already exist with this combination." {
                        let error = NSError(domain: "Error", code: 0, userInfo: [NSLocalizedDescriptionKey : "A service ticket is already open for this equipment. Please call the helpline for details."])
                        completionHandler(nil, error)
                    } else {
                        let error = NSError(domain: "Error", code: 0, userInfo: [NSLocalizedDescriptionKey : "Unable to generate ticket. Please contact customer care for more details."])
                        completionHandler(nil, error)
                    }
                    //                completionHandler(response.result.value! as AnyObject?, nil)
                    return
                }
                
                if(checkKeyExist("errorMessage", dictionary: msg)) {
                    let error = NSError(domain: "Error", code: 0, userInfo: [NSLocalizedDescriptionKey : msg.value(forKey: "errorMessage") as! String])
                    completionHandler(nil, error)
                } else {
                    let error = NSError(domain: "Error", code: 0, userInfo:[NSLocalizedDescriptionKey : "There was an error, please try again later"])
                    completionHandler(nil, error)
                }
                
                //            if url == "https://api.m-ize.com/bluestarccapp-dev/ccapp/productFamilyList" {
                //                completionHandler(response.result.value! as AnyObject?, nil)
                //                return
                //            }
                
                //            if msg.value(forKey: "errorMessage") != nil {
                //                print("EORRasdasd")
                //            }
                //            DataManager.shareInstance.showAlert1(title: "Error", message: msg.value(forKey: "errorMessage") as! String)
                return
            }
            if(response.result.error == nil)
            {
                completionHandler(response.result.value! as AnyObject?, nil)
            }
            else
            {
                completionHandler(nil, response.result.error! as NSError?)
            }
        }
    }
    
    func forceupdateAPI(_ url:String,dataDictionary:NSDictionary, completionHandler:@escaping (_ result: AnyObject?,_ error:NSError?) -> Void)
    {
        print(dataDictionary)
        print(url)
        
        
        Alamofire.request(url, method: .get, parameters: dataDictionary as? [String : AnyObject], encoding: JSONEncoding(options: []), headers: headersForMize).responseJSON(queue: DispatchQueue.global(), options: .allowFragments)
        {
            response in
            debugPrint(response)
            if(response.result.error == nil)
            {
                completionHandler(response.result.value! as AnyObject?, nil)
            }
            else
            {
                completionHandler(nil, response.result.error! as NSError?)
            }
        }
    }

    
//    Alamofire.request(url,method: .post,parameters: dataDictionary as? [String : AnyObject],encoding: JSONEncoding(options: []),headers: headers).responseJSON
//    {
//        response in
//        debugPrint(response)
//        if(response.result.error == nil)
//        {
//            completionHandler(response.result.value! as AnyObject?, nil)
//        }
//        else
//        {
//            completionHandler(nil, response.result.error! as NSError?)
//        }
//    }
    
    
    //Common Method for showing alert
    func showAlert(_ vc:UIViewController,title:String,message:String) -> Void
    {
        DispatchQueue.main.async
        {
            let alert = UIAlertController(title:title, message:message, preferredStyle: .alert)
            alert.view.frame = UIScreen.main.applicationFrame
            let action = UIAlertAction(title:oKey, style: .default)
            { _ in
//                vc.dismiss(animated: true, completion: nil)
                alert.dismiss(animated: true)
            }
            alert.addAction(action)
            vc.present(alert, animated: true)
            {}
        }
    }
    func showPopAlert(_ vc:UIViewController,title:String,message:String) -> Void
    {
        print("pop function UIA controller")
        DispatchQueue.main.async
        {
            let alert = UIAlertController(title:title, message:message, preferredStyle: .alert)
            alert.view.frame = UIScreen.main.applicationFrame
            let action = UIAlertAction(title:oKey, style: .default)
            { _ in
                //vc.dismiss(animated: true, completion: nil)
                alert.dismiss(animated: true)
            }
            alert.addAction(action)
            vc.present(alert, animated: true)
            {}
        }
    }
    
    func showAlert1(title:String,message:String) -> Void
    {
        DispatchQueue.main.async
            {
                let alert = UIAlertController(title:title, message:message, preferredStyle: .alert)
                alert.view.frame = UIScreen.main.applicationFrame
                let action = UIAlertAction(title:oKey, style: .default)
                { _ in
                    alert.dismiss(animated: true, completion: nil)
                    if let viewControllers = UIApplication.shared.delegate?.window??.rootViewController?.children {
                        for viewController in viewControllers {
                            // some process
                            if(viewController.restorationIdentifier == "PlaceHolderView"){
                                print("ACTIVITY")
                                //                        viewController.dismiss(animated: true, completion: nil)
//                            UIApplication.shared.delegate?.window??.rootViewController?
//                                UIApplication.shared.delegate?.window
//                                let wd = UIApplication.shared.delegate?.window
//                                var vc = wd!?.rootViewController
                                DispatchQueue.main.async {
                                    viewController.dismiss(animated: true, completion: nil)
                                    viewController.removeFromParent()
                                    
                                    if let viewWithTag = viewController.view.viewWithTag(100) {
                                        viewWithTag.removeFromSuperview()
                                    }
                                }
                            }
                        }
                    }
                }
                alert.addAction(action)
//                vc.present(alert, animated: true)
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)

            
        }
    }
    
    func stopTheDamnRequests(){
        if #available(iOS 9.0, *) {
            Alamofire.SessionManager.default.session.getAllTasks { (tasks) in
                tasks.forEach{ $0.cancel() }
            }
        } else {
            Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
                sessionDataTask.forEach { $0.cancel() }
                uploadData.forEach { $0.cancel() }
                downloadData.forEach { $0.cancel() }
            }
        }
    }
    
    // NOTE : POST REQUEST WITH SERIALIZATION

    func postRequest(urlString:String, parameters: [String: Any], completionHandler:@escaping (_ result: AnyObject?,_ error:NSError?) -> Void) {
        
        Alamofire.request(urlString,method: .post,parameters: parameters as [String : Any],encoding: JSONEncoding(options: [])).responseJSON
        {
            response in
            debugPrint(response)
            if(response.result.error == nil)
            {
                completionHandler(response.result.value! as AnyObject?, nil)
            }
            else
            {
                completionHandler(nil, response.result.error! as NSError?)
            }
          }
        }
    
    func getRequest(urlString:String, completionHandler:@escaping (_ result: AnyObject?,_ error:NSError?) -> Void) {
        
        Alamofire.request(urlString,method: .get,encoding: JSONEncoding(options: [])).responseJSON
        {
            response in
            debugPrint(response)
            if(response.result.error == nil)
            {
                completionHandler(response.result.value! as AnyObject?, nil)
            }
            else
            {
                completionHandler(nil, response.result.error! as NSError?)
            }
          }
        }
}

