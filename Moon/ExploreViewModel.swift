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

struct ExploreViewModel: ImageDownloadType {
    
    // Local
    private let disposeBag = DisposeBag()
    var photoService: PhotoService
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    
    // Inputs
    
    // Outputs
    var topBars: Action<Void, [TopBar]>
    
    init(coordinator: SceneCoordinatorType, barAPI: BarAPIType = BarAPIController(), photoService: PhotoService = KingFisherPhotoService()) {
        self.sceneCoordinator = coordinator
        self.photoService = photoService
        
        topBars = Action(workFactory: {_ in 
            return barAPI.getTopBarsIn(region: "Dallas").map({
                return $0.map({ bar in
                    return TopBar(from: bar)
                })
            })
        })
    }
    
    func createSpecialViewModel(type: AlcoholType) -> SpecialsViewModel {
        return SpecialsViewModel(coordinator: sceneCoordinator, type: type)
    }
    
    func showBar(barID: String) -> CocoaAction {
        return CocoaAction {
            let vm = BarProfileViewModel(coordinator: self.sceneCoordinator, barID: barID)
            return self.sceneCoordinator.transition(to: Scene.Bar.profile(vm), type: .modal)
        }
    }
}
