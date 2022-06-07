//
//  ResponseChecker.swift
//  BlueStar
//
//  Created by tarun.kapil on 06/09/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import Foundation

func checkKeyExist(_ key:String ,dictionary:NSDictionary) -> Bool {
    let object = dictionary[key]
    if(object == nil) {
        return false
    } else {
        return true
    }
}

func isNotNull(_ object:AnyObject?) -> Bool {
    guard let object = object else {
        return false
    }
    return (isNotNSNull(object) && isNotStringNull(object))
}

func isNotNSNull(_ object:AnyObject) -> Bool {
    return object.classForCoder != NSNull.classForCoder()
}

func isNotStringNull(_ object:AnyObject) -> Bool {
    if let object = object as? String, object.uppercased() == "NULL" {
        return false
    }
    return true
}
