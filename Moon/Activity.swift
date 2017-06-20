//
//  Activity.swift
//  Moon
//
//  Created by Evan Noble on 6/20/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxDataSources
import SwaggerClient

extension Activity: IdentifiableType {
    public var identity: String {
        guard let id = activityID else {
            return "0"
        }
        
        return id
    }
}

extension Activity: Equatable {
    public static func == (lhs: Activity, rhs: Activity) -> Bool {
        return lhs.activityID == rhs.activityID && lhs.numLikes == rhs.numLikes
    }
}
