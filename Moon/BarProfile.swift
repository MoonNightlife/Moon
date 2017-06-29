//
//  BarProfile.swift
//  Moon
//
//  Created by Evan Noble on 6/29/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation

class BarProfile {
    var id: String?
    var name: String?
    var phoneNumber: String?
    var location: String?
    var website: String?
    var address: String?
    var numPeopleAttending: Int32?
    var peopleAttending: [Activity]?
    var specials: [Special]?
    var barPics: [String]?
    var events: [BarEvent]?
}
