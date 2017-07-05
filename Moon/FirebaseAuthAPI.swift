//
//  FirebaseAuthAPI.swift
//  Moon
//
//  Created by Evan Noble on 7/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseAuth


struct FirebaseAuthAPI: AuthAPIType {
    func login(credentials: LoginCredentials) -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            
            switch credentials {
            case let .email(email, password):
                Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                    if user != nil {
                        observer.onCompleted()
                    } else if let e = error {
                        observer.onError(e)
                    } else {
                        observer.onError(MyError.SignUpError)
                    }
                })
            }

            return Disposables.create()
        })
    }
    
    func signOut() -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            do {
                try Auth.auth().signOut()
                observer.onCompleted()
            } catch let signOutError as NSError {
                print("Sign Out Error")
                observer.onError(signOutError)
            }
            
            return Disposables.create()
        })
    }
    
    func createAccount(newUser: NewUser) -> Observable<UserID> {
        return Observable.create({ (observer) -> Disposable in
            if let email = newUser.email, let password = newUser.password {
                Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                    if let id = user?.uid {
                        observer.onNext(id)
                    } else if let e = error {
                        observer.onError(e)
                    } else {
                        observer.onError(AuthErrors.CreateAccountError)
                    }
                })
            } else {
                observer.onError(AuthErrors.NoUserNameOrPassword)
            }
            return Disposables.create()
        })
    }
}

extension FirebaseAuthAPI {
    // Helper functions

}
