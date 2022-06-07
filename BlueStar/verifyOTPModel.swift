//
//  verifyOTPModel.swift
//  BlueStar
//
//  Created by tarun.kapil on 25/07/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import Foundation

class verifyOTPModel: NSObject {
    static let shareInstance = verifyOTPModel()
    var message : String?
    var errorMessage : String?
    var authKey : String?
    var status : String?
    var user : Dictionary<String, AnyObject>?
    
    func parseResponseObject(_ response:AnyObject!) -> Void {
        if let responseDictionary: NSDictionary = response as? NSDictionary {
            if(checkKeyExist(KEY_Status, dictionary: responseDictionary)) {
                if let responseStatus : String = (responseDictionary.object(forKey: KEY_Status) as? String) {
                    status = responseStatus
                } else {
                    status = "NA"
                }
            }
            
            if(checkKeyExist(KEY_Message, dictionary: responseDictionary)){
                if let responsemessage : String = (responseDictionary.object(forKey: KEY_Message) as? String){
                    message  = responsemessage
                } else {
                    message = ""
                }
            }
            
            if(checkKeyExist(KEY_ErrorMessage, dictionary: responseDictionary)){
                if let responseErrorMessage : String = (responseDictionary.object(forKey: KEY_ErrorMessage) as? String){
                    errorMessage  = responseErrorMessage
                } else {
                    errorMessage = ""
                }
            }
            
            if(checkKeyExist(KEY_AuthKey, dictionary: responseDictionary)) {
                if let responseauthKey : String = (responseDictionary.object(forKey: KEY_AuthKey) as? String){
                    authKey  = responseauthKey
                } else {
                    authKey = ""
                }
            }
            
            if(checkKeyExist(KEY_User, dictionary: responseDictionary)){
                
                let temp: NSMutableArray = NSMutableArray()
                if let responseUser : Dictionary<String, AnyObject> = (responseDictionary.object(forKey: KEY_User) as? Dictionary<String, AnyObject>){
                    
//                    for userAddress in responseUser["addresses"] as! NSMutableArray{
//                        
//                        if !isNotNull(userAddress.objectForKey("locality")) {
//                            var dict: Dictionary<String, AnyObject> = userAddress as! Dictionary
//                            dict["locality"] = ""
//                            temp.addObject(dict)
//                        }else{
//                            temp.addObject(userAddress)
//                        }
//                    }
//                    responseUser["addresses"] = temp

                    user  = responseUser
                } else {
                    user = [:]
                }
            }
        } else {
            errorMessage = parsingFailMessage
        }
    }
    
}
