//
//  SpecialsViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import Action
import RxDataSources
import SwaggerClient

typealias SpecialSection = AnimatableSectionModel<String, Special>

struct SpecialsViewModel: ImageDownloadType {
    
    // Private
    private let disposeBag = DisposeBag()
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    private let barAPI: BarAPIType
    private let userAPI: UserAPIType
    let photoService: PhotoService
    
    // Inputs
    
    // Outputs
    var specials: Observable<[SpecialSection]>
    
    init(coordinator: SceneCoordinatorType, barAPI: BarAPIType = BarAPIController(), userAPI: UserAPIType = UserAPIController(), photoService: PhotoService = KingFisherPhotoService(), type: AlcoholType) {
        self.sceneCoordinator = coordinator
        self.barAPI = barAPI
        self.userAPI = userAPI
        self.photoService = photoService
        
        //TODO: update api call to return special by time
        specials = barAPI.getSpecialsIn(region: "Dallas", type: type.rawValue)
            .map({
                return [SpecialSection(model: "Specials", items: $0)]
            })
    }
    
    func onLike(specialID: String) -> CocoaAction {
        return CocoaAction {
            print("Liked Special")
            return self.userAPI.likeSpecial(userID: "123", specialID: specialID)
        }
    }
    
    func onViewBar(barID: String) -> CocoaAction {
        return CocoaAction {
            print("View Bar Profile")
            let vm = BarProfileViewModel(coordinator: self.sceneCoordinator, barID: barID)
            return self.sceneCoordinator.transition(to: Scene.Bar.profile(vm), type: .modal)
        }
    }
    
    func onViewLikers(specialID: String) -> CocoaAction {
        return CocoaAction {_ in
            let vm = UsersTableViewModel(coordinator: self.sceneCoordinator, sourceID: .special(id: specialID))
            return self.sceneCoordinator.transition(to: Scene.User.usersTable(vm), type: .modal)
        }
    }

}
