//
//  UsersTableViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/13/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action

struct UsersTableViewModel: BackType, ImageNetworkingInjected, NetworkingInjected {

    // Local
    let sourceID: UserTableSource
    
    // Dependencies
    let sceneCoordinator: SceneCoordinatorType
    
    // Outputs
    lazy var users: Observable<[UserSectionModel]> = { this in
        var userSource: Observable<[UserSectionModel]>
        
        switch this.sourceID {
        case let .user(id):
            if id == SignedInUser.userID {
                this.currentSignedInUser.value = true
                userSource = Observable.zip(this.getFriends(userID: id), this.getFriendRequest(userID: id)).map({
                    // The order of the two elements in the array will determine which section shows first
                    return [$1, $0]
                })
            } else {
                this.currentSignedInUser.value = false
                userSource = this.getFriends(userID: id).toArray()
            }
        case let .activity(id):
            userSource = this.getActivityLikers(activityID: id)
        case let .event(id):
            userSource = this.getEventLikers(eventID: id)
        case let .special(id):
            userSource = this.getSpecialLikers(specialID: id)
        }
        
        return Observable.of(Observable<Void>.just(()), this.reload).flatMap({_ in
            return userSource
        })

    }(self)
    
    let currentSignedInUser = Variable(false)
    
    // Inputs
    var reload = PublishSubject<Void>()
    
    init(coordinator: SceneCoordinatorType, sourceID: UserTableSource) {
        sceneCoordinator = coordinator
        self.sourceID = sourceID
        
    }
    
    func getFriends(userID: String) -> Observable<UserSectionModel> {
        return userAPI.getFriends(userID: userID)
            .map({
                return $0.map(UserSectionItem.friend)
            }).map({
                return UserSectionModel.friendsSection(title: "Friends", items: $0)
            })
    }
    
    func getFriendRequest(userID: String) -> Observable<UserSectionModel> {
        return userAPI.getFriendRequest(userID: userID)
            .map({
                return $0.map(UserSectionItem.friendRequest)
            }).map({
                return UserSectionModel.friendRequestsSection(title: "Friend Requests", items: $0)
            })

    }
    
    func getActivityLikers(activityID: String) -> Observable<[UserSectionModel]> {
        return userAPI.getActivityLikes(activityID: activityID)
            .map({
                return $0.map(UserSectionItem.friend)
            }).map({
                return UserSectionModel.friendsSection(title: "Activity Likes", items: $0)
            }).toArray()
        
    }
    
    func getSpecialLikers(specialID: String) -> Observable<[UserSectionModel]> {
        //TODO: implement once api returns snapshot instead of profile
        return Observable.empty()
    }
    
    func getEventLikers(eventID: String) -> Observable<[UserSectionModel]> {
        return barAPI.getEventLikes(eventID: eventID)
            .map({
                return $0.map(UserSectionItem.friend)
            }).map({
                return UserSectionModel.friendsSection(title: "Event Likes", items: $0)
            }).toArray()
    }
    
    func onShowUser(indexPath: IndexPath) -> CocoaAction {
        return CocoaAction {_ in
            return Observable.empty()
            //TODO: fix
//            return Observable.just().withLatestFrom(self.users).map({ sectionModel in
//                var vm: ProfileViewModel!
//                if case let .friend(snapshot) = sectionModel[indexPath.section].items[indexPath.row] {
//                    vm = ProfileViewModel(coordinator: self.sceneCoordinator, userID: snapshot.id ??
//                "0")
//                } else if case let .friendRequest(snapshot) = sectionModel[indexPath.section].items[indexPath.row] {
//                    vm = ProfileViewModel(coordinator: self.sceneCoordinator, userID: snapshot.id ?? "0")
//                }
//                return vm
//            }).flatMap({
//                self.sceneCoordinator.transition(to: Scene.User.profile($0), type: .popover)
//            })
        }
    }
    
    func onShowContacts() -> CocoaAction {
        return CocoaAction {
            let vm = ContactsViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.UserDiscovery.contacts(vm), type: .push)
        }
    }
    
    func onAcceptFriendRequest(userID: String) -> CocoaAction {
        return CocoaAction {
            return self.userAPI.declineFriend(userID: SignedInUser.userID, friendID: userID)
        }
    }
    
    func onDeclineFriendRequest(userID: String) -> CocoaAction {
        return CocoaAction {
            return self.userAPI.acceptFriend(userID: SignedInUser.userID, friendID: userID)
        }
    }
}
