//
//  EnterCodeViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/15/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import Action
import RxSwift
import RxCocoa

struct EnterCodeViewModel: BackType, PhoneNumberValidationInjected, NetworkingInjected, AuthNetworkingInjected {
    // Private
    private let phoneNumber: String
    
    // Dependencies
    let sceneCoordinator: SceneCoordinatorType
    
    // Inputs
    var code = BehaviorSubject<String>(value: "")
    
    // Actions
    
    // Outputs
    var enableCheckCodeButton: Observable<Bool>
    var codeText: Observable<String>
    
    init(coordinator: SceneCoordinatorType, phoneNumber: String) {
        self.sceneCoordinator = coordinator
        self.phoneNumber = phoneNumber
        
        let formattedText = code.map({ code -> String in
            if code.characters.count > 4 {
                return code.substring(to: code.index(code.startIndex, offsetBy: 4))
            } else {
                return code
            }
        })
        
        codeText = formattedText
        
        enableCheckCodeButton = formattedText.map({
            print($0)
            return $0.characters.count == 4
        })
    }
    
    func onCheckCode() -> CocoaAction {
        return CocoaAction {
            return self.checkCode().flatMap({
                return self.savePhoneNumber()
            }).flatMap({
                return self.onFinish()
            })
        }
    }
    
    private func checkCode() -> Observable<Void> {
        return Observable.just().withLatestFrom(code).flatMap({
            return self.phoneNumberService.verifyNumberWith(Code: $0)
        })
    }
    
    private func savePhoneNumber() -> Observable<Void> {
        return self.userAPI.add(phoneNumber: self.phoneNumber, for: self.authAPI.SignedInUserID)
    }
    
    private func onFinish() -> Observable<Void> {
        return self.sceneCoordinator.pop()
    }
}
