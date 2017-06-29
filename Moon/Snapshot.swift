//
//  Snapshot.swift
//  
//
//  Created by Evan Noble on 6/29/17.
//
//

import Foundation
import ObjectMapper
import RxDataSources

class Snapshot: Mappable {
    var id: String?
    var name: String?
    var pic: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        pic <- map["pic"]
    }
}

extension Snapshot: IdentifiableType {
    var identity: String {
        return id!
    }
}

extension Snapshot: Equatable {
    static func == (lhs: Snapshot, rhs: Snapshot) -> Bool {
        return lhs.id == rhs.id
    }
}
