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
    static var photoService: PhotoService = KingFisherPhotoService()
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
