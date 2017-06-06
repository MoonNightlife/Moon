//
//  BarActivity.swift
//  Moon
//
//  Created by Evan Noble on 6/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxDataSources

struct BarActivity {
    var barId: String?
    var barName: String?
    var name: String?
    var time: Date?
    var username: String?
    var userId: String?
    var activityId: String?
    var likes: Int?
    var profileImage: String?
}

extension BarActivity: IdentifiableType {
    var identity: String {
        guard let id = activityId else {
            return "0"
        }
        
        return id
    }
}

extension BarActivity: Equatable {
    static func ==(lhs: BarActivity, rhs: BarActivity) -> Bool {
        return lhs.activityId == rhs.activityId && lhs.likes == rhs.likes
    }
}
