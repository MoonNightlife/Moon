//
//  CityOverviewViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import Action

struct CityOverviewViewModel: NetworkingInjected, AuthNetworkingInjected, StorageNetworkingInjected, ImageNetworkingInjected {
    
    // Private
    private let disposeBag = DisposeBag()
    
    // Inputs
    var selectedUserIndex = BehaviorSubject<UsersGoingType>(value: .everyone)
    
    // Outputs
    var displayedUsers = Variable<[Activity]>([])
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    
    // Actions
    lazy var reloadBars: Action<Void, [TopBar]> = { this in
        return Action(workFactory: {
            return this.barAPI.getBarsIn(region: "Dallas")
        })
    }(self)
    
    lazy var getFriendsForBar: Action<String, [Activity]> = { this in
        return Action(workFactory: {
            return this.barAPI.getBarFriends(barID: $0, userID: this.authAPI.SignedInUserID).startWith([])
        })
    }(self)
    
    lazy var getPeopleForBar: Action<String, [Activity]> = { this in
        return Action(workFactory: {
            return this.barAPI.getBarPeople(barID: $0).startWith([])
        })
    }(self)
    
    init(coordinator: SceneCoordinatorType) {
        self.sceneCoordinator = coordinator
        
        Observable.combineLatest(getPeopleForBar.elements, getFriendsForBar.elements, selectedUserIndex)
            .map({ (people, friends, userType) -> [Activity] in
                switch userType {
                case .everyone:
                    return people
                case .friends:
                    return friends
                }
            })
            .bind(to: displayedUsers)
            .addDisposableTo(disposeBag)
    }
    
    func onViewLikers(userID: String) -> CocoaAction {
        return CocoaAction { _ in
            let vm = UsersTableViewModel(coordinator: self.sceneCoordinator, sourceID: .activity(id: userID))
            return self.sceneCoordinator.transition(to: Scene.User.usersTable(vm), type: .modal)
        }
    }
    
    func hasLikedActivity(activityID: String) -> Action<Void, Bool> {
        return Action<Void, Bool> { _ in
            return self.userAPI.hasLikedActivity(userID: self.authAPI.SignedInUserID, ActivityID: activityID)
        }
    }
    
    func getProfileImage(id: String) -> Action<Void, UIImage> {
        return Action(workFactory: { _ in
            return self.storageAPI.getProfilePictureDownloadUrlForUser(id: id, picName: "pic1.jpg")
                .errorOnNil()
                .flatMap({
                    self.photoService.getImageFor(url: $0)
                })
                .catchErrorJustReturn(#imageLiteral(resourceName: "DefaultProfilePic"))
        })
    }
    
    func onShowProfile(userID: String) -> CocoaAction {
        return CocoaAction {  _ in
            let vm = ProfileViewModel(coordinator: self.sceneCoordinator, userID: userID)
            return self.sceneCoordinator.transition(to: Scene.User.profile(vm), type: .popover)
        }
    }
    
    func onLikeActivity(userID: String) -> CocoaAction {
        return CocoaAction { _ in
            return self.userAPI.likeActivity(userID: self.authAPI.SignedInUserID, activityUserID: userID)
        }
    }

}
