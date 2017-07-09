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
    var firstName: String?
    var lastName: String?
    var name: String {
        return (firstName ?? "") + " " + (lastName ?? "")
    }
    var pic: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        firstName <- map["firstName"]
        lastName <- map["lastName"]
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
