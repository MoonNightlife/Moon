//
//  Special.swift
//  Moon
//
//  Created by Evan Noble on 6/29/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources

class Special {
    public var id: String?
    public var numLikes: Int32?
    public var pic: String?
    public var name: String?
    public var description: String?
    public var barID: String?
    public var type: String?
}

extension Special: IdentifiableType {
    var identity: String {
        return id!
    }
}

extension Special: Equatable {
    static func == (lhs: Special, rhs: Special) -> Bool {
        return lhs.id == rhs.id
    }
}
