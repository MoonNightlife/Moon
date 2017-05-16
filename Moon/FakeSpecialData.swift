//
//  FakeSpecialData.swift
//  Moon
//
//  Created by Evan Noble on 5/10/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import UIKit

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
    var image: UIImage? = UIImage(contentsOfFile: "miller.jpeg")
    var barName: String
}

let miller = #imageLiteral(resourceName: "miller.jpeg")
let budlight = #imageLiteral(resourceName: "budlight.jpeg")
let pbr = #imageLiteral(resourceName: "pbr.jpeg")
let whiteWine = #imageLiteral(resourceName: "whitewine.jpeg")
let redWine = #imageLiteral(resourceName: "redwine.jpeg")
let captain = #imageLiteral(resourceName: "captain.jpeg")
let patron = #imageLiteral(resourceName: "patron.jpeg")
let absolute = #imageLiteral(resourceName: "absolute.jpeg")
let sky = #imageLiteral(resourceName: "sky.jpeg")
let bacardi = #imageLiteral(resourceName: "bacardi.jpeg")
let jack = #imageLiteral(resourceName: "jack.jpeg")
let jose = #imageLiteral(resourceName: "jose.jpeg")

let barley = "Barley House"
let grapevine = "The Grapevine House"
let milo = "Milo Butterfingers"
let seven = "Seven Five Patio Bar"
let quater = "The Quarter Bar"
let pour = "The Standard Pour"
let ginger = "The Ginger Man"

var fakeSpecialData1 = Special(type: .beer, day: .tuesday, description: "BOGO Miller Lite", likes: 7, image: miller, barName: barley)
var fakeSpecialData2 = Special(type: .beer, day: .monday, description: "BOGO Budlight", likes: 2, image: budlight, barName: milo)
var fakeSpecialData3 = Special(type: .beer, day: .wednesday, description: "$2 PBR Tallboys", likes: 8, image: pbr, barName: seven)
var fakeSpecialData4 = Special(type: .beer, day: .tuesday, description: "$1 Budlight", likes: 10, image: budlight, barName: pour)
var fakeSpecialData5 = Special(type: .beer, day: .sunday, description: "$1.50 Miller Lite", likes: 2, image: miller, barName: ginger)
var fakeSpecialData6 = Special(type: .beer, day: .saturday, description: "BOGO PBR", likes: 9, image: pbr, barName: grapevine)
var fakeSpecialData7 = Special(type: .wine, day: .tuesday, description: "$2 House White Wine", likes: 2, image: whiteWine, barName: grapevine)
var fakeSpecialData8 = Special(type: .wine, day: .thursday, description: "$2 House Red White", likes: 6, image: redWine, barName: grapevine)
var fakeSpecialData9 = Special(type: .liquor, day: .monday, description: "$4 Captian and Coke", likes: 7, image: captain, barName: barley)
var fakeSpecialData10 = Special(type: .liquor, day: .sunday, description: "$6 Patron Margaritas", likes: 9, image: patron, barName: milo)
var fakeSpecialData11 = Special(type: .liquor, day: .tuesday, description: "$3 Abosolute Vodka Shots", likes: 4, image: absolute, barName: seven)
var fakeSpecialData12 = Special(type: .liquor, day: .wednesday, description: "$2 Sky Vodka Shots", likes: 2, image: sky, barName: quater)
var fakeSpecialData13 = Special(type: .liquor, day: .wednesday, description: "$4 Rum and Cokes", likes: 4, image: bacardi, barName: pour)
var fakeSpecialData14 = Special(type: .liquor, day: .thursday, description: "$5 Jack and Gingers", likes: 9, image: jack, barName: ginger)
var fakeSpecialData15 = Special(type: .liquor, day: .friday, description: "$2 Jose Tequila Shots", likes: 14, image: jose, barName: barley)

let fakeSpecials = [fakeSpecialData1, fakeSpecialData2, fakeSpecialData3, fakeSpecialData4, fakeSpecialData5, fakeSpecialData6, fakeSpecialData7, fakeSpecialData8, fakeSpecialData9, fakeSpecialData10, fakeSpecialData11, fakeSpecialData12, fakeSpecialData13, fakeSpecialData14, fakeSpecialData15]
