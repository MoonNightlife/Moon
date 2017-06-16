//
//  EnterPhoneNumberViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/15/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import Action
import RxSwift

struct EnterPhoneNumberViewModel: BackType {
    // Private
    
    // Dependencies
    let sceneCoordinator: SceneCoordinatorType
    
    // Inputs
    var phoneNumber = BehaviorSubject<String>(value: "")
    
    // Actions
    
    // Outputs
    var phoneNumberString: Observable<String>
    
    var countryCode = Variable<CountryCode>(.US)
    
    init(coordinator: SceneCoordinatorType) {
        self.sceneCoordinator = coordinator
        
        phoneNumberString = phoneNumber
    }
    
    func onShowEnterCode() -> CocoaAction {
        return CocoaAction {
            let vm = EnterCodeViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.UserDiscovery.enterCode(vm), type: .push)
        }
    }
    
    func onChangeCountryCode() -> Action<CountryCode, Void> {
        return Action(workFactory: {
            self.countryCode.value = $0
            return Observable.empty()
        })
    }
    
    func editCountryCode() -> CocoaAction {
        return CocoaAction {
            let vm = CountryCodeViewModel(coordinator: self.sceneCoordinator, updateCountryCode: self.onChangeCountryCode())
            return self.sceneCoordinator.transition(to: Scene.UserDiscovery.countryCode(vm), type: .modal)
        }
    }

}
