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

struct BarActivityFeedViewModel: ImageNetworkingInjected, NetworkingInjected, AuthNetworkingInjected, StorageNetworkingInjected {
    
    // Private
    private let disposeBag = DisposeBag()
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    
    // Inputs
    
    // Outputs
    lazy var refreshAction: Action<Void, [ActivitySection]> = { this in
       return  Action { _ in
            return this.userAPI.getActivityFeed(userID: this.authAPI.SignedInUserID)
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
    
    func hasLikedActivity(activityID: String) -> Action<Void, Bool> {
        return Action<Void, Bool> { _ in
            return self.userAPI.hasLikedActivity(userID: self.authAPI.SignedInUserID, ActivityID: activityID)
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
    
    func getProfileImage(id: String) -> Action<Void, UIImage> {
        return Action(workFactory: {_ in
            return self.storageAPI.getProfilePictureDownloadUrlForUser(id: id, picName: "pic1.jpg")
                .filterNil()
                .flatMap({
                    self.photoService.getImageFor(url: $0)
                })
        })
    }
    
    func getGroupImage(id: String) -> Action<Void, UIImage> {
        return Action {
            return self.storageAPI.getGroupPictureDownloadURLForGroup(id: id)
                .errorOnNil()
                .flatMap({
                    self.photoService.getImageFor(url: $0)
                })
                .catchErrorJustReturn(#imageLiteral(resourceName: "DefaultGroupPic"))
        }
    }
    
    func onViewActivity(groupID: String) -> CocoaAction {
        return CocoaAction {
            let vm = GroupActivityViewModel(sceneCoordinator: self.sceneCoordinator, groupID: groupID)
            return self.sceneCoordinator.transition(to: Scene.Group.groupActivity(vm), type: .modal)
        }
    }
}
