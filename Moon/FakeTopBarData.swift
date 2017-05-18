//
//  FakeTopBarData.swift
//  Moon
//
//  Created by Evan Noble on 5/18/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation

struct TopBarData {
    let imageName: String
    let barName: String
    let usersGoing: String
}

func createTempTopBarData() -> [TopBarData] {
    var a = [TopBarData]()
    for i in 0..<images.count {
        let data = TopBarData(imageName: images[i], barName: barNames[i], usersGoing: "\(UInt32(i) * arc4random_uniform(20)+2)")
        a.append(data)
    }
    return a
}

let fakeTopBars = createTempTopBarData()
