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
    
    /**
     This function gets the current day and includes a 5 hour offset. That way when people are out at night they still see the specials for that night even though it is the next day
     - Author: Evan Noble
     - Returns: the current weekday
     */
    static func getCurrentDay() -> DayOfWeek? {
        let currentDate = Date()
        let dateOffset = currentDate.addingTimeInterval(60 * 60 * -5.0)
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: dateOffset)
        let weekDay = myComponents.weekday

        guard let day = weekDay else {
            return nil
        }
        
        switch day {
        case 1:
            return DayOfWeek.sunday
        case 2:
            return DayOfWeek.monday
        case 3:
            return DayOfWeek.tuesday
        case 4:
            return DayOfWeek.wednesday
        case 5:
            return DayOfWeek.thursday
        case 6:
            return DayOfWeek.friday
        case 7:
            return DayOfWeek.saturday
        default:
            return nil
        }
    }
}
