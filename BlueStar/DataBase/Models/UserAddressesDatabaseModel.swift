//
//  UserAddressesDatabaseModel.swift
//  BlueStar
//
//  Created by Aditya chitaliya on 14/11/18.
//  Copyright © 2018 BlueStar. All rights reserved.
//

import UIKit

class UserAddressesDatabaseModel: NSObject {
    static let shareInstance = UserAddressesDatabaseModel()
    var userDetails : String = ""
    var userAddresses: NSArray = []
    let fileURL = DBManager.shareInstance.getPath()
    //    ,_ user: String
    func addUserAddress(_ mobileNo:String, _ addresses:NSArray,active customerId: String)-> Void {
        let db1 = FMDatabase(path: fileURL)
        db1?.open()
        var userAddress: String = ""
        let isdeleted = db1?.executeUpdate("DELETE FROM addressList where mobile_no like (?)", withArgumentsIn:[mobileNo])
        if(isdeleted!)
        {
            for (index, value) in addresses.enumerated() {
                let address: Dictionary<String, AnyObject> = value as! Dictionary<String, AnyObject>
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: address)
                    if let json = String(data: jsonData, encoding: .utf8) {
                        userAddress = json
                    }
                } catch {
                    print("something went wrong with parsing Dictionary")
                }
                let isUserInserted: Bool!
                if(address["customerId"] as! String == customerId){
                    isUserInserted = db1?.executeUpdate("INSERT OR REPLACE INTO addressList (mobile_no,address_Detail,is_Active) VALUES (?,?,?)", withArgumentsIn: [mobileNo,userAddress,"true"])
                }else{
                    isUserInserted = db1?.executeUpdate("INSERT OR REPLACE INTO addressList (mobile_no,address_Detail,is_Active) VALUES (?,?,?)", withArgumentsIn: [mobileNo,userAddress,"false"])
                }
                if(isUserInserted!){
                } else {
                    print("Database Insert failure: \(String(describing: db1?.lastErrorMessage()))")
                }
            }
        }else {
            print("Database Delete failure: \(String(describing: db1?.lastErrorMessage()))")
        }
    }
    
    func getUserAddrress(_ mobileNo:String)->NSArray{
        var strAddress: String = ""
        let allAddress:NSMutableArray = []
        var address: Dictionary<String,AnyObject> = ["" : "" as AnyObject]
        let db1 = FMDatabase(path: fileURL)
//        var i: Int32 = 0
        db1?.open()
        if let rs = db1?.executeQuery("select address_Detail from addressList where mobile_no like(?) and is_Active like 'true'", withArgumentsIn:[mobileNo]) {
            while rs.next() {
                strAddress = rs.string(forColumnIndex: 0)
                address = ParseAddressesToDictionary(_details: strAddress)
                allAddress.add(address)
            }
        }else {
            print("select failure: \(String(describing: db1?.lastErrorMessage()))")
        }
        return allAddress.mutableCopy() as! NSArray
    }
    func getUserAddrressToUpdate(_ mobileNo:String, _ customerId:String)->NSMutableArray{
        var strAddress: String = ""
        let allAddress:NSMutableArray = []
        var address: Dictionary<String,AnyObject> = ["" : "" as AnyObject]
        let db1 = FMDatabase(path: fileURL)
        //        var i: Int32 = 0
        db1?.open()
        var queryString = ""
            queryString = String(format:"select * from addressList where mobile_no like '%@' and address_Detail like '%%%@%%'",mobileNo,customerId)
        if let rs = db1?.executeQuery(queryString, withArgumentsIn: nil){//("select * from addressList where mobile_no like(?) and address_Detail like '?'", withArgumentsIn:[mobileNo,customerId]) {
            while rs.next() {
                strAddress = rs.string(forColumn: "address_id")
                
                allAddress.add(strAddress)
            }
        }else {
            print("select failure: \(String(describing: db1?.lastErrorMessage()))")
        }
        return allAddress
    }
    func UserAddrressToUpdate(_ mobileNo:String, _ whereStr:String, _ value:Any){
        let db1 = FMDatabase(path: fileURL)
        //        var i: Int32 = 0
        var userAddress: String = ""
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: value)
            if let json = String(data: jsonData, encoding: .utf8) {
                userAddress = json
            }
        } catch {
            print("something went wrong with parsing Dictionary")
        }
        
        db1?.open()
        var queryString = ""
        queryString = String(format:"update addressList set address_Detail = '%@' where mobile_no like '%@' and address_id like '%@'",userAddress,mobileNo,whereStr)
        let isupdated = db1?.executeUpdate(queryString, withArgumentsIn:nil)
        if((isupdated) != nil){
        } else {
            print("Database Updation failure: \(String(describing: db1?.lastErrorMessage()))")
        }
        
    }
    
    func getUserInactiveAddrress(_ mobileNo:String)->NSArray{
        var strAddress: String = ""
        let allAddress:NSMutableArray = []
        var address: Dictionary<String,AnyObject> = ["" : "" as AnyObject]
        let db1 = FMDatabase(path: fileURL)
        //        var i: Int32 = 0
        db1?.open()
        if let rs = db1?.executeQuery("select address_Detail from addressList where mobile_no like(?) and is_Active like 'false'", withArgumentsIn:[mobileNo]) {
            while rs.next() {
                strAddress = rs.string(forColumnIndex: 0)
                address = ParseAddressesToDictionary(_details: strAddress)
                allAddress.add(address)
            }
        }else {
            print("select failure: \(String(describing: db1?.lastErrorMessage()))")
        }
        return allAddress.mutableCopy() as! NSArray
    }
    
    func getCustomerIDs(_ mobileNo:String)->NSString{
        var strAddress: String = ""
        let allAddress:NSMutableArray = []
        var address: Dictionary<String,AnyObject> = ["" : "" as AnyObject]
        let db1 = FMDatabase(path: fileURL)
        //        var i: Int32 = 0
        db1?.open()
        if let rs = db1?.executeQuery("select address_Detail from addressList where mobile_no like(?)", withArgumentsIn:[mobileNo]) {
            while rs.next() {
                strAddress = rs.string(forColumnIndex: 0)
                address = ParseAddressesToDictionary(_details: strAddress)
                allAddress.add(address["customerId"] as! String)
            }
        }else {
            print("select failure: \(String(describing: db1?.lastErrorMessage()))")
        }
        if(allAddress.count > 0){
            return allAddress.componentsJoined(by: ",") as NSString
        }
        return ""
    }
    
    func UpdateAddressAsActive(for mobileNo: String, forCustomerId customerId: String){
        var strAddress: String = ""
        //let allAddress:NSMutableArray = []
        var address: Dictionary<String,AnyObject> = ["" : "" as AnyObject]
        var addressRowNo: Int = -1
        let db1 = FMDatabase(path: fileURL)
        db1?.open()
        if let rs = db1?.executeQuery("select * from addressList where mobile_no like(?) and is_Active like 'false'", withArgumentsIn:[mobileNo]) {
            while rs.next() {
                strAddress = rs.string(forColumnIndex: 2)
                address = ParseAddressesToDictionary(_details: strAddress)
               // allAddress.add(address)
                if(address["customerId"] as! String == customerId){
                    addressRowNo = Int(rs.int(forColumnIndex: 0))
                    break
                }
            }
        }else {
            print("select failure: \(String(describing: db1?.lastErrorMessage()))")
        }
        if(addressRowNo >= 0){
              let isupdated = db1?.executeUpdate("update addressList set is_Active = ? where address_ID = ?", withArgumentsIn: ["true",addressRowNo])
            if(isupdated!){
            } else {
                print("Database Updation failure: \(String(describing: db1?.lastErrorMessage()))")
            }
        }
    }
    
    func UpdateAddressAsInActive(for mobileNo: String, forCustomerId customerId: String){
        var strAddress: String = ""
        //let allAddress:NSMutableArray = []
        var address: Dictionary<String,AnyObject> = ["" : "" as AnyObject]
        var addressRowNo: Int = -1
        let db1 = FMDatabase(path: fileURL)
        db1?.open()
        if let rs = db1?.executeQuery("select * from addressList where mobile_no like(?) and is_Active like 'true'", withArgumentsIn:[mobileNo]) {
            while rs.next() {
                strAddress = rs.string(forColumnIndex: 2)
                address = ParseAddressesToDictionary(_details: strAddress)
                // allAddress.add(address)
                if(address["customerId"] as! String == customerId){
                    addressRowNo = Int(rs.int(forColumnIndex: 0))
                    break
                }
            }
        }else {
            print("select failure: \(String(describing: db1?.lastErrorMessage()))")
        }
        if(addressRowNo >= 0){
            let isupdated = db1?.executeUpdate("update addressList set is_Active = ? where address_ID = ?", withArgumentsIn: ["false",addressRowNo])
            if(isupdated!){
            } else {
                print("Database Updation failure: \(String(describing: db1?.lastErrorMessage()))")
            }
        }
    }
    
    
    
    func addNewAddressFor(_ mobileNo:String, address:NSDictionary){
        //let addresses: NSMutableArray = (self.getUserAddrress(mobileNo) as! NSArray).mutableCopy() as! NSMutableArray
       // addresses.add(address)
        let db1 = FMDatabase(path: fileURL)
        db1?.open()
        var userAddress: String = ""
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: address)
                    if let json = String(data: jsonData, encoding: .utf8) {
                        userAddress = json
                    }
                } catch {
                    print("something went wrong with parsing Dictionary")
                }
                let isUserInserted = db1?.executeUpdate("INSERT OR REPLACE INTO addressList (mobile_no,address_Detail,is_Active) VALUES (?,?,?)", withArgumentsIn: [mobileNo,userAddress,"true"])
                if(isUserInserted!){
                } else {
                    print("Database Insert failure: \(String(describing: db1?.lastErrorMessage()))")
        }
    }
