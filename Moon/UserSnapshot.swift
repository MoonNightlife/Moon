//
//  UserSnapshot.swift
//  Moon
//
//  Created by Evan Noble on 6/13/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxDataSources
import UIKit

struct UserSnapshot {
    let name: String
    let id: String
    let picture: UIImage
}

extension UserSnapshot: IdentifiableType {
    var identity: String {
        return id
    }
}

extension UserSnapshot: Equatable {
    static func == (lhs: UserSnapshot, rhs: UserSnapshot) -> Bool {
        return lhs.id == rhs.id
    }
}
