//
//  TicketHistoryModel.swift
//  BlueStar
//
//  Created by tarun.kapil on 30/08/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import Foundation

class TicketHistoryModel: NSObject {
    static let shareInstance = TicketHistoryModel()
    var message : String?
    var errorMessage : String?
    var status : String?
    var tickets : NSArray?
    var lastSynced : String?
    
    
    func parseResponseObject(_ response:AnyObject!) -> Void {
        if let responseDictionary: NSDictionary = response as? NSDictionary {
            if(checkKeyExist(KEY_Status, dictionary: responseDictionary)) {
                if let responseStatus : String = (responseDictionary.object(forKey: KEY_Status) as? String) {
                    status = responseStatus
                } else {
                    status = "NA"
                }
            }
            
            if(checkKeyExist(KEY_LastSynced, dictionary: responseDictionary)) {
                if let responseLastSynced : String = (responseDictionary.object(forKey: KEY_LastSynced) as? String) {
                    lastSynced = responseLastSynced
                } else {
                    lastSynced = "NA"
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
            
            if(checkKeyExist(KEY_Tickets, dictionary: responseDictionary)) {
                if let responseTickets : NSArray = (responseDictionary.object(forKey: KEY_Tickets) as? NSArray){
                    tickets  = responseTickets
                   // print(tickets)
                } else {
                    tickets = []
                }
            } else {
                tickets = []
            }
        } else {
            errorMessage = parsingFailMessage
        }
    }
    
    func productStatus(_ poductId:NSString) -> NSDictionary
    {
        var filterProductStatusInfo = NSDictionary()
        
        let resultPredicate : NSPredicate = NSPredicate(format: "productId = %@",poductId)
        if let ticketStatus: NSArray = TicketHistoryModel.shareInstance.tickets{
            
            if ticketStatus.count>0 {
                let searchResults = ticketStatus.filtered(using: resultPredicate)
                
                if searchResults.count>0 {
                    
                    for (index, value) in searchResults.enumerated() {
                        
                        var product: Dictionary<String, AnyObject> = value as! Dictionary<String, AnyObject>
                        
                        let productStatus = product["progressStatus"] as! String
                        
                        if (productStatus.trim().caseInsensitiveCompare(statusWorkCompleted) == ComparisonResult.orderedSame ||  productStatus.trim().caseInsensitiveCompare(statusClosed) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusCallCancelled) == ComparisonResult.orderedSame  || productStatus.trim().caseInsensitiveCompare(statusAppointmentFixedForWorkCompletion) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusCallOnHoldObligationDispute) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusCallOnHoldAwaitingCustomerClearance) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusCallAttendedPendingForMaterial) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusWorkStartedAtSite) == ComparisonResult.orderedSame || productStatus.trim().caseInsensitiveCompare(statusWorkInProcess) == ComparisonResult.orderedSame){
                            
                            filterProductStatusInfo = product as NSDictionary
                            
                        }else{
                            filterProductStatusInfo = product as NSDictionary;//searchResults.first as! NSDictionary
                            break;
                            
                        }
                    }
                }
            }
        }
        return filterProductStatusInfo
    }
    
}
