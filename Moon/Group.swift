//
//  Group.swift
//  Moon
//
//  Created by Evan Noble on 7/26/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import ObjectMapper

struct Group: Mappable {
    var name: String?
    var plan: Plan?
    var activityInfo: ActivityInfo?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        plan <- map["plan"]
        activityInfo <- map["activityInfo"]
    }
}
