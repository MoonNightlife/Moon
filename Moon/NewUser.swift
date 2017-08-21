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
    var profileURL: URL?
    var type: NewUserType?
    
    init() {
        self.type = .firebase
    }
    
    init(facebookInfo: FacebookUserInfo) {
        
        self.type = .facebook
        
        if let urlString = facebookInfo.profilePicutreURL {
            self.profileURL = URL(string: urlString)
        }
        self.firstName = facebookInfo.firstName
        self.lastName = facebookInfo.lastName
        self.sex = facebookInfo.sex
        self.email = facebookInfo.email
        self.birthday = facebookInfo.birthday
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
