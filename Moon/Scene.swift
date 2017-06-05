//
//  Scene.swift
//  Moon
//
//  Created by Evan Noble on 6/1/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation

enum Scene {
    enum SignUp: SceneType {
        case name(NameViewModel)
        case birthdaySex(BirthdaySexViewModel)
        case emailUsername(EmailUsernameViewModel)
        case passwords(PasswordsViewModel)
    }
    
    enum Login: SceneType {
        case login(LoginViewModel)
        case forgotPassword(ForgotPasswordViewModel)
    }
    
    enum User: SceneType {
        case profile(ProfileViewModel)
    }
    
    enum Master: SceneType {
        case main((searchBar: SearchBarViewModel, mainView: MainViewModel))
    }
}
