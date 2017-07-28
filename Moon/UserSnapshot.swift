//
//  UserSnapshot.swift
//  Moon
//
//  Created by Evan Noble on 7/26/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import ObjectMapper

class UserSnapshot: Snapshot, Mappable {
    var firstName: String?
    var lastName: String?
    
    override init() {

    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        username <- map["username"]
        
        name = (firstName ?? "") + " " + (lastName ?? "")
    }
}
