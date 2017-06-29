//
//  Activity.swift
//  Moon
//
//  Created by Evan Noble on 6/29/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources

class Activity: Mappable {
    var id: String?
    var barID: String?
    var barName: String?
    var userID: String?
    var userName: String?
    var timestamp: Double?
    var numLikes: Int?
    var pic: String?
    
    required init?(map: Map) {
        if map.JSON["id"] == nil {
            return nil
        }
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        barID <- map["barId"]
        barName <- map["barName"]
        userID <- map["userId"]
        userName <- map["userName"]
        timestamp <- map["timeStamp"]
        numLikes <- map["numberOfLikes"]
        pic <- map["photoThumbnail"]
    }
}

extension Activity: IdentifiableType {
    var identity: String {
        return id!
    }
}

extension Activity: Equatable {
    static func == (lhs: Activity, rhs: Activity) -> Bool {
        return lhs.id == rhs.id
    }
}
