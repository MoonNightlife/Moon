//
//  FakeSpecialData.swift
//  Moon
//
//  Created by Evan Noble on 5/10/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation

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

struct Special {
    var type: AlcoholType
    var day: DayOfWeek
    var description: String
    var likes: Int
}
