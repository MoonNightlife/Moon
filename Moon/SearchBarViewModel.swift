//
//  SearchBarViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import Action

struct SearchBarViewModel {
    
    // Private
    private let disposeBag = DisposeBag()
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    
    // Inputs
    
    // Outputs
    
    init(coordinator: SceneCoordinatorType) {
        self.sceneCoordinator = coordinator
    }
    
    func onShowProfile() -> CocoaAction {
        return CocoaAction {
            let vm = ProfileViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.User.profile(vm), type: .popover)
        }
    }
    
    func onShowSettings() -> CocoaAction {
        return CocoaAction {
            let vm = SettingsViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.User.settings(vm), type: .push)
        }
    }
    
    func onShowSearchResults() -> CocoaAction {
        return CocoaAction {
            let vm = ContentSuggestionsViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.Master.contentSuggestions(vm), type: .searchRoot)
        }
    }
    
    func onShowMainController() -> CocoaAction {
        return CocoaAction {
            let vm = MainViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.Master.main(vm), type: .searchRoot)
        }
    }
}
