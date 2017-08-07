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
    var barID: String?
    var barName: String?
    var userID: String?
    var firstName: String?
    var lastName: String?
    var groupName: String?
    var timestamp: Double?
    var numLikes: Int?
    var pic: String?
    var userName: String {
        return (firstName ?? "") + " " + (lastName ?? "")
    }
    
    required init?(map: Map) {
        if map.JSON["id"] == nil {
            return nil
        }
    }
    
    func mapping(map: Map) {
        userID <- map["id"]
        barID <- map["activityInfo/barId"]
        barName <- map["activityInfo/barName"]
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        groupName <- map["groupName"]
        timestamp <- map["activityInfo/timeStamp"]
        numLikes <- map["activityInfo/numberOfLikes"]
    }
}

extension Activity: IdentifiableType {
    var identity: String {
        return userID!
    }
}

extension Activity: Equatable {
    static func == (lhs: Activity, rhs: Activity) -> Bool {
        return lhs.userID == rhs.userID
            && lhs.numLikes == rhs.numLikes
            && lhs.barID == rhs.barID
    }
}
