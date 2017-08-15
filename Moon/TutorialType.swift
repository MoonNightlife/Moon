//
//  TutorialType.swift
//  Moon
//
//  Created by Evan Noble on 8/10/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import UIKit

enum TutorialType {
    case intro, group
    
    func views() -> TutorialViewsType {
        switch self {
        case .intro: return IntroViews()
        case .group: return GroupViews()
        }
    }
}

protocol TutorialViewsType {
    var images: [UIImage] { get }
    var count: Int { get }
}

struct GroupViews: TutorialViewsType {
    var images: [UIImage]
    var count: Int
    
    init() {
        images = [#imageLiteral(resourceName: "GroupsTutorial2")]
        count = images.count
    }
}

struct IntroViews: TutorialViewsType {
    var images: [UIImage]
    var count: Int
    
    init() {
        images = [#imageLiteral(resourceName: "SearchTutorial"), #imageLiteral(resourceName: "FeaturedEventsTutorial"), #imageLiteral(resourceName: "MoonsViewTutorial"), #imageLiteral(resourceName: "ExploreTutorial")]
        count = images.count
    }
}
