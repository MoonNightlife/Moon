//
//  CountryCode.swift
//  Moon
//
//  Created by Evan Noble on 6/15/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation

enum CountryCode: Int {
    case US = 0
    case BZ = 1
}

extension CountryCode {
    
    static let countryNames = [
        US : "United States",
        BZ : "Brazil"
    ]
    
    func countryName() -> String {
        if let minionName = CountryCode.countryNames[self] {
            return minionName
        } else {
            fatalError("No name for country")
        }
    }
    
    var description: String {
        get { return String(describing: self) + " (+\(self.rawValue))" }
    }
}
