//
//  NameViewModel.swift
//  Moon
//
//  Created by Evan Noble on 5/31/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import Action
import RxCocoa

struct NameViewModel: ImageNetworkingInjected {
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    private let newUser: NewUser
    
    // Private
    private let disposeBag = DisposeBag()
    
    // Inputs
    var firstName = PublishSubject<String?>()
    var lastName = PublishSubject<String?>()
    var selectedImage = Variable<UIImage?>(nil)
    
    // Outputs
    var dataValid: Driver<Bool>!
    var firstNameText: Observable<String?>!
    var lastNameText: Observable<String?>!
    var image = Variable<UIImage>(#imageLiteral(resourceName: "DefaultProfilePic"))
    
    init(coordinator: SceneCoordinatorType, user: NewUser) {
        self.sceneCoordinator = coordinator
        self.newUser = user
        
        if let url = user.profileURL {
            self.photoService.getImageFor(url: url).bind(to: image).addDisposableTo(disposeBag)
    
            image.asObservable()
                .skip(1)
                .map({
                    UIImageJPEGRepresentation($0, 1.0)
                })
                .do(onNext: {
                    user.image = $0
                })
                .subscribe()
                .addDisposableTo(disposeBag)
        }
        
        firstNameText = firstName
            .do(onNext: {
                user.firstName = $0?.trimmed
            })
            .startWith(user.firstName)
        
        lastNameText = lastName
            .do(onNext: {
                user.lastName = $0?.trimmed
            })
            .startWith(user.lastName)
        
        dataValid = Observable.combineLatest(firstName, lastName).map(ValidationUtility.validName).asDriver(onErrorJustReturn: false)
        
        subscribeToInputs()
    }
    
    private func subscribeToInputs() {
        
        selectedImage.asObservable()
            .filterNil()
            .map({
                UIImageJPEGRepresentation($0, 1.0)
            })
            .do(onNext: {
                self.newUser.image = $0
            })
            .subscribe()
            .addDisposableTo(disposeBag)
    }

    func nextSignUpScreen() -> CocoaAction {
        return CocoaAction(workFactory: {
            let viewModel = BirthdaySexViewModel(coordinator: self.sceneCoordinator, user: self.newUser)
            return self.sceneCoordinator.transition(to: Scene.SignUp.birthdaySex(viewModel), type: .push)
        })
    }
    
    func onBack() -> CocoaAction {
        return CocoaAction {
            self.sceneCoordinator.pop()
        }
    }
}
