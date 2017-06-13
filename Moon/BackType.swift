//
//  BackType.swift
//  Moon
//
//  Created by Evan Noble on 6/13/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import Action

protocol BackType {
    var sceneCoordinator: SceneCoordinatorType { get }
}

extension BackType {
    func onBack() -> CocoaAction {
        return CocoaAction {_ in 
            return self.sceneCoordinator.pop()
        }
    }
}
