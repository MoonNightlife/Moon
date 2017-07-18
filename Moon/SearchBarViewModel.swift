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
import FirebaseAuth

struct SearchBarViewModel: NetworkingInjected, AuthNetworkingInjected {
    
    // Private
    private let disposeBag = DisposeBag()
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    
    // Inputs
    var searchText = BehaviorSubject<String>(value: "")
    
    // Outputs
    lazy var numberOfFriendRequest: Action<Void, String?> = { this in
        return Action(workFactory: {
            return this.userAPI.getFriendRequest(userID: this.authAPI.SignedInUserID)
                .map({
                    return $0.isEmpty ? nil : "\($0.count)"
                })
        })
    }(self)
    
    init(coordinator: SceneCoordinatorType) {
        self.sceneCoordinator = coordinator
    }
    
    func onShowProfile() -> CocoaAction {
        return CocoaAction {
            let vm = ProfileViewModel(coordinator: self.sceneCoordinator, userID: self.authAPI.SignedInUserID)
            return self.sceneCoordinator.transition(to: Scene.User.profile(vm), type: .popover)
        }
    }
    
    func onShowSettings() -> CocoaAction {
        return CocoaAction {
            let vm = SettingsViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.User.settings(vm), type: .push)
        }
    }
    
    func onShowMainController() -> CocoaAction {
        return CocoaAction {
            let vm = MainViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.Master.main(vm), type: .searchRoot)
        }
    }
    
    func onShowSearch() -> CocoaAction {
        return CocoaAction {
            let vm = SearchViewModel(coordinator: self.sceneCoordinator)
            let searchResultsViewModel = SearchResultsViewModel(coordinator: self.sceneCoordinator, searchText: self.searchText)
            let suggestedContentViewModel = ContentSuggestionsViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.Master.search(searchViewModel: vm, searchResultsViewModel: searchResultsViewModel, contentSuggestionViewModel: suggestedContentViewModel), type: .searchRoot)
        }
    }
    
    func onShow(view: View.Search) -> CocoaAction {
        return CocoaAction {_ in 
            return self.sceneCoordinator.changeChild(To: view)
        }
    }
    
    func onPopPopover() -> CocoaAction {
        return CocoaAction {
            return self.sceneCoordinator.pop()
        }
    }
    
    func onShowTutorial() -> CocoaAction {
        return CocoaAction { _ in
            let vm = TutorialViewModel(sceneCoordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.Master.tutorial(vm), type: .popover)
        }
    }
}
