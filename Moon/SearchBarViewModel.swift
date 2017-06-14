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
    var searchText: BehaviorSubject<String?>!
    
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
    
    func onShowMainController() -> CocoaAction {
        return CocoaAction {
            let vm = MainViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.Master.main(vm), type: .searchRoot)
        }
    }
    
    func onShowSearch() -> CocoaAction {
        return CocoaAction {
            let vm = SearchViewModel(coordinator: self.sceneCoordinator)
            let searchResultsViewModel = SearchResultsViewModel(coordinator: self.sceneCoordinator)
            let suggestedContentViewModel = ContentSuggestionsViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.Master.search(searchViewModel: vm, searchResultsViewModel: searchResultsViewModel, contentSuggestionViewModel: suggestedContentViewModel), type: .searchRoot)
        }
    }
    
    func onShow(view: View.Search) -> CocoaAction {
        return CocoaAction {_ in 
            return self.sceneCoordinator.changeChild(To: view)
        }
    }
    
    func onPopProfile() -> CocoaAction {
        return CocoaAction {
            return self.sceneCoordinator.pop()
        }
    }

//    let searchInput = searchText
//        .filter { ($0 ?? "").characters.count > 0 }
//    
//    
//    let textSearch = searchInput.flatMap { text in
//        return ApiController.shared.currentWeather(city: text ?? "Error")
//            .do(onNext: { data in
//                if let text = text {
//                    self.cache[text] = data
//                }
//            }, onError: { [weak self] e in
//                guard let strongSelf = self else { return }
//                DispatchQueue.main.async {
//                    strongSelf.showError(error: e)
//                }
//            })
//            .retryWhen(retryHandler)
//            .catchError({ error in
//                if let text = text, let cachedData = self.cache[text] {
//                    return Observable.just(cachedData)
//                } else {
//                    return Observable.just(ApiController.Weather.empty)
//                }
//            })
//    }
}
