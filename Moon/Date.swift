//
//  Date.swift
//  Moon
//
//  Created by Evan Noble on 6/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation

extension Date {
    /**
     This function turns a date into an elasped time string.
     - Author: Evan Noble
     - Parameters:
     - fromDate: NSDate to be converted to string
     */
    func getElaspedTimefromDate() -> String {
        
        let elaspedTime = timeIntervalSinceNow
        
        // Display correct time. Hours, Minutes
        if (elaspedTime * -1) < 60 {
            return "<1m"
        } else if (elaspedTime * -1) < 3600 {
            return "\(Int(elaspedTime / (-60)))m"
        } else {
            return "\(Int(elaspedTime / (-3600)))h"
        }
    }
}
