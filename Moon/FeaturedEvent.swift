//
//  FeaturedEvent.swift
//  Moon
//
//  Created by Evan Noble on 6/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import UIKit
import SwaggerClient

struct FeaturedEvent {
    var imageURL: URL
    var barName: String
    var date: String
    var description: String
    var title: String
    var id: String
    
    init(from event: BarEvent) {
        self.barName = event.name ?? "No Bar Name"
        self.imageURL = URL(string: event.pic ?? "")!
        self.date = event.date ?? "No Date"
        self.description = event.description ?? "No Description"
        self.title = event.title ?? "No Title"
        self.id = event.id ?? "No ID"
    }
}
