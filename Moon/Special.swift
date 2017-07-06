//
//  Special.swift
//  Moon
//
//  Created by Evan Noble on 6/29/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources

class Special: Mappable {
    public var id: String?
    public var numLikes: Int?
    public var pic: String?
    public var name: String?
    public var description: String?
    public var barID: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        barID <- map["barId"]
        name <- map["barName"]
        pic <- map["photoUrl"]
        description <- map["description"]
        numLikes <- map["numberOfLikes"]
    }
}

extension Special: IdentifiableType {
    var identity: String {
        return id!
    }
}

extension Special: Equatable {
    static func == (lhs: Special, rhs: Special) -> Bool {
        return lhs.id == rhs.id
    }
}
