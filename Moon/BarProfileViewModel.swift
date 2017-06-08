//
//  BarProfileViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/8/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import Action
import RxSwift
import RxCocoa

struct BarProfileViewModel {
    
    private let sceneCoordinator: SceneCoordinatorType
    
    init(coordinator: SceneCoordinatorType) {
        self.sceneCoordinator = coordinator
    }
    
    func onBack() -> CocoaAction {
        return CocoaAction {_ in 
            return self.sceneCoordinator.pop()
        }
    }
}
