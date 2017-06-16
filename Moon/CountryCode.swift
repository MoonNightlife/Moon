//
//  CountryCode.swift
//  Moon
//
//  Created by Evan Noble on 6/15/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation

enum CountryCode: Int {
    case US = 1
    case BZ = 55
    case UK = 44
}

extension CountryCode {
    
    static let countryNames = [
        US: "United States",
        BZ: "Brazil",
        UK: "United Kingdom"
    ]
    
    static let index = [US, BZ, UK]
    
    static func getCodeFor(index: Int) -> CountryCode {
        return CountryCode.index[index] 
    }
    
    func countryName() -> String {
        if let codeName = CountryCode.countryNames[self] {
            return codeName + " +(\(self.rawValue))"
        } else {
            fatalError("No name for country")
        }
    }
    
    static func nameArray() -> [String] {
        var names = [String]()
        for isoName in CountryCode.index {
            names.append(isoName.countryName())
        }
        return names
    }
    
    var description: String {
        get { return String(describing: self) + " (+\(self.rawValue))" }
    }
    
    var isoAlpha2: String {
        get { return String(describing: self) }
    }
}
