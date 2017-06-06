//
//  MoonsViewViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import Action

struct MoonsViewViewModel {
    
    // Private
    private let disposeBag = DisposeBag()
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    
    // Inputs
    
    // Outputs
    
    init(coordinator: SceneCoordinatorType) {
        self.sceneCoordinator = coordinator
    }
    
    func createBarActivityFeedViewMode() -> BarActivityFeedViewModel {
        return BarActivityFeedViewModel(coordinator: sceneCoordinator)
    }
    
    func createCityOverviewViewMode() -> CityOverviewViewModel {
        return CityOverviewViewModel(coordinator: sceneCoordinator)
    }
}
