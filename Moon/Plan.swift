//
//  Plan.swift
//  Moon
//
//  Created by Evan Noble on 7/26/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import ObjectMapper

struct Plan: Mappable {
    var closingTime: Date?
    var options: [PlanOption]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        closingTime <- map["closingTime"]
        options <- map["options"]
    }
}

struct PlanOption: Mappable {
    var barID: String?
    var barName: String?
    var voteCount: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        barID <- map["barId"]
        barName <- map["barName"]
        voteCount <- map["voteCount"]
    }
}
