//
//  SceneTransitionType.swift
//  Moon
//
//  Created by Evan Noble on 6/1/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation

enum SceneTransitionType {
    // you can extend this to add animated transition types,
    // interactive transitions and even child view controllers!
    
    case root                       // make view controller the root view controller
    case push                       // push view controller to navigation stack
    case modal                      // present view controller modally
    case popover
}
