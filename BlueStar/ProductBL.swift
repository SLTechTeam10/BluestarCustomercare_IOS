//
//  ProductBL.swift
//  Blue Star
//
//  Created by Kamlesh on 11/10/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit

class ProductBL: NSObject {
    static let shareInstance = ProductBL()
    var products : NSMutableArray = []
    var selectedProducts : NSMutableArray = []
    
    var resultProductData:NSDictionary = NSDictionary()//this variable is used to store response of product list api, to prevent frequent calling of api
    
    func parseResponseObject(_ response:AnyObject!) -> Void {
        if let responseDictionary: NSDictionary = response as? NSDictionary {
            
            if(checkKeyExist(KEY_Products, dictionary: responseDictionary)) {
                if let responseProducts : NSArray = (responseDictionary.object(forKey: KEY_Products) as? NSArray){
                    for productInfo in responseProducts {
                        var obj = ProductData()
                        obj = obj.parseResponseObject(productInfo as! NSDictionary) as! ProductData
                        products.add(obj)
                    }
                } else {
                    products = []
                }
            }
        } else {
            //errorMessage = parsingFailMessage
        }
    }
    
    func parseProductDataWithUserAlreadySelectedProducts(_ response:AnyObject!) -> Void {
        
        if let responseDictionary: NSDictionary = response as? NSDictionary {
            
            let user = PlistManager.sharedInstance.getValueForKey("user") as! NSDictionary
            let userSelectedProductIds = user["registeredProductsIds"] as! NSString
            
            if(checkKeyExist(KEY_Products, dictionary: responseDictionary)) {
                if let responseProducts : NSArray = (responseDictionary.object(forKey: KEY_Products) as? NSArray){
                    for productInfo in responseProducts {
                        var obj = ProductData()
                        obj = obj.parseResponseObject(productInfo as! NSDictionary) as! ProductData
                        products.add(obj)
                        let productId = (productInfo as! NSDictionary)["productId"] as! NSString
                        if userSelectedProductIds.contains(productId as String) {
                            self.selectedProducts.add(obj)
                        }
                    }
                } else {
                    products = []
                } 
            }
        } else {
            //errorMessage = parsingFailMessage
        }
    }
}
