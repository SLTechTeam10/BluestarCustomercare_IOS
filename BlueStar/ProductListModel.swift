//
//  ProductListModel.swift
//  BlueStar
//
//  Created by tarun.kapil on 23/08/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import Foundation

class ProductListModel: NSObject {
    static let shareInstance = ProductListModel()
    var message : String?
    var errorMessage : String?
    var authKey : String?
    var status : String?
    var products : NSArray?
    var allProducts : NSArray?
    var natureOfProblemDetails : NSArray?
    
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
            
            if(checkKeyExist(KEY_AuthKey, dictionary: responseDictionary)) {
                if let responseauthKey : String = (responseDictionary.object(forKey: KEY_AuthKey) as? String){
                    authKey  = responseauthKey
                } else {
                    authKey = ""
                }
            }
            
            if(checkKeyExist(KEY_Products, dictionary: responseDictionary))
            {
                if let responseProducts : NSArray = (responseDictionary.object(forKey: KEY_Products) as? NSArray)
                {
                    var user: Dictionary<String, AnyObject> = (PlistManager.sharedInstance.getValueForKey("user") as? Dictionary<String,
                        AnyObject>)!
                    let pids = user["registeredProductsIds"] as! NSString
                    
                    let filterProducts = responseProducts.mutableCopy()

                    for product in responseProducts as! [[String:Any]]
                    {
                        let obje = product["productId"] as Any
                        
                        let productId = (obje) as! NSString
                        print(obje)
                        print(productId)
                        if pids.contains((productId as NSString) as String)
                        {
                            
                        }
                        else
                        {
                            (filterProducts as AnyObject).remove(product)
                        }
                    }
                    
                    products  = filterProducts as? NSArray
                    allProducts = responseProducts
                }
                else
                {
                    products = []
                    allProducts = []
                }
            }
        }
        else
        {
            errorMessage = parsingFailMessage
        }
    }
}
