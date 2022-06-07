//
//  FeedbackModel.swift
//  BlueStar
//
//  Created by tarun.kapil on 30/08/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import Foundation

class FeedbackModel: NSObject {
    static let shareInstance = FeedbackModel()
    var message : String?
    var errorMessage : String?
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
        } else {
            errorMessage = parsingFailMessage
        }
    }
    
}
