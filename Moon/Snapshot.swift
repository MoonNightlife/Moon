//
//  Snapshot.swift
//  Moon
//
//  Created by Evan Noble on 6/24/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxDataSources
import SwaggerClient

extension Snapshot: IdentifiableType {
    public var identity: String {
        if let id = id {
            return id
        } else {
            return "0"
        }
    }
}

extension Snapshot: Equatable {
    public static func == (lhs: Snapshot, rhs: Snapshot) -> Bool {
        return lhs.id == rhs.id
    }
}
