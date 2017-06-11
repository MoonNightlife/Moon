//
//  BarCell.swift
//  Moon
//
//  Created by Evan Noble on 6/10/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxDataSources
import UIKit

struct BarCell {
    let name: String
    let id: String
    let picture: String
}

extension BarCell: IdentifiableType {
    var identity: String {
        return id
    }
}

extension BarCell: Equatable {
    static func == (lhs: BarCell, rhs: BarCell) -> Bool {
        return lhs.id == rhs.id
    }
}
