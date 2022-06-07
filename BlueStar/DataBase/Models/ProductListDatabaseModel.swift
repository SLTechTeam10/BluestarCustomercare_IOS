//
//  ProductListDatabaseModel.swift
//  Blue Star
//
//  Created by Aditya Chitaliya on 13/06/17.
//  Copyright © 2017 BlueStar. All rights reserved.
//

import UIKit

class ProductListDatabaseModel: NSObject {
    static let shareInstance = ProductListDatabaseModel()
     var allProducts : NSArray?
    let fileURL = DBManager.shareInstance.getPath()
    
    func addProducts(_ products:NSArray!)-> Void {
        let db1 = FMDatabase(path: fileURL)
        db1?.open()
        let isProductDeleted = db1?.executeUpdate("DELETE FROM productList", withArgumentsIn:nil)
        if(isProductDeleted!)
        {
            
            let isProblemsDeleted = db1?.executeUpdate("DELETE FROM natureOfProblem", withArgumentsIn:nil)
            
            if(isProblemsDeleted!){
                for var i in 0..<products.count {
                    let productsList = products[i] as! NSDictionary
                    let productDisplayName = productsList["productDisplayName"] as? String
                    let natureOfProblemDetails = productsList["natureOfProblemDetails"] as! NSArray
                    let productId = productsList["productId"] as! String
                    let productImage = productsList["productImage"] as! String
                    let productname = productsList["productname"] as! String
                    
                    let isProductInserted = db1?.executeUpdate("INSERT INTO productList (productId,productname,productDisplayName,productImage) VALUES (?,?,?,?)", withArgumentsIn: [productId,productname,productDisplayName,productImage])
                    
                    if(isProductInserted!){
                        for j in 0..<natureOfProblemDetails.count{
                            let problems = natureOfProblemDetails[j] as! NSDictionary
                            let problemId = problems["id"] as! String
                            let natureOfProblem = problems["natureOfProblem"] as! String
                            let natureOfProblemImage = problems["natureOfProblemImage"] as! String
                            let isProblemInserted = db1?.executeUpdate("INSERT INTO NatureOfProblem (productId,natureId,natureOfProblem,natureOfProblemImage) VALUES (?,?,?,?)", withArgumentsIn: [productId,problemId,natureOfProblem,natureOfProblemImage])
                            
                            if(!isProblemInserted!){
                                print("Database Insert failure: \(String(describing: db1?.lastErrorMessage()))")
                            }
                        }
                    } else {
                        print("Database Insert failure: \(String(describing: db1?.lastErrorMessage()))")
                    }
                }
            }
        } else {
            print("Database Delete failure: \(String(describing: db1?.lastErrorMessage()))")
        }
    }
}
