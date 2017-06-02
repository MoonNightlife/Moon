//
//  Scene.swift
//  Moon
//
//  Created by Evan Noble on 6/1/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation

enum Scene {
    case signUp(SignUpScene)
    case login(LoginScene)
}

enum SignUpScene {
    case name(NameViewModel)
    case birthdaySex(BirthdaySexViewModel)
    case emailUsername(EmailUsernameViewModel)
    case passwords(PasswordsViewModel)
}

enum LoginScene {
    case login(LoginViewModel)
}
