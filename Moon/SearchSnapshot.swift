//
//  SearchSnapshot.swift
//  Moon
//
//  Created by Evan Noble on 6/10/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxDataSources
import UIKit

struct SearchSnapshot {
    let name: String
    let id: String
    let picture: String
}

extension SearchSnapshot: IdentifiableType {
    var identity: String {
        return id
    }
}

extension SearchSnapshot: Equatable {
    static func == (lhs: SearchSnapshot, rhs: SearchSnapshot) -> Bool {
        return lhs.id == rhs.id
    }
}
