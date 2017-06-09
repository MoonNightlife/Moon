//
//  Enums.swift
//  Moon
//
//  Created by Evan Noble on 6/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation

enum MainView: Int {
    case featured
    case moons
    case explore
}

enum AlcoholType {
    case beer
    case liquor
    case wine
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
        case changeName = 0
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

enum ImageSource: CustomStringConvertible {
    case lastPhotoTaken
    case imagePicker
    
    var description: String {
        switch self {
        case .lastPhotoTaken:
            return "Last photo taken"
        case .imagePicker:
            return "Choose image from library"
        }
    }
}
