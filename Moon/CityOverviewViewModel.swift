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

struct CityOverviewViewModel: NetworkingInjected {
    
    // Private
    private let disposeBag = DisposeBag()
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    
    // Inputs
    
    // Outputs
    var bars: Observable<[TopBar]> {
        return barAPI.getTopBarsIn(region: "Dallas").map({
            return $0.map({ bar in
                return TopBar(from: bar)
            })
        })
    }
    
    init(coordinator: SceneCoordinatorType) {
        self.sceneCoordinator = coordinator
        
    }

}
