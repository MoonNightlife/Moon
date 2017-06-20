//
//  BarActivity.swift
//  Moon
//
//  Created by Evan Noble on 6/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxDataSources
import SwaggerClient

struct BarActivity {
    var barId: String?
    var barName: String?
    var name: String?
    var time: Date?
    var userId: String?
    var activityId: String?
    var likes: Int32?
    var profileImage: String?
    
    init(from activity: Activity) {
        //TODO: change bar name and user name form id to actual name once api is fixed
        self.barName = activity.barID
        self.name = activity.userID
        self.likes = activity.numLikes
        //TODO: change once time stamp is double
        //self.time = Date(timeIntervalSince1970: activity.timestamp)
    }
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
    static func == (lhs: BarActivity, rhs: BarActivity) -> Bool {
        return lhs.activityId == rhs.activityId && lhs.likes == rhs.likes
    }
}
