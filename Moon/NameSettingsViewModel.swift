//
//  NameSettingsViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/8/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action

struct NameSettingsViewModel {
    
    typealias Name = (first: String, last: String)
    private let dataValid: Driver<Bool>
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    
    // Inputs
    var firstNameText = BehaviorSubject<String?>(value: nil)
    var lastNameText = BehaviorSubject<String?>(value: nil)
    
    // Outputs
    var firstName: Observable<String>!
    var lastName: Observable<String>!
    
    init(coordinator: SceneCoordinatorType) {
        sceneCoordinator = coordinator
        
        dataValid = Observable.combineLatest(firstNameText, lastNameText).map(ValidationUtility.validName).asDriver(onErrorJustReturn: false)
        
    }
    
    func onBack() -> CocoaAction {
        return CocoaAction {
            return self.sceneCoordinator.pop()
        }
    }
    
    func onSave() -> CocoaAction {
        return CocoaAction(enabledIf: dataValid.asObservable(), workFactory: {
            return Observable.empty()
        })
    }
}
