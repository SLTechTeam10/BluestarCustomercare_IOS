//
//  getAddressModel.swift
//  Blue Star
//
//  Created by Aditya Chitaliya on 05/04/17.
//  Copyright © 2017 BlueStar. All rights reserved.
//

import Foundation
class getAddressModel: NSObject {
    static let shareInstance = getAddressModel()
    var message : String?
    var errorMessage : String?
    var authKey : String?
    var status : String?
    var addresses : NSArray?
    
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
                if let responseMessage : String = (responseDictionary.object(forKey: KEY_Message) as? String){
                    message  = responseMessage
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
            
            if(checkKeyExist(KEY_Address, dictionary: responseDictionary)){
                print(responseDictionary.object(forKey: KEY_Address))
                // let temp: NSMutableArray = NSMutableArray()
                if let responseAddress : NSArray = (responseDictionary.object(forKey: KEY_Address) as? NSArray){
                    
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
                    addresses  = responseAddress
                        
                } else {
                   // addresses = ""
                    addresses?.adding("")
                }
            }
            

        } else {
            errorMessage = parsingFailMessage
        }
    }

}
