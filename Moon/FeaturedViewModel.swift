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
    var featuredEvents = Variable<[FeaturedEvent]>([])
    
    init(coordinator: SceneCoordinatorType, barAPI: BarAPIType = BarAPIController(), userAPI: UserAPIType = UserAPIController(), photoService: PhotoService = KingFisherPhotoService()) {
        self.sceneCoordinator = coordinator
        self.barAPI = barAPI
        self.userAPI = userAPI
        self.photoService = photoService
        
        loadEvents = Action(workFactory: { _ in
            return barAPI.getEventsIn(region: "Dallas").map({ $0.map(FeaturedEvent.init) })
        })
        
        loadEvents.elements.bind(to: featuredEvents).addDisposableTo(disposeBag)
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
    
    func onMoreInfo(eventID: String) -> CocoaAction {
        return CocoaAction {
            print("More Info")
            return Observable.empty()
        }
    }
}
