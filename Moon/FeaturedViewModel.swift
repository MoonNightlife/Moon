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

struct FeaturedViewModel: ImageDownloadType {
    
    // Local
    private let disposeBag = DisposeBag()
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    private let barAPI: BarAPIType
    private let userAPI: UserAPIType
    var photoService: PhotoService
    
    // Inputs
    var loadEvents: Action<Void, [FeaturedEvent]>
    // Outputs
    
    init(coordinator: SceneCoordinatorType, barAPI: BarAPIType = BarAPIController(), userAPI: UserAPIType = UserAPIController(), photoService: PhotoService = KingFisherPhotoService()) {
        self.sceneCoordinator = coordinator
        self.barAPI = barAPI
        self.userAPI = userAPI
        self.photoService = photoService
        
        loadEvents = Action(workFactory: { _ in
            return barAPI.getEventsIn(region: "dallas").map({ $0.map(FeaturedEvent.init) })
        })
    }
    
    func onLikeEvent(eventID: String) -> CocoaAction {
        return CocoaAction { _ in
            print("Like Event")
            return Observable.empty()
        }
    }
    
    func onShareEvent(eventID: String) -> CocoaAction {
        return CocoaAction { _ in
            print("Share Event")
            return Observable.empty()
        }
    }
}
