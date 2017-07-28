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
    var username: String?
    
    init() {
    }
    
    var identity: String {
        return id!
    }
    
    static func == (lhs: Snapshot, rhs: Snapshot) -> Bool {
        return lhs.id == rhs.id
    }
}
