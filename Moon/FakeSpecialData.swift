//
//  FakeSpecialData.swift
//  Moon
//
//  Created by Evan Noble on 5/10/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import UIKit

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

var fakeSpecialData1 = Special(type: .beer, day: .tuesday, description: "$3 off Texas Drafts", likes: 7, image: #imageLiteral(resourceName: "s1.jpg"), barName: barley)
var fakeSpecialData2 = Special(type: .beer, day: .monday, description: "$2 Beers", likes: 2, image: #imageLiteral(resourceName: "s2.jpg"), barName: milo)
var fakeSpecialData3 = Special(type: .beer, day: .wednesday, description: "$5 Pitchers", likes: 8, image: #imageLiteral(resourceName: "s3.jpg"), barName: seven)
var fakeSpecialData4 = Special(type: .beer, day: .tuesday, description: "Beer Night ($1 Beers)", likes: 10, image: #imageLiteral(resourceName: "s4.jpg"), barName: pour)
var fakeSpecialData6 = Special(type: .wine, day: .saturday, description: "$8 Bottle of Wine", likes: 9, image: #imageLiteral(resourceName: "s6.jpg"), barName: grapevine)
var fakeSpecialData7 = Special(type: .wine, day: .tuesday, description: "$2 House White Wine", likes: 2, image: #imageLiteral(resourceName: "s7.jpg"), barName: grapevine)
var fakeSpecialData8 = Special(type: .wine, day: .thursday, description: "$2 House Red White", likes: 6, image: #imageLiteral(resourceName: "s8.jpg"), barName: grapevine)
var fakeSpecialData9 = Special(type: .liquor, day: .monday, description: "$4 Rum and Coke", likes: 7, image: #imageLiteral(resourceName: "s9.jpg"), barName: barley)
var fakeSpecialData10 = Special(type: .liquor, day: .sunday, description: "$6 Margaritas", likes: 9, image: #imageLiteral(resourceName: "s10.jpg"), barName: milo)
var fakeSpecialData11 = Special(type: .liquor, day: .tuesday, description: "$3 Fireball Shots", likes: 4, image: #imageLiteral(resourceName: "s11.jpg"), barName: seven)
var fakeSpecialData12 = Special(type: .liquor, day: .wednesday, description: "$5 Tequila Shots", likes: 2, image: #imageLiteral(resourceName: "s12.jpg"), barName: quater)
var fakeSpecialData13 = Special(type: .liquor, day: .wednesday, description: "Happy Hour 6-7", likes: 4, image: #imageLiteral(resourceName: "s13.jpg"), barName: pour)
var fakeSpecialData14 = Special(type: .liquor, day: .thursday, description: "$5 Moscow Mules", likes: 9, image: #imageLiteral(resourceName: "s14.jpg"), barName: ginger)

let fakeSpecials = [fakeSpecialData1, fakeSpecialData2, fakeSpecialData3, fakeSpecialData4, fakeSpecialData6, fakeSpecialData7, fakeSpecialData8, fakeSpecialData9, fakeSpecialData10, fakeSpecialData11, fakeSpecialData12, fakeSpecialData13, fakeSpecialData14]
