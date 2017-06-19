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
    var enableEnterCode: Observable<Bool>
    
    var countryCode = Variable<CountryCode>(.US)
    
    init(coordinator: SceneCoordinatorType) {
        self.sceneCoordinator = coordinator
        
        let validPhoneNumber = Observable.combineLatest(phoneNumber, countryCode.asObservable())
            .map({
                SinchService.formatPhoneNumberForGuiFrom(string: $0, countryCode: $1)
            })
        
        enableEnterCode = validPhoneNumber.map({
            return ($0 == nil) ? false : true
        })
        
        phoneNumberString = validPhoneNumber.filter({ $0 != nil }).map({ $0! })
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
