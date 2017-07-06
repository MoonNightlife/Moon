//
//  NewUser.swift
//  Moon
//
//  Created by Evan Noble on 5/31/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import ObjectMapper

class NewUser: Mappable {
    var firstName: String?
    var lastName: String?
    var birthday: String?
    var sex: Sex?
    var password: String?
    var email: String?
    var username: String?
    var image: Data?
    
    init() {

    }
    
    required init?(map: Map) {

    }
    
    func mapping(map: Map) {
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        birthday <- map["birthday"]
        sex <- (map["sex"], SexTransform)
        password <- map["password"]
        email <- map["email"]
        username <- map["username"]
    }
    
}

