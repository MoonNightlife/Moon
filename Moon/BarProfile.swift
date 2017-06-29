//
//  BarProfile.swift
//  Moon
//
//  Created by Evan Noble on 6/29/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation

open class BarProfile {
    public var id: String?
    public var name: String?
    public var phoneNumber: String?
    public var location: String?
    public var website: String?
    public var address: String?
    public var numPeopleAttending: Int32?
    public var peopleAttending: [Activity]?
    public var specials: [Special]?
    public var barPics: [String]?
    public var events: [BarEvent]?
}
