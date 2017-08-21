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
        case edit(EditProfileViewModel)
        case usersTable(UsersTableViewModel)
        case settings(SettingsViewModel)
        case email(EmailSettingsViewModel)
        case notification(NotificationSettingsViewModel)
        case deleteAccount(DeleteAccountViewModel)
        case webView(WebViewViewModel)
        case region(SelectRegionViewModel)
    }
    
    enum Master: SceneType {
        case searchBarWithMain((searchBar: SearchBarViewModel, mainView: MainViewModel))
        case main(MainViewModel)
        case search(searchViewModel: SearchViewModel, searchResultsViewModel: SearchResultsViewModel, contentSuggestionViewModel: ContentSuggestionsViewModel)
        case tutorial(TutorialViewModel)
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
        case info(BarInfoViewModel)
    }
    
    enum UserDiscovery: SceneType {
        case enterPhoneNumber(EnterPhoneNumberViewModel)
        case enterCode(EnterCodeViewModel)
        case countryCode(CountryCodeViewModel)
        case contacts(ContactsViewModel)
    }
    
    enum Group: SceneType {
        case relationship(RelationshipViewModel, UsersTableViewModel, ViewGroupsViewModel)
        case createGroup(CreateEditGroupViewModel)
        case editGroup(CreateEditGroupViewModel)
        case viewGroups(ViewGroupsViewModel)
        case groupActivity(GroupActivityViewModel)
        case manageGroup(ManageGroupViewModel)
    }
}
