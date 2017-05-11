//
//  Utilities.swift
//  Moon
//
//  Created by Evan Noble on 5/11/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation

/**
 This function turns a date into an elasped time string.
 - Author: Evan Noble
 - Parameters:
 - fromDate: NSDate to be converted to string
 */
func getElaspedTimefromDate(fromDate: NSDate) -> String {
    
    let elaspedTime = fromDate.timeIntervalSinceNow
    
    // Display correct time. Hours, Minutes
    if (elaspedTime * -1) < 60 {
        return "<1m"
    } else if (elaspedTime * -1) < 3600 {
        return "\(Int(elaspedTime / (-60)))m"
    } else {
        return "\(Int(elaspedTime / (-3600)))h"
    }
}
