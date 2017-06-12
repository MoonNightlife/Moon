//
//  FakeUserData.swift
//  Moon
//
//  Created by Gabriel I Leyva Merino on 5/17/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import UIKit

let profilePics = ["p1.jpg", "p2.jpg", "p3.jpg", "p4.jpg", "p5.jpg", "p6.jpg", "p8.jpg", "p7.jpg"]
let names = ["Collin Duzyk", "Camden Moore", "Mony Gonzalez", "Molly Smith", "Marisol Leiva", "Sloan Stearman", "Andrea Adler", "Henry Berhle"]

let fakeNames = ["Collin", "Camden", "Mony", "Marisol", "Molly", "Sloan", "Henry", "Andrea"]
let fakeLastNames = ["Duzyk", "Moore", "Gonzalez", "Leiva", "Smith", "Stearman", "Brlhe", "Adler"]

let barNames = ["The Barley House", "Avenu Lounge", "The Standard Pour", "Next Door", "Avenu Lounge", "Piano Bar", "The Fat Rabbit", "Trophy Room"]

var profilePicsImages = [#imageLiteral(resourceName: "p1.jpg"), #imageLiteral(resourceName: "p2.jpg"), #imageLiteral(resourceName: "p3.jpg"), #imageLiteral(resourceName: "pp2.jpg"), #imageLiteral(resourceName: "p4.jpg"), #imageLiteral(resourceName: "p6.jpg"), #imageLiteral(resourceName: "p7.jpg"), #imageLiteral(resourceName: "p8.jpg")]

func createFakeBarActivities() -> [BarActivity] {
    var activities = [BarActivity]()
    
    for i in 0..<names.count {
    
        let activity = BarActivity(barId: "123", barName: barNames[i], name: names[i], time: Date(), username: names[i], userId: "666", activityId: "456", likes: i * 3, profileImage: profilePics[i])
       activities.append(activity)
    }
    return activities
}

func createFakeUsers() -> [FakeUser] {
    var fakeUsers = [FakeUser]()
    for i in 0..<profilePicsImages.count {
        let fakeUser = FakeUser(firstName: fakeNames[i], lastName: fakeLastNames[i], city: "", username: "", pics: [profilePicsImages[i]], bio: "", plan: "")
        fakeUsers.append(fakeUser)
    }
    
    return fakeUsers
}
