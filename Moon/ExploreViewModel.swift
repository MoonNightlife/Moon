//
//  ExploreViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import Action

struct ExploreViewModel {
    
    // Private
    private let disposeBag = DisposeBag()
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    
    // Inputs
    
    // Outputs
    var topBars: Action<Void, [TopBar]>
    
    init(coordinator: SceneCoordinatorType, barAPI: BarAPIType = BarAPIController()) {
        self.sceneCoordinator = coordinator
        
        topBars = Action(workFactory: {_ in 
            return barAPI.getTopBarsIn(region: "dallas").map({
                return $0.map({ bar in
                    return TopBar(imageName: bar.barPics?.first ?? "pic1.jpg", barName: bar.name ?? "No Name", usersGoing: "\(bar.numPeopleAttending ?? 0)", coordinates: nil)
                })
            })
        })
    }
    
    func createSpecialViewModel() -> SpecialsViewModel {
        return SpecialsViewModel(coordinator: sceneCoordinator)
    }
}
