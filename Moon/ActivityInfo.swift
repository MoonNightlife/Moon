//
//  ActivityInfo.swift
//  Moon
//
//  Created by Evan Noble on 7/26/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import ObjectMapper

struct ActivityInfo: Mappable {
    var barName: String?
    var numberOfLikes: Int?
    var barID: String?
    var time: Date?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        barName <- map["barName"]
        numberOfLikes <- map["numberOfLikes"]
        barID <- map["barId"]
        time <- (map["timeStamp"], DateTransfromDouble)
    }
}