//    func getUserDetails(_ mobileNo:String)->Dictionary<String,AnyObject>{
//        var det: String = ""
//        let db1 = FMDatabase(path: fileURL)
//        db1?.open()
//        if let rs = db1?.executeQuery("select * from userDetails where mobile_No like(?)", withArgumentsIn:[mobileNo]) {
//            while rs.next() {
//                // self.ticketList.addObjects(from: [rs.resultDictionary() as Any])
//                //               det.addObjects(from: [rs.resultDictionary() as Any])
//                det = rs.string(forColumn: "userData")
//            }
//        }else {
//            print("select failure: \(String(describing: db1?.lastErrorMessage()))")
//        }
//        //let userDetails:NSDictionary = det.object(at: 0) as! NSDictionary
//        return ParseUserDataToDictionary(_details: det)
//    }
    
    func ParseUserDataToString(_ user:Dictionary<String,AnyObject>)-> Void{
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: user)
            if let json = String(data: jsonData, encoding: .utf8) {
                //print(json)
                self.userDetails = json
            }
        } catch {
            print("something went wrong with parsing Dictionary")
        }
    }
    
    func ParseAddressesToDictionary(_details: String)->Dictionary<String, AnyObject>{
        if let data = _details.data(using: .utf8) {
            do {
                return try (JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, AnyObject>)!
            } catch {
                print(error.localizedDescription)
            }
        }
        return (["" : "" as AnyObject])
    }

}
