//
//  EditProfileViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/18/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import Action
import RxSwift

struct EditProfileViewModel: BackType {
    
    // Dependencies
    var sceneCoordinator: SceneCoordinatorType
    
    // Output
    
    // Input
    
    init(coordinator: SceneCoordinatorType) {
        sceneCoordinator = coordinator
    }
    
    func onSave() -> CocoaAction {
        return CocoaAction {
            print("Save User")
            return Observable.empty()
        }
    }
}
