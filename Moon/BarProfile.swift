//
//  BarProfile.swift
//  Moon
//
//  Created by Evan Noble on 6/29/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import ObjectMapper
import Foundation

class BarProfile: Mappable {
    var id: String?
    var name: String?
    var phoneNumber: String?
    var website: String?
    var address: String?
    var numPeopleAttending: Int32?
    var barPics: [String]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        phoneNumber <- map["phoneNumber"]
        website <- map["website"]
        address <- map["address"]
        numPeopleAttending <- map["numberOfAttendees"]
        barPics <- map["photoUrls"]
    }
}
