//
//  TicketListModel.swift
//  Blue Star
//
//  Created by Aditya Chitaliya on 13/06/17.
//  Copyright © 2017 BlueStar. All rights reserved.
//

import UIKit

class TicketListModel: NSObject {
    static let shareInstance = TicketListModel()
    let fileURL = DBManager.shareInstance.getPath()
    
    
    func addTickets(_ ticketHistoryList:NSArray!)-> Void {
        let db1 = FMDatabase(path: fileURL)
        db1?.open()
        if (ticketHistoryList.count) > 0 {
            var totalTicket = ticketHistoryList.count
            // print("sdbsvbd\(totalTicket)")
            for var i in 0..<totalTicket {
                //totalTicket = totalTicket - 1
                let data = ticketHistoryList[i] as! NSDictionary
                let ticketNumber = data["ticketNumber"] as! String
                let lastUpdatedDate = data["lastUpdatedDate"] as! String
                let productName = data["productName"] as! String
                let progressStatus = data["progressStatus"] as! String
                var dealername:String = ""
                var contact : String = ""
                var prodImage : String = ""
                let prodId = data["productId"] as! String
                let customerVisitTime = data["customerVisitTime"] as? String ?? ""
                var modelNo :String! = ""
                var serailNo:String! = ""
                if data["dealerName"] != nil{
                     dealername = data["dealerName"] as! String
                }
                if data["productImage"] != nil{
                     prodImage = data["productImage"] as! String
                }
                if data["dealerMobile"] != nil{
                    contact = data["dealerMobile"]  as! String
                }
                if data["modelNo"] != nil{
                    modelNo = data["modelNo"] as! String
                    serailNo = data["serailNo"] as! String
                }
                //let updatedOn = data["updatedOn"] as! String
                db1?.open()
//                if let rs = db1?.executeQuery("select * from ticketHistory where ticketNumber like '?'  ", withArgumentsIn:[ticketNumber]) {
//                    if(rs.next())
//                    {
//                        let isupdated = db1?.executeUpdate("update ticketHistory set lastUpdatedDate = ? ,productImage  = ? ,dealerName = ? ,productId = ? ,dealerMobile = ? ,progressStatus = ? ,productName = ? where ticketNumber = ?", withArgumentsIn: [lastUpdatedDate,prodImage,dealername,prodId,contact,progressStatus,productName,ticketNumber])
//                        if (!isupdated!){
//                            print("Ticket Number\(ticketNumber) is not updated. Update failure: \(db1?.lastErrorMessage())")
//                        }
//                    } else{
//                        let isinserted = db1?.executeUpdate("INSERT INTO ticketHistory (ticketNumber,lastUpdatedDate,productImage,dealerName,productId,dealerMobile,progressStatus,productName) VALUES (?,?,?,?,?,?,?,?)", withArgumentsIn: [ticketNumber,lastUpdatedDate,prodImage,dealername,prodId,contact,progressStatus,productName])
//                        if(!isinserted!){
//                            print("Database failure: \(db1?.lastErrorMessage())")
//                        }
//                    }
//                }
                let check = "INSERT or replace into ticketHistory (ticketNumber,lastUpdatedDate,productImage,dealerName,productId,dealerMobile,progressStatus,productName,customerVisitTime,modelNo,serialNo) VALUES ('\(ticketNumber)','\(lastUpdatedDate)','\(prodImage)','\(dealername)','\(prodId)','\(contact)','\(progressStatus)','\(productName)','\(customerVisitTime)','\(modelNo!)','\(serailNo!)')"
                //print(check)
                let temp = db1?.executeUpdate(check, withArgumentsIn: nil)
                if(!temp!){
                    print("Database failure: \(String(describing: db1?.lastErrorMessage()))")
                }

            }
            //DataManager.shareInstance.showAlert(self, title: "", message: "No ticket history found.")
        }
    }
    
    func clearDB(){
        let db1 = FMDatabase(path: fileURL)
        db1?.open()
        let deleteProduct =  db1?.executeUpdate("delete from productList", withArgumentsIn: nil)
        let deleteNatureOfProblem = db1?.executeUpdate("delete from natureOfProblem", withArgumentsIn: nil)
        let ticketHistory = db1?.executeUpdate("delete from ticketHistory", withArgumentsIn: nil)
        let registeredProduct = db1?.executeUpdate("delete from registeredDevice", withArgumentsIn: nil)
        if(!deleteProduct! || !deleteNatureOfProblem! || !ticketHistory! || !registeredProduct!){
            print("Database Delete failure: \(String(describing: db1?.lastErrorMessage()))")
        }else {
            print("Database Clear Successfully")
        }
    }
    
    func clearDBTickets(){
        let db1 = FMDatabase(path: fileURL)
        db1?.open()
        let ticketHistory = db1?.executeUpdate("delete from ticketHistory", withArgumentsIn: nil)
    }
}
