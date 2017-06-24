//
//  FeaturedViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import Action
import SwaggerClient

struct FeaturedViewModel: ImageDownloadType {
    
    // Local
    private let disposeBag = DisposeBag()
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    private let barAPI: BarAPIType
    private let userAPI: UserAPIType
    var photoService: PhotoService
    
    // Inputs
    var loadEvents: Action<Void, [BarEvent]>
    // Outputs
    var featuredEvents = Variable<[BarEvent]>([])
    
    init(coordinator: SceneCoordinatorType, barAPI: BarAPIType = BarAPIController(), userAPI: UserAPIType = UserAPIController(), photoService: PhotoService = KingFisherPhotoService()) {
        self.sceneCoordinator = coordinator
        self.barAPI = barAPI
        self.userAPI = userAPI
        self.photoService = photoService
        
        loadEvents = Action(workFactory: { _ in
            return barAPI.getEventsIn(region: "Dallas")
        })
        
        loadEvents.elements.bind(to: featuredEvents).addDisposableTo(disposeBag)
    }
    
    func onLikeEvent(eventID: String) -> CocoaAction {
        return CocoaAction { _ in
            print("Like Event")
            return self.userAPI.likeEvent(userID: "123123", eventID: eventID)
        }
    }
    
    func onShareEvent(eventID: String) -> CocoaAction {
        return CocoaAction { _ in
            //TODO: add share event code
            print("Share Event")
            return Observable.empty()
        }
    }
    
    func onMoreInfo(eventID: String) -> CocoaAction {
        return CocoaAction {
            let vm = BarProfileViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.Bar.profile(vm), type: .modal)
        }
    }
}
