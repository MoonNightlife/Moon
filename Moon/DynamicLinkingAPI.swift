//
//  DynamicLinkingAPI.swift
//  Moon
//
//  Created by Evan Noble on 6/23/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import FirebaseDynamicLinks

struct DynamicLinkingAPI {
    
    static let DYNAMIC_LINK_DOMAIN = "wjtk3.app.goo.gl"
    
    static func createDynamicLink() {
    
        guard let link = URL(string: "http:/moonnightlife/show/event?barID=123?eventID=234") else { return }
        let components = DynamicLinkComponents(link: link, domain: DynamicLinkingAPI.DYNAMIC_LINK_DOMAIN)
        
        let iOSParams = DynamicLinkIOSParameters(bundleID: "com.NobleLeyva.Moon")
        iOSParams.fallbackURL = URL(string: "http://www.moonnightlifeapp.com")
        iOSParams.minimumAppVersion = "2.0"
        iOSParams.appStoreID = "1133350095"
        
        components.iOSParameters = iOSParams
        
        let socialParams = DynamicLinkSocialMetaTagParameters()
        socialParams.title = "New Event"
        socialParams.descriptionText = "Check out this new event"
        socialParams.imageURL = URL(string: "https://dummyimage.com/200x200/000/fff")
        
        components.socialMetaTagParameters = socialParams

        print(components)
        let longLink = components.url
        print(longLink?.absoluteString ?? "")
        
        components.shorten { (shortURL, warnings, error) in
            // Handle shortURL.
            if let error = error {
                print(error.localizedDescription)
                return
            }
            let shortLink = shortURL
            print(shortLink?.absoluteString ?? "")
            // ...
        }
    }
}
