//
//  MainViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import Action

struct MainViewModel {
    
    // Private
    private let disposeBag = DisposeBag()
    
    // Dependencies
    let sceneCoordinator: SceneCoordinatorType
    
    // Inputs
    
    // Outputs
    
    init(coordinator: SceneCoordinatorType) {
        self.sceneCoordinator = coordinator
    }
    
    func onChangeView() -> Action<MainView, Void> {
        return Action(workFactory: {
            return self.sceneCoordinator.tab(to: $0)
        })
    }
    
    func viewModelForExplore() -> ExploreViewModel {
        return ExploreViewModel(coordinator: sceneCoordinator)
    }
    
    func viewModelForFeatured() -> FeaturedViewModel {
        return FeaturedViewModel(coordinator: sceneCoordinator)
    }
    
    func viewModelForMoonsView() -> MoonsViewViewModel {
        return MoonsViewViewModel(coordinator: sceneCoordinator)
    }
}
