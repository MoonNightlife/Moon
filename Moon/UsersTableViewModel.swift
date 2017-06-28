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
import SwaggerClient

struct UsersTableViewModel: BackType, ImageDownloadType {

    // Dependencies
    let sceneCoordinator: SceneCoordinatorType
    var photoService: PhotoService
    private let userAPI: UserAPIType
    private let barAPI: BarAPIType
    
    // Outputs
    var users: Observable<[UserSectionModel]>
    let currentSignedInUser = Variable(false)
    
    // Inputs
    var reload = PublishSubject<Void>()
    
    init(coordinator: SceneCoordinatorType, photoService: PhotoService = KingFisherPhotoService(), userAPI: UserAPIType = UserAPIController(), sourceID: UserTableSource, barAPI: BarAPIType = BarAPIController()) {
        sceneCoordinator = coordinator
        self.photoService = photoService
        self.userAPI = userAPI
        self.barAPI = barAPI
        
        var userSource: Observable<[UserSectionModel]>
        
        switch sourceID {
        case let .user(id):
            if id == SignedInUser.userID {
                currentSignedInUser.value = true
                userSource = Observable.zip(UsersTableViewModel.getFriends(userID: id, userAPI: userAPI), UsersTableViewModel.getFriendRequest(userID: id, userAPI: userAPI)).map({
                    // The order of the two elements in the array will determine which section shows first
                    return [$1, $0]
                })
            } else {
                currentSignedInUser.value = false
                userSource = UsersTableViewModel.getFriends(userID: id, userAPI: userAPI).toArray()
            }
        case let .activity(id):
            userSource = UsersTableViewModel.getActivityLikers(activityID: id, userAPI: userAPI)
        case let .event(id):
            userSource = UsersTableViewModel.getEventLikers(eventID: id, barAPI: barAPI)
        case let .special(id):
            userSource = UsersTableViewModel.getSpecialLikers(specialID: id, barAPI: barAPI)
        }
        
        users = Observable.of(Observable<Void>.just(()), reload).flatMap({_ in
            return userSource
        })
    }
    
    static func getFriends(userID: String, userAPI: UserAPIType) -> Observable<UserSectionModel> {
        return userAPI.getFriends(userID: userID)
            .map({
                return $0.map(UserSectionItem.friend)
            }).map({
                return UserSectionModel.friendsSection(title: "Friends", items: $0)
            })
    }
    
    static func getFriendRequest(userID: String, userAPI: UserAPIType) -> Observable<UserSectionModel> {
        return userAPI.getFriendRequest(userID: userID)
            .map({
                return $0.map(UserSectionItem.friendRequest)
            }).map({
                return UserSectionModel.friendRequestsSection(title: "Friend Requests", items: $0)
            })

    }
    
    static func getActivityLikers(activityID: String, userAPI: UserAPIType) -> Observable<[UserSectionModel]> {
        return userAPI.getActivityLikes(activityID: activityID)
            .map({
                return $0.map(UserSectionItem.friend)
            }).map({
                return UserSectionModel.friendsSection(title: "Activity Likes", items: $0)
            }).toArray()
        
    }
    
    static func getSpecialLikers(specialID: String, barAPI: BarAPIType) -> Observable<[UserSectionModel]> {
        //TODO: implement once api returns snapshot instead of profile
        return Observable.empty()
    }
    
    static func getEventLikers(eventID: String, barAPI: BarAPIType) -> Observable<[UserSectionModel]> {
        return barAPI.getEventLikes(eventID: eventID)
            .map({
                return $0.map(UserSectionItem.friend)
            }).map({
                return UserSectionModel.friendsSection(title: "Event Likes", items: $0)
            }).toArray()
    }
    
    func onShowUser(indexPath: IndexPath) -> CocoaAction {
        return CocoaAction {
            return Observable.just().withLatestFrom(self.users).map({ sectionModel in
                var vm: ProfileViewModel!
                if case let .friend(snapshot) = sectionModel[indexPath.section].items[indexPath.row] {
                    vm = ProfileViewModel(coordinator: self.sceneCoordinator, userID: snapshot.id ??
                "0")
                } else if case let .friendRequest(snapshot) = sectionModel[indexPath.section].items[indexPath.row] {
                    vm = ProfileViewModel(coordinator: self.sceneCoordinator, userID: snapshot.id ?? "0")
                }
                return vm
            }).flatMap({
                self.sceneCoordinator.transition(to: Scene.User.profile($0), type: .popover)
            })
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
