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

typealias ActivitySection = AnimatableSectionModel<String, Activity>

struct BarActivityFeedViewModel: ImageDownloadType {
    
    // Private
    private let disposeBag = DisposeBag()
    var photoService: PhotoService
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    let userAPI: UserAPIType
    
    // Inputs
    
    // Outputs
    lazy var refreshAction: Action<Void, [ActivitySection]> = { this in
        return Action { _ in
            return this.userAPI.getActivityFeed(userID: "594c2532fc13ae6572000000").map({
                [ActivitySection.init(model: "Activities", items: $0)]
            })
        }
    }(self)
    
    init(coordinator: SceneCoordinatorType, userAPI: UserAPIType = UserAPIController(), photoService: PhotoService = KingFisherPhotoService()) {
        self.sceneCoordinator = coordinator
        self.userAPI = userAPI
        self.photoService = photoService

    }
    
    func onLike(activtyID: String) -> CocoaAction {
        return CocoaAction {
            return Observable.empty()
        }
    }
    
    func onView(userID: String) -> CocoaAction {
        return CocoaAction {
            let vm = ProfileViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.User.profile(vm), type: .popover)
        }
    }
    
    func onView(barID: String) -> CocoaAction {
        return CocoaAction {
            let vm = BarProfileViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.Bar.profile(vm), type: .modal)
        }
    }
    
    func onViewLikers(activityID: String) -> CocoaAction {
        return CocoaAction {
            let vm = UsersTableViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.User.usersTable(vm), type: .modal)
        }
    }
}
