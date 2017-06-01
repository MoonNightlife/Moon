//
//  ValidationUtility.swift
//  Moon
//
//  Created by Evan Noble on 5/31/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation

protocol SignUpValidation {
    func valid(firstName: String) -> Bool
    func valid(lastName: String) -> Bool
    func valid(username: String) -> Bool
    func valid(email: String) -> Bool
    func valid(birthday: String) -> Bool
    func valid(sex: String) -> Bool
    func valid(password: String, retypedPassword: String) -> Bool
}

class ValidationUtility: SignUpValidation {
    func valid(email: String) -> Bool {
        return true
    }
    func valid(firstName: String) -> Bool {
        return firstName.characters.count > 0 ? true : false
    }
    
    func valid(lastName: String) -> Bool {
        return lastName.characters.count > 0 ? true : false
    }
    
    func valid(username: String) -> Bool {
        return true
    }
    
    func valid(birthday: String) -> Bool {
        return true
    }
    
    func valid(sex: String) -> Bool {
        return true
    }
    
    func valid(password: String, retypedPassword: String) -> Bool {
        return true
    }
}
