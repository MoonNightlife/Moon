//
//  BarActivityFeedViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import Action

typealias ActivitySection = AnimatableSectionModel<String, Activity>

struct BarActivityFeedViewModel: ImageNetworkingInjected, NetworkingInjected, AuthNetworkingInjected {
    
    // Private
    private let disposeBag = DisposeBag()
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    
    // Inputs
    
    // Outputs
    lazy var refreshAction: Action<Void, [ActivitySection]> = { this in
       return  Action { _ in
            return this.userAPI.getActivityFeed(userID: this.authAPI.SignedInUserID)
                .retryWhen(RxErrorHandlers.retryHandler)
                .map({
                    [ActivitySection.init(model: "Activities", items: $0)]
                })
        }
    }(self)
    
    init(coordinator: SceneCoordinatorType) {
        self.sceneCoordinator = coordinator

//        let numOfBlanks = (0..<7)
//        let blankActivities = numOfBlanks.map { index -> Activity in
//            let activity = Activity()
//            activity.id = "\(index)"
//            return activity
//        }
        
    }
    
    func onLike(userID: String) -> CocoaAction {
        return CocoaAction {_ in 
            return self.userAPI.likeActivity(userID: self.authAPI.SignedInUserID, activityUserID: userID)
        }
    }
    
    func onView(userID: String) -> CocoaAction {
        return CocoaAction {
            let vm = ProfileViewModel(coordinator: self.sceneCoordinator, userID: userID)
            return self.sceneCoordinator.transition(to: Scene.User.profile(vm), type: .popover)
        }
    }
    
    func onView(barID: String) -> CocoaAction {
        return CocoaAction {
            let vm = BarProfileViewModel(coordinator: self.sceneCoordinator, barID: barID)
            return self.sceneCoordinator.transition(to: Scene.Bar.profile(vm), type: .modal)
        }
    }
    
    func onViewLikers(userID: String) -> CocoaAction {
        return CocoaAction {
            let vm = UsersTableViewModel(coordinator: self.sceneCoordinator, sourceID: .activity(id: userID))
            return self.sceneCoordinator.transition(to: Scene.User.usersTable(vm), type: .modal)
        }
    }
}
