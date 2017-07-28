//
//  ValidationUtility.swift
//  Moon
//
//  Created by Evan Noble on 5/31/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation

protocol ValidationUtilityType {
    static func validName(firstName: String?, lastName: String?) -> Bool
    static func validGroupName(name: String?) -> Bool
    static func validUsername(username: String?) -> Bool
    static func validEmail(email: String?) -> Bool
    static func validBirthday(birthday: Date?) -> Bool
    static func validPassword(password: String?) -> Bool
}

struct ValidationConstants {
    static let maxNameCount = 18
    static let minNameCount = 1
    static let maxUsernameCount = 12
    static let minUsernameCount = 5
    static let minPasswordCount = 6
}

class ValidationUtility: ValidationUtilityType {
    static func validEmail(email: String?) -> Bool {
        guard let email = email else {
            return false
        }
         let correctFormat = correctEmailFormat(email: email)
        return correctFormat && !email.characters.isEmpty
    }
    static func validBirthday(birthday: Date?) -> Bool {
        guard let birthday = birthday else {
            return false
        }
        
        // The max birthday that can be choosen is one that ensures the user is 18 years old
        var components = DateComponents()
        components.year = -18
        if let maxDate = Calendar.current.date(byAdding: components, to: Date()) {
            return birthday.compare(maxDate) == .orderedAscending || birthday.compare(maxDate) == .orderedSame
        }
        
        return false
    }
    
    static func validPassword(password: String?) -> Bool {
        guard let password = password else {
            return false
        }
        let isValidLength = (password.characters.count >= ValidationConstants.minPasswordCount)
        let containsSpaces = whiteSpacesIn(string: password)
        
        return isValidLength && !containsSpaces
    }
    static func validUsername(username: String?) -> Bool {
        guard let username = username else {
            return false
        }
        let isValidLength = (username.characters.count >= ValidationConstants.minUsernameCount) && (username.characters.count <= ValidationConstants.maxUsernameCount)
        let containsSpaces = whiteSpacesIn(string: username)
        let containsSpecialAndUppercaseChars = speceialsCharactersAndUpperCaseLettersIn(string: username)

        return isValidLength && !containsSpaces && !containsSpecialAndUppercaseChars
    }
    static func validName(firstName: String?, lastName: String?) -> Bool {
        guard let firstName = firstName, let lastName = lastName else {
            return false
        }
        let fnIsValidLength = (firstName.characters.count < ValidationConstants.maxNameCount) && (firstName.characters.count >= ValidationConstants.minNameCount)
        let fnContainsSpecialCharsAndNums = specialCharactersAndNumbersIn(string: firstName)
        
        let lnIsValidLength = (lastName.characters.count < ValidationConstants.maxNameCount) && (lastName.characters.count >= ValidationConstants.minNameCount)
        let lnContainsSpecialCharsAndNums = specialCharactersAndNumbersIn(string: lastName)
        
        let hasNonWhiteChars = stringHasNonWhiteChars(string: firstName) && stringHasNonWhiteChars(string: lastName)

        return fnIsValidLength && lnIsValidLength && !fnContainsSpecialCharsAndNums && !lnContainsSpecialCharsAndNums && hasNonWhiteChars
    }
    static func validGroupName(name: String?) -> Bool {
        guard let name = name else {
            return false
        }
        
        let validLength = name.characters.count < ValidationConstants.maxNameCount && name.characters.count > ValidationConstants.minNameCount
        let hasNonWhiteChars = stringHasNonWhiteChars(string: name)
        let hasSpecialCharsAndNums = specialCharactersAndNumbersIn(string: name)
        
        return validLength && !hasSpecialCharsAndNums && hasNonWhiteChars
    }
}

extension ValidationUtility {
    // Returns true if there are numbers or special characters
    fileprivate static func specialCharactersAndNumbersIn(string: String) -> Bool {
        
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ ")
    
        if string.rangeOfCharacter(from: characterset.inverted) != nil {
            return true
        } else {
            return false
        }
    }
    
    // Checks for special characters and uppercase letters and will return true if any are found
    fileprivate static func speceialsCharactersAndUpperCaseLettersIn(string: String) -> Bool {
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz0123456789")
        if string.rangeOfCharacter(from: characterset.inverted) != nil {
            return true
        } else {
            return false
        }
    }
    
    // Returns true if there are white spaces in the string
    fileprivate static func whiteSpacesIn(string: String) -> Bool {
        let whitespace = CharacterSet.whitespaces
        
        let range = string.rangeOfCharacter(from: whitespace)
        
        // Range will be nil if no whitespace is found
        if range != nil {
            return true
        } else {
            return false
        }
    }
    
    // Returns true if email is in right format
    fileprivate static func correctEmailFormat(email: String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    fileprivate static func stringHasNonWhiteChars(string: String) -> Bool {
        if !string.trimmingCharacters(in: .whitespaces).isEmpty {
            return true
        } else {
            return false
        }
    }
}
