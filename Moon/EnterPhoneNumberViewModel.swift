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
import RxOptional

struct EnterPhoneNumberViewModel: BackType, PhoneNumberValidationInjected {
    // Global
    var validPhoneNumber: Observable<String?> {
        return Observable.combineLatest(phoneNumber, countryCode.asObservable())
            .map({
                self.phoneNumberService.formatPhoneNumberForGuiFrom(string: $0, countryCode: $1)
            })
    }
    // Dependencies
    let sceneCoordinator: SceneCoordinatorType
    
    // Inputs
    var phoneNumber = BehaviorSubject<String>(value: "")
    
    // Actions
    
    // Outputs
    var phoneNumberString: Observable<String> {
        return validPhoneNumber.filter({ $0 != nil }).map({ $0! })
    }
    var enableEnterCode: Observable<Bool> {
        return validPhoneNumber.map({
            return ($0 == nil) ? false : true
        })
    }
    
    var countryCode = Variable<CountryCode>(.US)
    
    init(coordinator: SceneCoordinatorType) {
        self.sceneCoordinator = coordinator
    
    }
    
    func onSendCode() -> CocoaAction {
        return CocoaAction {_ in 
            return self.sendCode().flatMap({
                return self.showEnterCodeScene()
            })
        }
    }
    
    private func sendCode() -> Observable<Void> {
        return Observable.just().withLatestFrom(phoneNumber).flatMap({
            return self.phoneNumberService.sendVerificationCodeTo(phoneNumber: $0, countryCode: self.countryCode.value.isoAlpha2)
        })
    }
    
    private func showEnterCodeScene() -> Observable<Void> {
        return Observable.just().withLatestFrom(phoneNumber)
            .map({
                return self.phoneNumberService.formatPhoneNumberForStorageFrom(string: $0, countryCode: self.countryCode.value)
            })
            .errorOnNil()
            .map({
                return EnterCodeViewModel(coordinator: self.sceneCoordinator, phoneNumber: $0)
            })
            .flatMap({
                return self.sceneCoordinator.transition(to: Scene.UserDiscovery.enterCode($0), type: .push)
            })
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
