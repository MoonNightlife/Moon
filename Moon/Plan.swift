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
    var startTime: Date?
    var options: [PlanOption]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        startTime <- (map["startTime"], DateTransfromDouble)
        options <- map["options"]
    }
}

struct PlanOption: Mappable {
    var barID: String?
    var barName: String?
    var voteCount: Int?
    var userVoted: Bool?
    
    init(snapshot: Snapshot) {
        self.barID = snapshot.id
        self.barName = snapshot.name
        self.voteCount = 0
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        barID <- map["barId"]
        barName <- map["barName"]
        voteCount <- map["voteCount"]
    }
}
