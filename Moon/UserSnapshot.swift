//
//  UserSnapshot.swift
//  Moon
//
//  Created by Evan Noble on 6/20/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxDataSources
import SwaggerClient

extension UserSnapshot: IdentifiableType {
    public var identity: String {
        guard let id = userID else {
            return "0"
        }
        
        return id
    }
}

extension UserSnapshot: Equatable {
    public static func == (lhs: UserSnapshot, rhs: UserSnapshot) -> Bool {
        return lhs.userID == rhs.userID
    }
}
