//
//  TimeInterval.swift
//  Moon
//
//  Created by Evan Noble on 8/2/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation

extension TimeInterval {
    
    func format() -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 2
        return formatter.string(from: self)
    }
}
