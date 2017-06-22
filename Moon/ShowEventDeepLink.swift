//
//  ShowEventDeepLink.swift
//  Moon
//
//  Created by Evan Noble on 6/21/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
/// Represents presenting an image to the user.
/// Example - moonnightlife://show/event?barID=123?eventID=234
struct ShowEventDeepLink: DeepLink {
    
    static let template = DeepLinkTemplate()
        .term("show")
        .term("event")
        .queryStringParameters([
            .requiredString(named: "barID"),
            .requiredString(named: "eventID")
            ])
    
    init(values: DeepLinkValues) {
        //swiftlint:disable force_cast
        barID = values.query["barID"] as! String
        eventID = values.query["eventID"] as! String
    }
    
    let barID: String
    let eventID: String
    
}
