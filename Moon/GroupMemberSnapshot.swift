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
    
    init(snapshot: Snapshot) {
        super.init()
        self.name = snapshot.name
        self.id = snapshot.id
        self.username = snapshot.username
        self.isGoing = false
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        isGoing <- map["isGoing"]
        id <- map["id"]
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        
        name = (firstName ?? "") + " " + (lastName ?? "")
    }
}
