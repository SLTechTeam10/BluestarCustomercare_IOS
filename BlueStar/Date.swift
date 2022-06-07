//
//  Date.swift
//  BlueStar
//
//  Created by tarun.kapil on 05/08/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit

extension Date {
    func hoursFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.hour, from: date, to: self, options: []).hour!
    }
    
    func offsetFrom(_ date: Date) -> String {
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))"   }
        return ""
    }
}
