//
//  TicketModel.swift
//  BlueStar
//
//  Created by tarun.kapil on 24/09/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import Foundation

class TicketModel: NSObject {
    static let shareInstance = TicketModel()
    var lastUpdatedDate : String?
    var productId : String?
    var productImage : String?
    var productName : String?
    var progressStatus : String?
    var ticketNumber : String?
    var customerVisitTime: String?
}
