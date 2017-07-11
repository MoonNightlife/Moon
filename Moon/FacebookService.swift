//
//  FacebookService.swift
//  Moon
//
//  Created by Evan Noble on 7/11/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import RxSwift
import Alamofire
import ObjectMapper

struct FacebookService: FacebookLoginProviderType {
    
    private let loginManager: FBSDKLoginManager!
    
    init() {
        self.loginManager = FBSDKLoginManager()
    }
    
    func login() -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            self.loginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: nil, handler: { (result, error) in
                if let e = error {
                    observer.onError(e)
                } else if let result = result, !result.isCancelled {
                    observer.onNext()
                }
                observer.onCompleted()
            })
            
            return Disposables.create()
        })
    }
    
    func logout() {
        loginManager.logOut()
    }
    
    func isUserAlreadyLoggedIn() -> Bool {
        if FBSDKAccessToken.current() == nil {
            return false
        }
        return true
    }
    
    func getProviderCredentials() -> LoginCredentials {
        return LoginCredentials.facebook(credentials: FacebookCredentials(accessToken: FBSDKAccessToken.current().tokenString))
    }
    
    func getBasicProfileForSignedInUser() -> Observable<FacebookUserInfo> {
        return Observable.create({ (observer) -> Disposable in
            
            if FBSDKAccessToken.current() != nil {
                FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "first_name, last_name, gender, picture.type(large), birthday, email"]).start(completionHandler: { (_, result, error) in
                    if let e = error {
                        observer.onError(e)
                    } else {
                        let userInfo = Mapper<FacebookUserInfo>().map(JSONObject: result)
                        if let userInfo = userInfo {
                            observer.onNext(userInfo)
                        } else {
                            observer.onError(APIError.noUserInfo)
                        }
                    }
                    observer.onCompleted()
                })
            } else {
                observer.onError(APIError.noSignedInUser)
            }
            
            return Disposables.create()
        })
    }
    
}
