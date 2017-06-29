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

struct FeaturedViewModel: ImageNetworkingInjected, NetworkingInjected {
    
    // Local
    private let disposeBag = DisposeBag()
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    
    // Inputs
    lazy var loadEvents: Action<Void, [BarEvent]> = { this in
        return Action(workFactory: { _ in
            return this.barAPI.getEventsIn(region: "Dallas")
        })
    }(self)
    // Outputs
    var featuredEvents = Variable<[BarEvent]>([])
    
    init(coordinator: SceneCoordinatorType) {
        self.sceneCoordinator = coordinator
        
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
    
    func onMoreInfo(barID: String) -> CocoaAction {
        return CocoaAction {
            let vm = BarProfileViewModel(coordinator: self.sceneCoordinator, barID: barID)
            return self.sceneCoordinator.transition(to: Scene.Bar.profile(vm), type: .modal)
        }
    }
    
    func onViewLikers(eventID: String) -> CocoaAction {
        return CocoaAction {
            let vm = UsersTableViewModel(coordinator: self.sceneCoordinator, sourceID: .event(id: eventID))
            return self.sceneCoordinator.transition(to: Scene.User.usersTable(vm), type: .modal)
        }
    }
}
