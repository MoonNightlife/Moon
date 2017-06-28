//
//  Array.swift
//  Moon
//
//  Created by Evan Noble on 6/26/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation

extension Array {
    public init(count: Int, elementCreator: @autoclosure () -> Element) {
        self = (0 ..< count).map { _ in elementCreator() }
    }
}
