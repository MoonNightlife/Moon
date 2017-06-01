//
//  ValidationUtility.swift
//  Moon
//
//  Created by Evan Noble on 5/31/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation

protocol SignUpValidation {
    static func validName(firstName: String, lastName: String) -> Bool
    static func validUsername(username: String) -> Bool
    static func validEmail(email: String) -> Bool
    static func validBirthday(birthday: String) -> Bool
    static func validSex(sex: String) -> Bool
    static func validPassword(password: String) -> Bool
}

class ValidationUtility: SignUpValidation {
    static func validSex(sex: String) -> Bool {
        return true
    }
    static func validEmail(email: String) -> Bool {
        return true
    }
    static func validBirthday(birthday: String) -> Bool {
        return true
    }
    static func validPassword(password: String) -> Bool {
        return true
    }
    static func validUsername(username: String) -> Bool {
        return true
    }
    static func validName(firstName: String, lastName: String) -> Bool {
        return true
    }
}
