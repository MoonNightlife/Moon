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

    struct AuthFunction {
        private static let authBaseURL = "https://us-central1-moondev-ac048.cloudfunctions.net/"
        
        // Create account will create the firebase user and upload the profile information
        static let createAccount = authBaseURL + "createNewUser"
        // Create profile adds the profile informatin to a firebase account
        // This is used when a user authenticates with facebook and still to upload a profile
        static let createProfile = authBaseURL + "createProfile"
        
        static let checkUsername = authBaseURL + "checkUsername"
        static let deleteAccount = authBaseURL + "deleteAccount"
        static let checkFirstTimeLogin = authBaseURL + "checkFirstTimeLogin"
        
        static let saveFCMToken = authBaseURL + "saveFCMDeviceToken"
        static let removeFCMToken = authBaseURL + "removeFCMDeviceToken"
    }
    
    func login(credentials: LoginCredentials) -> Observable<UserID> {
        return Observable.create({ (observer) -> Disposable in
            
            switch credentials {
            case let .email(credential):
                Auth.auth().signIn(withEmail: credential.email, password: credential.password, completion: { (user, error) in
                    if let id = user?.uid {
                        observer.onNext(id)
                        observer.onCompleted()
                    } else if let e = error {
                        observer.onError(e)
                    } else {
                        observer.onError(MyError.SignUpError)
                    }
                })
            case let .facebook(credentials):
                let facebookCredentials = FacebookAuthProvider.credential(withAccessToken: credentials.accessToken)
                Auth.auth().signIn(with: facebookCredentials, completion: { (user, error) in
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
                            observer.onError(APIError.jsonCastingFailure)
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
    
    func resetPassword(email: String) -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext()
                }
                observer.onCompleted()
            }
            
            return Disposables.create()
        })
    }
    
    func updateEmail(email: String) -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            if let user = Auth.auth().currentUser {
                user.updateEmail(to: email, completion: { (error) in
                    if let error = error {
                        observer.onError(error)
                    } else {
                        observer.onNext()
                    }
                    observer.onCompleted()
                })
            } else {
                observer.onError(APIError.noSignedInUser)
            }
            
            return Disposables.create()
        })
    }
    
    func deleteAccountForSignedInUser() -> Observable<Void> {
        return Observable.create({(observer) -> Disposable in
            let body: Parameters = [
                "id": self.SignedInUserID
            ]
            let request = Alamofire.request(AuthFunction.deleteAccount, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
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
    
    func changePasswordForSignedInUser(newPassword: String) -> Observable<Void> {
        return Observable.empty()
    }
    
    func checkForFirstTimeLogin(userId: String) -> Observable<Bool> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "id": userId
            ]
            let request = Alamofire.request(AuthFunction.checkFirstTimeLogin, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success(let value):
                        if let firstTime = value as? Bool {
                            observer.onNext(firstTime)
                            observer.onCompleted()
                            
                        } else {
                            observer.onError(APIError.jsonCastingFailure)
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
    
    func createProfile(newUser: NewUser) -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            var body: Parameters = newUser.toJSON()
            body["id"] = self.SignedInUserID
            let request = Alamofire.request(AuthFunction.createProfile, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
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
    
    func saveFCMToken(token: String) -> Observable<Void> {
        return Observable.create({(observer) -> Disposable in
            let body: Parameters = [
                "id": self.SignedInUserID,
                "token": token
            ]
            let request = Alamofire.request(AuthFunction.saveFCMToken, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
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
    
    func removeFCMToken(token: String) -> Observable<Void> {
        return Observable.create({(observer) -> Disposable in
            let body: Parameters = [
                "id": self.SignedInUserID,
                "token": token
            ]
            let request = Alamofire.request(AuthFunction.removeFCMToken, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
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

}
