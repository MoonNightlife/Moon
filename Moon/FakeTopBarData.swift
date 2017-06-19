//
//  FakeTopBarData.swift
//  Moon
//
//  Created by Evan Noble on 5/18/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import CoreLocation

func createTempTopBarData() -> [TopBar] {
    var a = [TopBar]()
    for i in 0..<images.count {
        //let data = TopBar(imageURLs: images[i], barName: barNames[i], usersGoing: "\(UInt32(i) * arc4random_uniform(20)+2)", coordinates: coordinates[i])
        //a.append(data)
    }
    return a
}

let coordinates = [
    CLLocationCoordinate2D(latitude: 32.8418, longitude: -96.7720),
    CLLocationCoordinate2D(latitude: 32.8001, longitude: -96.8006),
    CLLocationCoordinate2D(latitude: 32.7997, longitude: -96.8007),
    CLLocationCoordinate2D(latitude: 32.8000, longitude: -96.8006),
    CLLocationCoordinate2D(latitude: 32.7843, longitude: -96.7863),
    CLLocationCoordinate2D(latitude: 32.7980, longitude: -96.8010)
]

let fakeTopBars = createTempTopBarData()
