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

struct BarActivityFeedViewModel {
    
    // Private
    private let disposeBag = DisposeBag()
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    let userAPI: UserAPIType
    
    // Inputs
    
    // Outputs
    lazy var refreshAction: Action<Void, [ActivitySection]> = { this in
        return Action { _ in
            return this.userAPI.getActivityFeed(userID: "01").map({
                [ActivitySection.init(model: "Activities", items: $0)]
            })
        }
    }(self)
    
    init(coordinator: SceneCoordinatorType, userAPI: UserAPIType = UserAPIController()) {
        self.sceneCoordinator = coordinator
        self.userAPI = userAPI

    }
    
    func onLike() -> CocoaAction {
        return CocoaAction {
            return Observable.empty()
        }
    }
    
    func onViewUser() -> CocoaAction {
        return CocoaAction {
            let vm = ProfileViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.User.profile(vm), type: .popover)
        }
    }
    
    func onViewBar() -> CocoaAction {
        return CocoaAction {
            let vm = BarProfileViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.Bar.profile(vm), type: .modal)
        }
    }
    
    func onViewLikers() -> CocoaAction {
        return CocoaAction {
            let vm = UsersTableViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.User.usersTable(vm), type: .modal)
        }
    }
}
