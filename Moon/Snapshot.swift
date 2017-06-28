//
//  Snapshot.swift
//  Moon
//
//  Created by Evan Noble on 6/24/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxDataSources

struct Snapshot {
    let _id: String?
    let name: String?
    let pic: String?
}
extension Snapshot: IdentifiableType {
    public var identity: String {
        if let id = _id {
            return id
        } else {
            return "0"
        }
    }
}

extension Snapshot: Equatable {
    public static func == (lhs: Snapshot, rhs: Snapshot) -> Bool {
        return lhs._id == rhs._id
    }
}
