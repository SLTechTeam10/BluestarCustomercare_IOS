//
//  EquipmentListModel.swift
//  BlueStar
//
//  Created by aditya.chitaliya on 25/10/18.
//  Copyright © 2018 BlueStar. All rights reserved.
//

import Foundation
class EquipmentListModel: NSObject {
    static let shareInstance = EquipmentListModel()
    var message : String?
    var errorMessage : String?
    var authKey : String?
    var status : String?
    //var products : NSArray?
    var allEquipment : NSArray?
  //  var natureOfProblemDetails : NSArray?
    
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
            
            if(checkKeyExist(KEY_Equipment, dictionary: responseDictionary))
            {
                if let responseProducts : NSArray = (responseDictionary.object(forKey: KEY_Equipment) as? NSArray)
                {
                    allEquipment = responseProducts
                }
                else
                {
                    allEquipment = []
                }
            }
        }
        else
        {
            errorMessage = parsingFailMessage
        }
    }
}
