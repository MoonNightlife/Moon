//
//  AuthAPIType.swift
//  Moon
//
//  Created by Evan Noble on 7/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift

enum LoginCredentials {
    case email(email: String, password: String)
}

typealias UserID = String

enum AuthErrors: Error {
    case NoUserNameOrPassword
    case CreateAccountError
}

protocol AuthAPIType {
    func login(credentials: LoginCredentials) -> Observable<UserID>
    func signOut() -> Observable<Void>
    func createAccount(newUser: NewUser) -> Observable<Void>
}
