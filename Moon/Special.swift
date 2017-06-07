//
//  Special.swift
//  Moon
//
//  Created by Evan Noble on 6/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import UIKit
import RxDataSources

struct Special {
    let type: AlcoholType
    let day: DayOfWeek
    let description: String
    let likes: Int
    let image: UIImage
    let barName: String
    var specialID: String?
}

extension Special: Equatable {
    static func == (lhs: Special, rhs: Special) -> Bool {
        return lhs.specialID == rhs.specialID && lhs.likes == rhs.likes
    }
}

extension Special: IdentifiableType {
    var identity: String {
        return specialID ?? "0"
    }
}
