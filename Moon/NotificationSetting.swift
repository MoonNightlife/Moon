//
//  NotificationSetting.swift
//  Moon
//
//  Created by Evan Noble on 7/19/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import ObjectMapper

struct NotificationSetting: Mappable {
    var name: String?
    var displayName: String?
    var activated: Bool?
    
    init?(map: Map) {
    
    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        displayName <- map["displayName"]
        activated <- map["activated"]
    }
}
