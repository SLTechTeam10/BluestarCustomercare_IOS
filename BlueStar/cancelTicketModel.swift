//
//  cancelTicketModel.swift
//  Blue Star
//
//  Created by Aditya Chitaliya on 06/03/17.
//  Copyright © 2017 BlueStar. All rights reserved.
//

import Foundation

class cancelTicketModel: NSObject {
    static let shareInstance = cancelTicketModel()
    var message : String?
//    var errorMessage : String?
    var authKey : String?
    var status : String?
    var user : Dictionary<String, AnyObject>?

       //var responseDictionary: NSDictionary
    func parseResponseObject(_ response:AnyObject!) -> Void {
        
        if let responseDictionary: NSDictionary = (response as? NSDictionary) {
            if(checkKeyExist(KEY_Status, dictionary: responseDictionary)) {
                if let responseStatus : String = (responseDictionary.object(forKey: KEY_Status) as? String) {
                    status = responseStatus
                    print(status)
                } else {
                    status = "NA"
                }
            }
            if(checkKeyExist(KEY_Message, dictionary: responseDictionary)){
                if let responsemessage : String = (responseDictionary.object(forKey: KEY_Message) as? String){
                    message  = responsemessage
                    print(message)
                } else {
                    message = ""
                }
            }
            if(checkKeyExist(KEY_AuthKey, dictionary: responseDictionary)) {
                if let responseauthKey : String = (responseDictionary.object(forKey: KEY_AuthKey) as? String){
                    authKey  = responseauthKey
                    print(authKey)
                } else {
                    authKey = ""
                }
            }
                    } else {
            message = parsingFailMessage
        }
    }
}
