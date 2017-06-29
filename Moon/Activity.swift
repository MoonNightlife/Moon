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
    
    public init() {}
    
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

extension BarActivity: IdentifiableType {
    var identity: String {
        guard let id = activityId else {
            return "0"
        }
        
        return id
    }
}

extension BarActivity: Equatable {
    static func == (lhs: BarActivity, rhs: BarActivity) -> Bool {
        return lhs.activityId == rhs.activityId && lhs.likes == rhs.likes
    }
}
