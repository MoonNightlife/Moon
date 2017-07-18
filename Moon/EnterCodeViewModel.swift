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
    private let partOfSignupFlow: Bool
    
    // Dependencies
    let sceneCoordinator: SceneCoordinatorType
    
    // Inputs
    var code = BehaviorSubject<String>(value: "")
    
    // Actions
    
    // Outputs
    var enableCheckCodeButton: Observable<Bool>
    var codeText: Observable<String>
    
    init(coordinator: SceneCoordinatorType, phoneNumber: String, partOfSignupFlow: Bool) {
        self.sceneCoordinator = coordinator
        self.phoneNumber = phoneNumber
        self.partOfSignupFlow = partOfSignupFlow
        
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
        return CocoaAction {_ in 
            return self.checkCode().flatMap({
                return self.savePhoneNumber()
            }).flatMap({ _ -> Observable<Void> in
                if self.partOfSignupFlow {
                    return self.showMainView()
                } else {
                    return self.sceneCoordinator.pop()
                }
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
    
    func onBack() -> CocoaAction {
        return CocoaAction {
            if self.partOfSignupFlow {
                return self.showMainView()
            } else {
                return self.sceneCoordinator.pop()
            }
        }
    }
    
    func showMainView() -> Observable<Void> {
        let mainVM = MainViewModel(coordinator: self.sceneCoordinator)
        let searchVM = SearchBarViewModel(coordinator: self.sceneCoordinator)
        return self.sceneCoordinator.transition(to: Scene.Master.searchBarWithMain(searchBar: searchVM, mainView: mainVM), type: .root)
    }
}
