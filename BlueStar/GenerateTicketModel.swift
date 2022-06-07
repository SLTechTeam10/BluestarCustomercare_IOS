//
//  GenerateTicketModel.swift
//  BlueStar
//
//  Created by tarun.kapil on 26/08/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import Foundation

class GenerateTicketModel: NSObject {
    static let shareInstance = GenerateTicketModel()
    var message : String?
    var errorMessage : String?
    var authKey : String?
    var status : String?
    var ticketNumber : String?
    var productName : String?
    var progressStatus : String?
    var productId : String?
    var updatedOn : String?
    //var updates : String?
    var isAlreadyGenerated : Bool?
    var modelNo:String?
    var serialNo:String?
    
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
            
            if(checkKeyExist(KEY_TicketNumber, dictionary: responseDictionary)) {
                if isNotNull(responseDictionary.object(forKey: KEY_TicketNumber) as AnyObject?) {
                    if let responsTicketNumber : String = (responseDictionary.object(forKey: KEY_TicketNumber) as? String){
                        ticketNumber  = responsTicketNumber
                    } else {
                        ticketNumber = ""
                    }
                } else {
                    ticketNumber = ""
                }
            }
            
            if(checkKeyExist(KEY_ProductName, dictionary: responseDictionary)) {
                if isNotNull(responseDictionary.object(forKey: KEY_ProductName) as AnyObject?) {
                    if let responseProductName : String = (responseDictionary.object(forKey: KEY_ProductName) as? String){
                        productName  = responseProductName
                    } else {
                        productName = ""
                    }
                } else {
                    productName = ""
                }
            }
            
            if(checkKeyExist(KEY_ProgressStatus, dictionary: responseDictionary)) {
                if let responseProgressStatus : String = (responseDictionary.object(forKey: KEY_ProgressStatus) as? String){
                    progressStatus  = responseProgressStatus
                } else {
                    progressStatus = ""
                }
            }
            
            if(checkKeyExist(KEY_ProductId, dictionary: responseDictionary)) {
                if let responseProductId : String = (responseDictionary.object(forKey: KEY_ProductId) as? String){
                    productId  = responseProductId
                } else {
                    productId = ""
                }
            }
            
            if(checkKeyExist(KEY_UpdatedOn, dictionary: responseDictionary)) {
                if let responseUpdatedOn : String = (responseDictionary.object(forKey: KEY_UpdatedOn) as? String){
                    updatedOn = responseUpdatedOn
                } else {
                    updatedOn = ""
                }
            }
            
//            if(checkKeyExist(KEY_Updates, dictionary: responseDictionary)) {
//                if let responseUpdates : String = (responseDictionary.object(forKey: KEY_Updates) as? String)!{
//                    updates = responseUpdates
//                } else {
//                    updates = ""
//                }
//            }
//            
            if(checkKeyExist(KEY_IsAlreadyGenerated, dictionary: responseDictionary)) {
                if let responseIsAlreadyGenerated : Bool = (responseDictionary.object(forKey: KEY_IsAlreadyGenerated) as? Bool){
                    isAlreadyGenerated  = responseIsAlreadyGenerated
                } else {
                    isAlreadyGenerated = nil
                }
            }
            
            if(checkKeyExist(KEY_ModelNo, dictionary: responseDictionary)) {
                if let responseModelNo : String = (responseDictionary.object(forKey: KEY_ModelNo) as? String){
                    modelNo  = responseModelNo
                } else {
                    modelNo = ""
                }
            } else {
                modelNo = ""
            }
            
            if(checkKeyExist(KEY_SerialNo, dictionary: responseDictionary)) {
                if let responseSerialNo : String = (responseDictionary.object(forKey: KEY_SerialNo) as? String){
                    serialNo  = responseSerialNo
                } else {
                    serialNo = ""
                }
            } else {
                serialNo = ""
            }
        } else {
            errorMessage = parsingFailMessage
        }
    }
    
}
