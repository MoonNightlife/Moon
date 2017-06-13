//
//  FeaturedViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import Action

struct FeaturedViewModel {
    
    // Private
    private let disposeBag = DisposeBag()
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    
    // Inputs
    lazy var onLikeEvent: Action<String, Void> = { this in
        return Action<String, Void> {_ in
            print("Like Event")
            return Observable.empty()
        }
    }(self)
    
    lazy var onShareEvent: Action<String, Void> = { this in
        return Action<String, Void> {_ in
            print("Share Event")
            return Observable.empty()
        }
    }(self)
    
    // Outputs
    
    init(coordinator: SceneCoordinatorType) {
        self.sceneCoordinator = coordinator
    }
}
