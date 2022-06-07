//
//  FollowTicketModel.swift
//  BlueStar
//
//  Created by tarun.kapil on 05/09/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import Foundation

class FollowTicketModel: NSObject {
    static let shareInstance = FollowTicketModel()
    var message : String?
    var errorMessage : String?
    var authKey : String?
    var status : String?
    var ticketNumber : String?
    var productName : String?
    var progressStatus : String?
    var productId : String?
    var updatedOn : String?
    
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
                if let responsTicketNumber : String = (responseDictionary.object(forKey: KEY_TicketNumber) as? String){
                    ticketNumber  = responsTicketNumber
                } else {
                    ticketNumber = ""
                }
            }
            
            if(checkKeyExist(KEY_ProductName, dictionary: responseDictionary)) {
                if let responseProductName : String = (responseDictionary.object(forKey: KEY_ProductName) as? String){
                    productName  = responseProductName
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
        } else {
            errorMessage = parsingFailMessage
        }
    }
    
}
