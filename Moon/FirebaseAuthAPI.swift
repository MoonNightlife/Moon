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
import Alamofire

struct FirebaseAuthAPI: AuthAPIType {
    
    var SignedInUserID: String {
        return (Auth.auth().currentUser?.uid)!
    }
    
    var SignedInUserEmail: String {
        return (Auth.auth().currentUser?.email)!
    }
    struct AuthFunction {
        private static let authBaseURL = "https://us-central1-moon-4409e.cloudfunctions.net/"
        
        static let createAccount = authBaseURL + "createNewUser"
        static let checkUsername = authBaseURL + "checkUsername"
    }
    
    func login(credentials: LoginCredentials) -> Observable<UserID> {
        return Observable.create({ (observer) -> Disposable in
            
            switch credentials {
            case let .email(email, password):
                Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                    if let id = user?.uid {
                        observer.onNext(id)
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
                observer.onNext()
                observer.onCompleted()
            } catch let signOutError as NSError {
                print("Sign Out Error")
                observer.onError(signOutError)
            }
            
            return Disposables.create()
        })
    }
    
    func createAccount(newUser: NewUser) -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = newUser.toJSON()
            let request = Alamofire.request(AuthFunction.createAccount, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .response(completionHandler: {
                    if let e = $0.error {
                        observer.onError(e)
                    } else {
                        observer.onNext()
                        observer.onCompleted()
                    }
                })
            
            return Disposables.create {
                request.cancel()
            }
        })
    }
    
    func checkUsername(username: String) -> Observable<Bool> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "username": username
            ]
            let request = Alamofire.request(AuthFunction.checkUsername, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success(let value):
                        if let isTaken = value as? Bool {
                            observer.onNext(isTaken)
                            observer.onCompleted()
                            
                        } else {
                            observer.onError(UserAPIError.jsonCastingFailure)
                        }
                    case .failure(let error):
                        observer.onError(error)
                    }
                })
            
            return Disposables.create {
                request.cancel()
            }
        })
    }

}
