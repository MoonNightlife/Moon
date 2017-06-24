//
//  Special.swift
//  Moon
//
//  Created by Evan Noble on 6/24/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxDataSources
import SwaggerClient

extension Special: IdentifiableType {
    public var identity: String {
        guard let id = id else {
            return "0"
        }
        
        return id
    }
}

extension Special: Equatable {
    public static func == (lhs: Special, rhs: Special) -> Bool {
        return lhs.id == rhs.id && lhs.numLikes == rhs.numLikes
    }
}
