//
//  TopBar.swift
//  Moon
//
//  Created by Evan Noble on 6/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import ObjectMapper

class TopBar: Mappable, Equatable {

    var name: String?
    var usersGoing: Int?
    var id: String?
    var lat: Double?
    var long: Double?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        usersGoing <- map["numberOfAttendees"]
        lat <- map["coordinates/lat"]
        long <- map["coordinates/long"]
    }
    
    static func == (lhs: TopBar, rhs: TopBar) -> Bool {
        return lhs.id == rhs.id && lhs.usersGoing == rhs.usersGoing
    }
}
