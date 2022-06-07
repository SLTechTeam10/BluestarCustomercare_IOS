//
//  ProductData.swift
//  Blue Star
//
//  Created by Kamlesh on 11/10/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit

class ProductData: NSObject {
    //static let shareInstance = ProductData()
    var productDisplayName : String?
    var productId : String?
    var productImageUrl : String?
    var productName : String?
    //var isSelected : Bool?
    //var arraySelectedProducts = NSMutableArray()
    
    
    func parseResponseObject(_ response:AnyObject!) -> AnyObject {
        if let responseDictionary: NSDictionary = response as? NSDictionary {
            if(checkKeyExist("productDisplayName", dictionary: responseDictionary)) {
                if let pDName : String = (responseDictionary.object(forKey: "productDisplayName") as? String) {
                    productDisplayName = pDName
                } else {
                    productDisplayName = ""
                }
            }
            if(checkKeyExist("productId", dictionary: responseDictionary)) {
                if let pDName : String = (responseDictionary.object(forKey: "productId") as? String) {
                    productId = pDName
                } else {
                    productId = ""
                }
            }
            if(checkKeyExist("productImage", dictionary: responseDictionary)) {
                if let pDName : String = (responseDictionary.object(forKey: "productImage") as? String) {
                    productImageUrl = pDName
                } else {
                    productImageUrl = ""
                }
            }
            if(checkKeyExist("productname", dictionary: responseDictionary)) {
                if let pDName : String = (responseDictionary.object(forKey: "productname") as? String) {
                    productName = pDName
                } else {
                    productName = ""
                }
            }
            
        } else {
           // errorMessage = parsingFailMessage
        }
        return self
    }
    
}
