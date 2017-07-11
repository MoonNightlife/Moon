//
//  FacebookUserInfo.swift
//  Moon
//
//  Created by Evan Noble on 7/11/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import ObjectMapper

struct FacebookUserInfo: Mappable {
    
    var firstName: String?
    var lastName: String?
    var sex: Sex?
    var profilePicutreURL: String?
    var birthday: String?
    var email: String?
    
    init?(map: Map){
    }
    
    mutating func mapping(map: Map) {
        self.firstName          <- map["first_name"]
        self.lastName           <- map["last_name"]
        self.sex                <- (map["gender"], GenderTransform)
        self.profilePicutreURL  <- map["picture.data.url"]
        self.birthday           <- map["birthday"]
        self.email              <- map["email"]
        
    }
}
