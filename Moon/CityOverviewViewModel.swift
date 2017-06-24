//
//  CityOverviewViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import Action

struct CityOverviewViewModel {
    
    // Private
    private let disposeBag = DisposeBag()
    private let barAPI: BarAPIType
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    
    // Inputs
    
    // Outputs
    let bars: Observable<[TopBar]>
    
    init(coordinator: SceneCoordinatorType, barAPI: BarAPIType = BarAPIController()) {
        self.sceneCoordinator = coordinator
        self.barAPI = barAPI
        
        bars = barAPI.getTopBarsIn(region: "Dallas").map({
            return $0.map({ bar in
                return TopBar(from: bar)
            })
        })
    }
    
    
}
