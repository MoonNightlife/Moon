//
//  EmailUsernameViewModel.swift
//  Moon
//
//  Created by Evan Noble on 5/31/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import Action
import RxCocoa
import FirebaseMessaging

enum SignUpError: Error {
    case usernameTaken(message: String)
}

struct EmailUsernameViewModel: AuthNetworkingInjected, StorageNetworkingInjected {
    
    // Dependencies
    private let newUser: NewUser
    private let sceneCoordinator: SceneCoordinatorType
    private let disposeBag = DisposeBag()
    
    // Inputs
    var username = PublishSubject<String?>()
    var email = PublishSubject<String?>()
    
    // Outputs
    var emailText: Observable<String?>!
    
    var showEmailError: Driver<Bool> {
        let validEmail = email.map(ValidationUtility.validEmail)
        return Observable.combineLatest(email, validEmail)
            .map({ (email, validEmail) in
                guard let e = email else {
                    return false
                }
                
                // return true if string is not blank and email is not valid
                return (e != "") && !validEmail
            }).asDriver(onErrorJustReturn: false)
    }
    
    var showUsernameError: Observable<Bool> {
        let validUsername = username.map(ValidationUtility.validUsername)
        return Observable.combineLatest(username, validUsername)
            .map({ (username, validUsername) in
                guard let un = username else {
                    return false
                }
                
                // return true if string is not blank and username is not valid
                return (un != "") && !validUsername
            })
    }
    
    var allFieldsValid: Observable<Bool> {

        return Observable.combineLatest(username.map(ValidationUtility.validUsername), emailText.map(ValidationUtility.validEmail)).map({$0 && $1})
    }
    
    init(coordinator: SceneCoordinatorType, user: NewUser) {
        self.sceneCoordinator = coordinator
        self.newUser = user
        subscribeToInputs()
        
        emailText = email
            .do(onNext: {
                user.email = $0?.trimmed
            })
            .startWith(user.email)
    }
    
    private func subscribeToInputs() {
        username
            .subscribe(onNext: {
                self.newUser.username = $0
            })
            .addDisposableTo(disposeBag)
    }
    
    func nextScreen() -> CocoaAction {
        return CocoaAction(enabledIf: allFieldsValid, workFactory: {_ in
            return self.authAPI.checkUsername(username: self.newUser.username!)
                .flatMap({ isTaken -> Observable<Void> in
                    if isTaken {
                        return Observable.error(SignUpError.usernameTaken(message: "This username is already taken. Please choose a different one."))
                    } else {
                        switch self.newUser.type! {
                        case .firebase: return self.nextSignUpScreen()
                        case .facebook: return self.createProfile()
                        }
                        
                    }
                })
            
        })

    }
    
    func nextSignUpScreen() -> Observable<Void> {
        let viewModel = PasswordsViewModel(coordinator: self.sceneCoordinator, user: self.newUser)
        return self.sceneCoordinator.transition(to: Scene.SignUp.passwords(viewModel), type: .push)
    }
    
    func createProfile() -> Observable<Void> {
        return self.authAPI.createProfile(newUser: self.newUser)
            .flatMap({ _ -> Observable<Void> in
                if let photoData = self.newUser.image {
                    return self.storageAPI.uploadProfilePictureFrom(data: photoData, forUser: self.authAPI.SignedInUserID, imageName: "pic1.jpg")
                } else {
                    return Observable.just()
                }
            }).flatMap({ _ -> Observable<Void> in
                if let token = Messaging.messaging().fcmToken {
                    return self.authAPI.saveFCMToken(token: token)
                } else {
                    return Observable.just()
                }
            })
            .flatMap({
                return self.showEnterPhoneNumber()
            })
    }
    
    func onBack() -> CocoaAction {
        return CocoaAction {
            self.sceneCoordinator.pop()
        }
    }
    
    func showEnterPhoneNumber() -> Observable<Void> {
        let vm = EnterPhoneNumberViewModel(coordinator: self.sceneCoordinator, partOfSignupFlow: true)
        return self.sceneCoordinator.transition(to: Scene.UserDiscovery.enterPhoneNumber(vm), type: .modal)
    }

}
