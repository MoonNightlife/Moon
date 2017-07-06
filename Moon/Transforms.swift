//
//  Transforms.swift
//  Moon
//
//  Created by Evan Noble on 8/4/16.
//  Copyright © 2016 Evan Noble. All rights reserved.
//

import Foundation
import ObjectMapper

let dateFormatter = DateFormatter()

let DateTransfromDouble = TransformOf<NSDate, Double>(fromJSON: { (value: Double?) -> NSDate? in
    
    return NSDate(timeIntervalSince1970: value!)
    
    }, toJSON: { (value: NSDate?) -> Double? in
        // transform value from Int? to String?
        if let value = value {
            return  NSDate().timeIntervalSince1970
        }
        return nil
})

//let BarSpecialTransform = TransformOf<BarSpecial, String>(fromJSON: { (value: String?) -> BarSpecial? in
//
//        switch value! {
//            case "Beer": return BarSpecial.Beer
//            case "Wine": return BarSpecial.Wine
//            case "Spirits": return BarSpecial.Spirits
//            default: return nil
//        }
//
//    }, toJSON: { (value: BarSpecial?) -> String? in
//        // transform value from Int? to String?
//        if let value = value {
//            return value.rawValue
//        }
//        return nil
//})

//let DayTransform = TransformOf<Day, String>(fromJSON: { (value: String?) -> Day? in
//    
//        switch value! {
//            case "Monday": return Day.Monday
//            case "Tuesday": return Day.Tuesday
//            case "Wednesday": return Day.Wednesday
//            case "Thursday": return Day.Thursday
//            case "Friday": return Day.Friday
//            case "Saturday": return Day.Saturday
//            case "Sunday": return Day.Sunday
//            case "Weekdays": return Day.Weekdays
//            default: return nil
//        }
// 
//    
//    }, toJSON: { (value: Day?) -> String? in
//        // transform value from Int? to String?
//        if let value = value {
//            return value.rawValue
//        }
//        return nil
//})



let SexTransform = TransformOf<Sex, Int>(fromJSON: { (value: Int?) -> Sex? in
    
    switch value! {
        case 0 : return Sex.male
        case 1 : return Sex.female
        case 2 : return Sex.none
        default: return Sex.none
    }
    
    
    }, toJSON: { (value: Sex?) -> Int? in
        
        if let value = value {
            switch value {
            case .male : return 0
            case .female : return 1
            case .none : return 2
            }
        }
        return nil
})



