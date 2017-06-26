//
//  TopBar.swift
//  Moon
//
//  Created by Evan Noble on 6/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import CoreLocation
import SwaggerClient

struct TopBar {
    let imageURL: URL
    let barName: String
    let usersGoing: String
    let coordinates: CLLocationCoordinate2D?
    
    init(from profile: BarProfile) {
        self.imageURL = URL(string: profile.barPics!.first!)!
        self.barName = profile.name ?? "No Name"
        self.usersGoing = "\(profile.numPeopleAttending ?? 0)"
        self.coordinates = fakeCoordinates[0]
    }
}
