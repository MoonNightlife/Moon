//
//  BarSnapshot.swift
//  Moon
//
//  Created by Evan Noble on 7/10/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources

class BarSnapshot: Snapshot, Mappable {
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}
