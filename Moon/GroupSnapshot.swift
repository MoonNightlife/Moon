//
//  GroupSnapshot.swift
//  Moon
//
//  Created by Evan Noble on 7/30/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources

class GroupSnapshot: Snapshot, Mappable {
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["groupName"]
    }
}
