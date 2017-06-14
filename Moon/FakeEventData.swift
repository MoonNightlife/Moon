//
//  FakeEventData.swift
//  Moon
//
//  Created by Evan Noble on 5/17/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import UIKit

var images = ["pic5.jpg", "pic3.jpg", "pic4.jpg", "pic7.jpg", "pic6.jpg", "pic2.jpg"]
var eventImages = [#imageLiteral(resourceName: "e1.jpg"), #imageLiteral(resourceName: "e2.jpg"), #imageLiteral(resourceName: "e3.jpg"), #imageLiteral(resourceName: "e4.jpg"), #imageLiteral(resourceName: "e5.jpg"), #imageLiteral(resourceName: "e6.jpg")]
var titles = ["Blink 182 Live", "DJ Tiesto Live Live", "Below The Line Live", "Kygo Live", "Jellow Shot Party", "Halloween Party"]
var dates = ["10/05/2017", "19/04/2017", "06/11/2017", "03/12/2017", "01/25/2017", "06/10/2017"]
var descriptions = ["Come watch blink 182 Live! Event starts at 9:00 pm and will end at midnight. We will be selling concert t-shirts and having some awesome specials", "We are featuring the famouse DJ Tiesto at 11:00 pm. Buy a table and bring your friends", "Come listen to some good live country music at 7:00 pm with family and friends", "Kygo will be performing at 10:00pm", "We are having a $1 Jellow Shot party starting at 9:00pm! Bring your friends!", "Our annual Halloween custom will start at 8:00pm with $2 beers and $3 shots!"]

func createFakeEvents() -> [FeaturedEvent] {
    var events = [FeaturedEvent]()
    
    for index in 0..<images.count {
        events.append(FeaturedEvent(image: eventImages[index], barName: barNames[index], date: dates[index], description: descriptions[index], title: titles[index], id: "123"))
    }
    
    return events
}

let fakeEvents = createFakeEvents()
