//
//  Enums.swift
//  Moon
//
//  Created by Evan Noble on 6/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation

enum MyError: Error {
    case SignUpError
}

enum Sex: Int {
    case male
    case female
    case none
    
    func toString() -> String {
        switch self {
        case .male: return "Male"
        case .female: return "Female"
        case .none: return "Rather Not Say"
        }
    }
    
}

enum MainView: Int {
    case featured
    case moons
    case explore
}

enum AlcoholType: String {
    case beer = "Beer"
    case liquor = "Liquor"
    case wine = "Wine"
    
    static func from(int: Int) -> AlcoholType? {
        switch int {
        case 0:
            return self.beer
        case 1:
            return self.liquor
        case 2:
            return self.wine
        default:
            return nil
        }
    }
    
    func toInt() -> Int {
        switch self {
        case .beer: return 0
        case .liquor: return 1
        case .wine: return 2
        }
    }
    
    func lowerCaseName() -> String {
        return self.rawValue.lowercased()
    }
}

enum DayOfWeek {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
}

enum HeartColor {
    case red
    case gray
}

enum Setting {
    case myAccount(option: SettingSections.MyAccount)
    case moreInformation(option: SettingSections.MoreInformation)
    case accountActions(option: SettingSections.AccountActions)
}

enum SettingSections {
    enum MyAccount: Int {
        case username = 0
        case changePhoneNumber = 1
        case changeEmail = 2
        case notifications = 3
    }
    
    enum AccountActions: Int {
        case logOut = 0
        case deleteAccount = 1
    }
    
    enum MoreInformation: Int {
        case privacyPolicy = 0
        case termsAndConditions = 1
        case support = 2
    }
}

enum SearchType: Int {
    case users
    case bars
}

enum UserTableSource {
    case user(id: String)
    case special(id: String)
    case event(id: String)
    case activity(id: String)
}

enum ProfileActionButton {
    case edit
    case addFriend
    case removeFriend
    case cancelRequest
    case acceptRequest
}

enum NewUserType {
    case firebase
    case facebook
}
