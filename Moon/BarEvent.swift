//
//  BarEvent.swift
//  Moon
//
//  Created by Evan Noble on 6/29/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import ObjectMapper

class BarEvent: Mappable {
    public var id: String?
    public var barID: String?
    public var title: String?
    public var name: String?
    public var pic: String?
    public var date: String?
    public var description: String?
    public var numLikes: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        barID <- map["barId"]
        title <- map["title"]
        name <- map["barName"]
        pic <- map["photoUrl"]
        date <- map["date"]
        description <- map["description"]
        numLikes <- map["numberOfLikes"]
    }
}
