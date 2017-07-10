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

class Snapshot: IdentifiableType, Equatable {
    var id: String?
    var name: String?
    var pic: String?
    var username: String?
    
    var identity: String {
        return id!
    }
    
    static func == (lhs: Snapshot, rhs: Snapshot) -> Bool {
        return lhs.id == rhs.id
    }
}

class UserSnapshot: Snapshot, Mappable {
    var firstName: String?
    var lastName: String?
    
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
