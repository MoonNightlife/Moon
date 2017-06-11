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
        case settings(SettingsViewModel)
        case name(NameSettingsViewModel)
        case email(EmailSettingsViewModel)
        case notification(NotificationSettingsViewModel)
        case deleteAccount(DeleteAccountViewModel)
        case webView(WebViewViewModel)
    }
    
    enum Master: SceneType {
        case searchBarWithMain((searchBar: SearchBarViewModel, mainView: MainViewModel))
        case contentSuggestions(ContentSuggestionsViewModel)
        case main(MainViewModel)
        case searchResults(SearchResultsViewModel)
        case search(SearchViewModel)
    }
    
    enum Explore: SceneType {
        case explore(ExploreViewModel)
    }
    
    enum MoonsView: SceneType {
        case moonsView(MoonsViewViewModel)
    }
    
    enum Featured: SceneType {
        case featured(FeaturedViewModel)
    }
    
    enum  Bar: SceneType {
        case profile(BarProfileViewModel)
    }
}
