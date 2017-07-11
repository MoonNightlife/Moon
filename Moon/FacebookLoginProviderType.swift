//
//  FacebookLoginProviderType.swift
//  Moon
//
//  Created by Evan Noble on 7/11/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift

protocol FacebookLoginProviderType {
    func login() -> Observable<Void>
    func logout()
    func isUserAlreadyLoggedIn() -> Bool
    func getProviderCredentials() -> LoginCredentials
    func getBasicProfileForSignedInUser() -> Observable<FacebookUserInfo>
}
