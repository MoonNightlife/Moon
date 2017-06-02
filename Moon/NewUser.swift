//
//  NewUser.swift
//  Moon
//
//  Created by Evan Noble on 5/31/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation

class NewUser {
    var firstName: String?
    var lastName: String?
    var birthday: String?
    var sex: String?
    var password: String?
    var email: String?
    var username: String?
    
    func listPropertiesWithValues(reflect: Mirror? = nil) {
        let mirror = reflect ?? Mirror(reflecting: self)
        if mirror.superclassMirror != nil {
            self.listPropertiesWithValues(reflect: mirror.superclassMirror)
        }
        
        for (index, attr) in mirror.children.enumerated() {
            if let property_name = attr.label as String! {
                //You can represent the results however you want here!!!
                print("\(mirror.description) \(index): \(property_name) = \(attr.value)")
            }
        }
    }
}
