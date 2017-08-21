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
    var id: String?
    var numLikes: Int?
    var pic: String?
    var name: String?
    var description: String?
    var barID: String?
    var type: AlcoholType?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        barID <- map["barId"]
        name <- map["barName"]
        pic <- map["photoName"]
        description <- map["description"]
        numLikes <- map["numberOfLikes"]
        type <- (map["type"], SpecialTypeTransform)
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
