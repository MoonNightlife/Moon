//
//  FakeEventData.swift
//  Moon
//
//  Created by Evan Noble on 5/17/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation

var images = ["pic5.jpg", "pic3.jpg", "pic4.jpg", "pic7.jpg", "pic6.jpg", "pic2.jpg"]
var titles = ["Blink 182", "DJ Tiesto Live", "Below The Line ", "Nikko & Swae ", "Jellow Shot Party", "Halloween Special Event"]
var dates = ["10/05/2017", "19/04/2017", "06/11/2017", "03/12/2017", "01/25/2017", "06/10/2017"]
var descriptions = ["Come watch blink 182 Live! Event starts at 9:00 pm", "We are featuring the famouse DJ Tiesto at 11:00 pm. Buy a table and bring your friends", "Come listen to some good live country music at 7:00 pm with family and friends", "Two young DJs showing off their skills at 10:00pm", "We are having a $1 Jellow Shot party starting at 9:00pm! Bring your friends!", "Our annual Halloween custom will start at 8:00pm with $2 beers and $3 shots!"]

func createFakeEvents() -> [FeaturedEvent] {
    var events = [FeaturedEvent]()
    
    for index in 0..<images.count {
        events.append(FeaturedEvent(imageName: images[index], barName: barNames[index], date: dates[index], description: descriptions[index]))
    }
    
    return events
}

let fakeEvents = createFakeEvents()
