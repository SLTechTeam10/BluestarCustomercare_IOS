//
//  DatabaseMigrate.swift
//  BlueStar
//
//  Created by aditya.chitaliya on 24/10/18.
//  Copyright © 2018 BlueStar. All rights reserved.
//

import UIKit

class DatabaseMigrate: NSObject {
    static let shareInstance : DatabaseMigrate = DatabaseMigrate()
        let fileURL = DBManager.shareInstance.getPath()
    func createTabelsIfNotExists(){
        let db1 = FMDatabase(path: fileURL)
        db1?.open()
        let natureOfProblemTableQuery = "CREATE TABLE IF NOT EXISTS natureOfProblem ( productId TEXT, natureId TEXT, natureOfProblemImage TEXT, natureOfProblem TEXT )"
        let productListTableQuery = "CREATE TABLE IF NOT EXISTS TABLE productList ( productId TEXT, productname TEXT, productDisplayName TEXT, productImage TEXT )"
        let ticketHistoryTableQuery = "CREATE TABLE IF NOT EXISTS TABLE ticketHistory ( ticketNumber TEXT, lastUpdatedDate TEXT, productImage TEXT, dealerName TEXT, productId TEXT, dealerMobile TEXT, progressStatus TEXT, productName TEXT, customerVisitTime TEXT, PRIMARY KEY(ticketNumber) )"
        let registeredDeviceTablequery = "CREATE TABLE IF NOT EXISTS registeredDevice ( indexId INTEGER PRIMARY KEY AUTOINCREMENT, deviceImage TEXT, deviceName TEXT, deviceRegNo TEXT, modelNo TEXT, serialNo TEXT, productId TEXT )"
        let natureOfProblemTableCreated = db1?.executeUpdate(natureOfProblemTableQuery, withArgumentsIn: nil)
        let productListTableCreated = db1?.executeUpdate(productListTableQuery, withArgumentsIn: nil)
        let ticketHistoryTableCreated = db1?.executeUpdate(ticketHistoryTableQuery, withArgumentsIn: nil)
        let registeredDeviceTableCreated = db1?.executeUpdate(registeredDeviceTablequery, withArgumentsIn: nil)
        if(natureOfProblemTableCreated! || productListTableCreated! || ticketHistoryTableCreated! || registeredDeviceTableCreated!){
        }else{
            print("Database Insert failure: \(String(describing: db1?.lastErrorMessage()))")
        }
        // let isProductInserted = db1?.executeUpdate("INSERT INTO registeredDevice (deviceImage,deviceName,deviceRegNo,modelNo,serialNo) VALUES (?,?,?,?,?,?)", withArgumentsIn: [deviceImage,deviceName,deviceRegNo,modelNo,serialNo,productId])
    }
    
}
