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
import SwaggerClient
import Action

struct SignedInUser {
    static let userID = "594c2532fc13ae6572000001"
}

typealias ActivitySection = AnimatableSectionModel<String, Activity>

struct BarActivityFeedViewModel: ImageDownloadType {
    
    // Private
    private let disposeBag = DisposeBag()
    var photoService: PhotoService
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    let userAPI: UserAPIType
    let barAPI: BarAPIType
    
    // Inputs
    
    // Outputs
    var refreshAction: Action<Void, [ActivitySection]>
    
    init(coordinator: SceneCoordinatorType, userAPI: UserAPIType = UserAPIController(), photoService: PhotoService = KingFisherPhotoService(), barAPI: BarAPIType = BarAPIController()) {
        self.sceneCoordinator = coordinator
        self.userAPI = userAPI
        self.photoService = photoService
        self.barAPI = barAPI

//        let numOfBlanks = (0..<7)
//        let blankActivities = numOfBlanks.map { index -> Activity in
//            let activity = Activity()
//            activity.id = "\(index)"
//            return activity
//        }
        
        refreshAction = Action { _ in
            return userAPI.getActivityFeed(userID: SignedInUser.userID)
                .retryWhen(RxErrorHandlers.retryHandler)
                .map({
                    [ActivitySection.init(model: "Activities", items: $0)]
                })
                //.startWith([ActivitySection.init(model: "Blank Activities", items: blankActivities)])
        }

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
