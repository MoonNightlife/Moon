//
//  AuthAPIType.swift
//  Moon
//
//  Created by Evan Noble on 7/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift

struct FacebookCredentials {
    let accessToken: String
}

struct EmailCredentials {
    let email: String
    let password: String
}

enum LoginCredentials {
    case facebook(credentials: FacebookCredentials)
    case email(credentials: EmailCredentials)
}

typealias UserID = String

enum AuthErrors: Error {
    case NoUserNameOrPassword
    case CreateAccountError
}

protocol AuthAPIType {
    
    var SignedInUserID: String { get }
    
    func login(credentials: LoginCredentials) -> Observable<UserID>
    func signOut() -> Observable<Void>
    func createAccount(newUser: NewUser) -> Observable<Void>
    func createProfile(newUser: NewUser) -> Observable<Void>
    
    func checkUsername(username: String) -> Observable<Bool>
    
    func resetPassword(email: String) -> Observable<Void>
    func deleteAccountForSignedInUser() -> Observable<Void>
    func changePasswordForSignedInUser(newPassword: String) -> Observable<Void>
    
    func checkForFirstTimeLogin(userId: String) -> Observable<Bool>
    
    func saveFCMToken(token: String) -> Observable<Void>
    func removeFCMToken(token: String) -> Observable<Void>
}
