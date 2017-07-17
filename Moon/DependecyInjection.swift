//
//  DependecyInjection.swift
//  Moon
//
//  Created by Evan Noble on 6/29/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import Action

struct InjectionMap {
    static var barAPI: BarAPIType = FirebaseBarAPI()
    static var userAPI: UserAPIType = FirebaseUserAPI()
    static var storageAPI: StorageAPIType = FirebaseStorageAPI()
    static var authAPI: AuthAPIType = FirebaseAuthAPI()
    static var photoService: PhotoService = KingFisherPhotoService()
    static var facebookAPI: FacebookLoginProviderType = FacebookService()
    static var phoneNumberService: SMSValidationService = SinchService()
}

protocol NetworkingInjected { }

extension NetworkingInjected {
    var userAPI: UserAPIType { return InjectionMap.userAPI }
    var barAPI: BarAPIType { return InjectionMap.barAPI }
}

protocol ImageNetworkingInjected { }

extension ImageNetworkingInjected {
    var photoService: PhotoService { return InjectionMap.photoService }
    
    func downloadImage(url: URL) -> Action<Void, UIImage> {
        return Action(workFactory: {
            return self.photoService.getImageFor(url: url)
        })
    }
}

protocol StorageNetworkingInjected { }

extension StorageNetworkingInjected {
    var storageAPI: StorageAPIType { return InjectionMap.storageAPI }
}

protocol AuthNetworkingInjected { }

extension AuthNetworkingInjected {
    var authAPI: AuthAPIType { return InjectionMap.authAPI }
}

protocol FacebookNetworkingInjected { }

extension FacebookNetworkingInjected {
    var facebookAPI: FacebookLoginProviderType { return InjectionMap.facebookAPI }
}

protocol PhoneNumberValidationInjected { }

extension PhoneNumberValidationInjected {
    var phoneNumberService: SMSValidationService { return InjectionMap.phoneNumberService }
}
