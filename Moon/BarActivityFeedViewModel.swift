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

struct SignedInUser {
    static let userID = "594c2532fc13ae6572000001"
}

typealias ActivitySection = AnimatableSectionModel<String, Activity>

struct BarActivityFeedViewModel: ImageNetworkingInjected, NetworkingInjected {
    
    // Private
    private let disposeBag = DisposeBag()
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    
    // Inputs
    
    // Outputs
    lazy var refreshAction: Action<Void, [ActivitySection]> = { this in
       return  Action { _ in
            return this.userAPI.getActivityFeed(userID: SignedInUser.userID)
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
    
    func onLike(activtyID: String) -> CocoaAction {
        return CocoaAction {
            return self.userAPI.likeActivity(userID: SignedInUser.userID, activityID: activtyID)
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
    
    func onViewLikers(activityID: String) -> CocoaAction {
        return CocoaAction {
            let vm = UsersTableViewModel(coordinator: self.sceneCoordinator, sourceID: .activity(id: activityID))
            return self.sceneCoordinator.transition(to: Scene.User.usersTable(vm), type: .modal)
        }
    }
}
