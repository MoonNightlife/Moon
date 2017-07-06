//
//  UserProfile.swift
//  Moon
//
//  Created by Evan Noble on 6/29/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import ObjectMapper

class UserProfile: Mappable {
    var id: String?
    var username: String?
    var firstName: String?
    var lastName: String?
    var phoneNumber: String?
    var profilePics: [String]?
    var barName: String?
    var barId: String?
    var bio: String?
    
    init() {

    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        username <- map["username"]
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        phoneNumber <- map["phoneNumber"]
        profilePics <- map["photoUrls"]
        barName <- map["barName"]
        barId <- map["barId"]
        bio <- map["bio"]
    }

}
