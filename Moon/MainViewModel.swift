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
    private let sceneCoordinator: SceneCoordinatorType
    
    // Inputs
    
    // Outputs
    
    init(coordinator: SceneCoordinatorType) {
        self.sceneCoordinator = coordinator
    }
    
    func onChangeView() -> Action<MainView, Void> {
        return Action(workFactory: {
//            var scene: SceneType
//            switch $0 {
//            case .explore:
//                let vm = ExploreViewModel(coordinator: self.sceneCoordinator)
//                scene = Scene.Explore.explore(vm)
//            case .featured:
//                let vm = FeaturedViewModel(coordinator: self.sceneCoordinator)
//                scene = Scene.Featured.featured(vm)
//            case .moons:
//                let vm = MoonsViewViewModel(coordinator: self.sceneCoordinator)
//                scene = Scene.MoonsView.moonsView(vm)
//            }
            return self.sceneCoordinator.tab(to: $0)
        })
    }
}
