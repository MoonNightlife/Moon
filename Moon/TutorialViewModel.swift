//
//  TutorialViewModel.swift
//  Moon
//
//  Created by Evan Noble on 7/18/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation

struct TutorialViewModel: BackType {
    
    // Dependencies
    var sceneCoordinator: SceneCoordinatorType
    
    // Outputs
    var tutorialViews: TutorialViewsType
    
    init(sceneCoordinator: SceneCoordinatorType, type: TutorialType) {
        self.sceneCoordinator = sceneCoordinator
        tutorialViews = type.views()
    }

}
