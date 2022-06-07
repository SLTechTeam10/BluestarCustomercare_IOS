//
//  UserDetailsDatabaseModel.swift
//  BlueStar
//
//  Created by Aditya chitaliya on 13/11/18.
//  Copyright © 2018 BlueStar. All rights reserved.
//

import UIKit

class UserDetailsDatabaseModel: NSObject {
    static let shareInstance = UserDetailsDatabaseModel()
    var userDetails : String = ""
    let fileURL = DBManager.shareInstance.getPath()
//    ,_ user: String
    func addUserDetails(_ mobileNo:String, _ user:Dictionary<String,AnyObject>)-> Void {
        var userDet: String = ""
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: user)
            if let json = String(data: jsonData, encoding: .utf8) {
                //print(json)
                userDet = json
            }
        } catch {
            print("something went wrong with parsing Dictionary")
        }
        let db1 = FMDatabase(path: fileURL)
        db1?.open()
        let isUserInserted = db1?.executeUpdate("INSERT OR REPLACE INTO userDetails (mobile_No,userData) VALUES (?,?)", withArgumentsIn: [mobileNo,userDet])
        if(isUserInserted!){
        } else {
            print("Database Insert failure: \(String(describing: db1?.lastErrorMessage()))")
        }
    }
    
    func getUserDetails(_ mobileNo:String)->Dictionary<String,AnyObject>{
        var det: String = ""
        let db1 = FMDatabase(path: fileURL)
        db1?.open()
        if let rs = db1?.executeQuery("select * from userDetails where mobile_No like(?)", withArgumentsIn:[mobileNo]) {
            while rs.next() {
               // self.ticketList.addObjects(from: [rs.resultDictionary() as Any])
//               det.addObjects(from: [rs.resultDictionary() as Any])
                det = rs.string(forColumn: "userData")
            }
        }else {
            print("select failure: \(String(describing: db1?.lastErrorMessage()))")
        }
        //let userDetails:NSDictionary = det.object(at: 0) as! NSDictionary
        return ParseUserDataToDictionary(_details: det)
    }
    
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
    
    func ParseUserDataToDictionary(_details: String)->Dictionary<String, AnyObject>{
        if let data = _details.data(using: .utf8) {
            do {
                return try (JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, AnyObject>)!
            } catch {
                print(error.localizedDescription)
                return (["" : "" as AnyObject] as? Dictionary<String, AnyObject>)!
            }
        }
        return (["" : "" as AnyObject] as? Dictionary<String, AnyObject>)!
    }
}
