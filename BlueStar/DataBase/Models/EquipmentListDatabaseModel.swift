//
//  RegisteredProductDatabaseModel.swift
//  BlueStar
//
//  Created by aditya.chitaliya on 23/10/18.
//  Copyright © 2018 BlueStar. All rights reserved.
//

import UIKit

class EquipmentListDatabaseModel: NSObject {
    static let shareInstance = EquipmentListDatabaseModel()
    var allProducts : NSArray?
    var productData : NSDictionary?
    let fileURL = DBManager.shareInstance.getPath()
    
    func addProducts(_ equipments:NSArray!)-> Void {
//        var equipment: NSArray = [
//        [
//            "productFamily": "F1300",
//            "productFamilyName": "Watercoolers",
//            "products": [
//            [
//            "subFamily": "F1304",
//            "subFamilyName": "Platinum Series",
//            "model": "P6080UVROE-SL",
//            "modelName": "PLATINUM SERIES P6080E UVRO SILVER",
//            "componentNo": "1800000945",
//            "serialNumber": "P6080UVROE-SLSRL001",
//            "customerId": "M2515753833333948"
//            ]
//            ]
//            ],
//        [
//            "productFamily": "F1200",
//            "productFamilyName": "AC - Room Air Conditioner",
//            "products": [
//            [
//            "subFamily": "F1203",
//            "subFamilyName": "Mega Split",
//            "model": "MHW301RCODU2",
//            "modelName": "CONDENSING UNIT 2.5TR MEGA-MHW301RCODU",
//            "componentNo": "1800000944",
//            "serialNumber": "2HW121YAISRL001",
//            "customerId": "M2515753833333948"
//            ],
//            [
//            "subFamily": "F1201",
//            "subFamilyName": "Window",
//            "model": "BSQATestModel",
//            "modelName": "BSQATestModel",
//            "componentNo": "1800000943",
//            "serialNumber": "SGRTEST002",
//            "customerId": "M2529139650687700"
//            ],
//            [
//            "subFamily": "F1201",
//            "subFamilyName": "Window",
//            "model": "BSQATestModel",
//            "modelName": "BSQATestModel",
//            "componentNo": "1800000942",
//            "serialNumber": "SGRTEST001",
//            "customerId": "M2529139650687700"
//            ]
//            ]
//            ]
//        ]
        
        //check if db table has product familyname column
        
        let db1 = FMDatabase(path: fileURL)
        db1?.open()
        
        let ifColumnExist = db1?.executeQuery("PRAGMA table_info (registeredDevice)", withParameterDictionary: nil)
        print((ifColumnExist?.bool(forColumn: "productFamilyName")) as! Bool)
        if((ifColumnExist?.bool(forColumn: "productFamilyName"))! == false){
            let addColumn = db1?.executeUpdate("alter table registeredDevice add column productFamilyName TEXT", withParameterDictionary: nil)
            print(addColumn)
        }
        
        
        let isProductDeleted = db1?.executeUpdate("DELETE FROM registeredDevice", withArgumentsIn:nil)
        if(isProductDeleted!)
        {
            for i in 0..<equipments.count {
                let equipmentList = equipments[i] as! NSDictionary
                //remove hard coded value
                let productId = equipmentList["productFamily"] as! String
                        //"1371" as! String=
                let product = equipmentList["products"] as! NSArray
                let productFamilyName = equipmentList["productFamilyName"] as! String
                
                for j in 0..<product.count{
                    let productList = product[j] as! NSDictionary
                    let equipmentId = productList["subFamily"] as! String
                    let equipmentName = productList["subFamilyName"] as! String
                    let modelNo = productList["model"] as! String
                    let modelName = productList["modelName"] as! String
                    let equipmentRegNo = productList["componentNo"] ?? ""
                    let equipmentserialNo = productList["serialNumber"] as! String
                    let customer_id = productList["customerId"] as! String

                    let isProductInserted = db1?.executeUpdate("INSERT OR REPLACE INTO registeredDevice (productId,equipmentId,equipmentName,modelName,equipmentRegNo,modelNo,serialNo,customerId,productFamilyName) VALUES (?,?,?,?,?,?,?,?,?)", withArgumentsIn: [productId,equipmentId,equipmentName,modelName,equipmentRegNo,modelNo,equipmentserialNo,customer_id,productFamilyName])
                    if(isProductInserted!){
                    } else {
                        print("Database Insert failure: \(String(describing: db1?.lastErrorMessage()))")
                    }
                }
                
                }
        } else {
            print("Database Delete failure: \(String(describing: db1?.lastErrorMessage()))")
        }
        db1?.close()
    }
    func getAllEquipments(){
        
    }
}


