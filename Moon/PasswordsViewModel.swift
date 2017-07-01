//
//  PasswordsViewModel.swift
//  Moon
//
//  Created by Evan Noble on 5/31/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import Action
import FirebaseAuth
import FirebaseStorage

struct PasswordsViewModel: NetworkingInjected {
    
    // Dependencies
    private let newUser: NewUser
    private let sceneCoordinator: SceneCoordinatorType
    private let disposeBag = DisposeBag()
    
    // Inputs
    var passwordText = BehaviorSubject<String>(value: "")
    var retypePasswordText = BehaviorSubject<String>(value: "")
    
    // Outputs
    var showPasswordsMatchError: Observable<Bool> {
        let passwordsMatch = Observable.combineLatest(passwordText, retypePasswordText).map(==)
        return Observable.combineLatest(passwordsMatch, retypePasswordText).map({
            return !$0 && $1 != ""
        })
    }
    var showAcceptablePasswordError: Observable<Bool> {
        let validPassword = passwordText.map(ValidationUtility.validPassword)
        return Observable.combineLatest(validPassword, passwordText).map({
            return !$0 && $1 != ""
        })
    }
    var allValid: Observable<Bool> {
        return Observable.combineLatest(passwordText, retypePasswordText)
            .map({ (password1, password2) in
                return ValidationUtility.validPassword(password: password1) && password1 == password2
            })
    }
    
    func createUser() -> CocoaAction {
        return CocoaAction(enabledIf: self.allValid, workFactory: {_ in
            return Observable.create({ (observer) -> Disposable in
                if let email = self.newUser.email, let password = self.newUser.password {
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        if user != nil {
                            self.newUser.id = user?.uid
                            observer.onNext()
                        } else if let e = error {
                            observer.onError(e)
                        } else {
                            observer.onError(MyError.SignUpError)
                        }
                    })
                } else {
                    observer.onError(MyError.SignUpError)
                }
                return Disposables.create()
            }).flatMap({
                return self.uploadImage()
            }).flatMap({
                return self.createUserNode()
            }).flatMap({
                return self.loginAction()
            })
        })
    }
    
    func uploadImage() -> Observable<Void> {
            return Observable.create({ (observer) -> Disposable in
                print(self.newUser.listPropertiesWithValues())
                if let uid = Auth.auth().currentUser?.uid, let imageData = self.newUser.image {
                    let ref = Storage.storage().reference().child(uid).child("profilePictures").child("fullSize")
                    ref.putData(imageData, metadata: nil, completion: { (metadata, error) in
                        if let downloadURLString = metadata?.downloadURLs?.first?.path {
                            self.newUser.downloadURL = downloadURLString
                            observer.onNext()
                        } else {
                            print("Failed to upload photo")
                            print(error ?? MyError.SignUpError)
                        }
                        observer.onCompleted()
                    })
                } else {
                    observer.onNext()
                    observer.onCompleted()
                }
                return Disposables.create()
            })
    }
    
    func createUserNode() -> Observable<Void> {
        return self.userAPI.createProfile(profile: self.newUser)
    }
    
    func loginAction() -> Observable<Void> {
        let mainVM = MainViewModel(coordinator: self.sceneCoordinator)
        let searchVM = SearchBarViewModel(coordinator: self.sceneCoordinator)
        return self.sceneCoordinator.transition(to: Scene.Master.searchBarWithMain(searchBar: searchVM, mainView: mainVM), type: .root)
    }
    
    init(coordinator: SceneCoordinatorType, user: NewUser) {
        self.sceneCoordinator = coordinator
        self.newUser = user
        subscribeToInputs()
    }
    
    private func subscribeToInputs() {
        passwordText
            .subscribe(onNext: {
                self.newUser.password = $0
            })
            .addDisposableTo(disposeBag)
    }
    
    func onBack() -> CocoaAction {
        return CocoaAction {
            self.sceneCoordinator.pop()
        }
    }
}
