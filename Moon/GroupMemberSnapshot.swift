//
//  GroupMemberSnapshot.swift
//  Moon
//
//  Created by Evan Noble on 7/26/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import ObjectMapper

class GroupMemberSnapshot: UserSnapshot {
    var isGoing: Bool?
    
    override func mapping(map: Map) {
        isGoing <- map["isGoing"]
        name <- map["groupName"]
        id <- map["id"]
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        
        name = (firstName ?? "") + " " + (lastName ?? "")
    }
}
