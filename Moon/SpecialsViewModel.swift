//
//  SpecialsViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import Action
import RxDataSources

typealias SpecialSection = AnimatableSectionModel<String, Special>

struct SpecialsViewModel {
    
    // Private
    private let disposeBag = DisposeBag()
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    
    // Inputs
    
    // Outputs
    var specials: Observable<[SpecialSection]>
    
    init(coordinator: SceneCoordinatorType) {
        self.sceneCoordinator = coordinator
        
        specials = Observable.just([SpecialSection(model: "", items: fakeSpecials)])
    }
    
    func onLike() -> CocoaAction {
        return CocoaAction {
            print("Liked Special")
            return Observable.empty()
        }
    }
}
