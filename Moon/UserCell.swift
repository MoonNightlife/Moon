//
//  UserCell.swift
//  Moon
//
//  Created by Evan Noble on 6/10/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxDataSources
import RxSwift

struct UserCell {
    let name: String
    let id: String
    let picture: String
}

extension UserCell: IdentifiableType {
    var identity: String {
        return id
    }
}

extension UserCell: Equatable {
    static func == (lhs: UserCell, rhs: UserCell) -> Bool {
        return lhs.id == rhs.id
    }
}
