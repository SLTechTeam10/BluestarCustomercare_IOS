//
//  RegisterUserModel.swift
//  BlueStar
//
//  Created by tarun.kapil on 26/07/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import Foundation

class RegisterUserModel: NSObject {
    static let shareInstance = RegisterUserModel()
    var message : String?
    var errorMessage : String?
    var authKey : String?
    var status : String?
    
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
            
            if(checkKeyExist(KEY_AuthKey, dictionary: responseDictionary)) {
                if let responseauthKey : String = (responseDictionary.object(forKey: KEY_AuthKey) as? String){
                    authKey  = responseauthKey
                } else {
                    authKey = ""
                }
            }
        } else {
            errorMessage = parsingFailMessage
        }
    }
    
}
