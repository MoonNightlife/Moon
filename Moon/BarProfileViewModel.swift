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
    
    func onShowInfo() -> CocoaAction {
        return CocoaAction {
            let vm = BarInfoViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.Bar.info(vm), type: .popover)
        }
    }
    
    func onAttendBar() -> CocoaAction {
        return CocoaAction {
            print("Show attend bar")
            return Observable.empty()
        }
    }
}
