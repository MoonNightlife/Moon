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
import RxOptional

class UsersTableViewModel: BackType, ImageNetworkingInjected, NetworkingInjected, AuthNetworkingInjected, StorageNetworkingInjected {

    // Local
    let sourceID: UserTableSource
    
    // Dependencies
    let sceneCoordinator: SceneCoordinatorType
    
    // Outputs
    lazy var users: Observable<[UserSectionModel]> = { this in
        var userSource: Observable<[UserSectionModel]>
        
        switch this.sourceID {
        case let .user(id):
            if id == this.authAPI.SignedInUserID {
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
        case let .group(id):
            userSource = this.getGroupLikers(groupID: id)
        }
        
        return this.reload.flatMap({_ in
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
            .catchErrorJustReturn([])
            .map({
                return $0.map(UserSectionItem.friend)
            }).map({
                return UserSectionModel.friendsSection(title: "Friends", items: $0)
            })
    }
    
    func getFriendRequest(userID: String) -> Observable<UserSectionModel> {
        return userAPI.getFriendRequest(userID: userID)
            .catchErrorJustReturn([])
            .map({
                return $0.map(UserSectionItem.friendRequest)
            }).map({
                return UserSectionModel.friendRequestsSection(title: "Friend Requests", items: $0)
            })

    }
    
    func getActivityLikers(activityID: String) -> Observable<[UserSectionModel]> {
        return userAPI.getActivityLikers(activityID: activityID)
            .map({
                return $0.map(UserSectionItem.friend)
            }).map({
                return UserSectionModel.friendsSection(title: "Activity Likes", items: $0)
            }).toArray()
        
    }
    
    func getSpecialLikers(specialID: String) -> Observable<[UserSectionModel]> {
        return barAPI.getSpecialLikers(specialID: specialID)
            .map({
                return $0.map(UserSectionItem.friend)
            }).map({
                return UserSectionModel.friendsSection(title: "Special Likes", items: $0)
            }).toArray()
    }
    
    func getEventLikers(eventID: String) -> Observable<[UserSectionModel]> {
        return barAPI.getEventLikers(eventID: eventID)
            .map({
                return $0.map(UserSectionItem.friend)
            }).map({
                return UserSectionModel.friendsSection(title: "Event Likes", items: $0)
            }).toArray()
    }
    
    func getGroupLikers(groupID: String) -> Observable<[UserSectionModel]> {
        return groupAPI.getActivityGroupLikers(groupID: groupID)
            .map({
                return $0.map(UserSectionItem.friend)
            }).map({
                return UserSectionModel.friendsSection(title: "Group Likes", items: $0)
            }).toArray()
    }
    
    lazy var onShowUser: Action<UserSectionModel.Item, Void> = {
        return Action { model in
        
            return Observable.just()
                .map({ _ -> String? in
                    if case let .friend(snapshot) = model {
                        return snapshot.id
                    } else if case let .friendRequest(snapshot) = model {
                        return snapshot.id
                    } else {
                        return nil
                    }
                })
                .filterNil()
                .map({ id -> ProfileViewModel in
                    return ProfileViewModel(coordinator: self.sceneCoordinator, userID: id)
                })
                .flatMap({
                    return self.sceneCoordinator.transition(to: Scene.User.profile($0), type: .popover)
                })
        }
    }()
    
    func onAcceptFriendRequest(userID: String) -> CocoaAction {
        return CocoaAction {_ in 
            return self.userAPI.acceptFriend(userID: self.authAPI.SignedInUserID, friendID: userID).do(onNext: {
                self.reload.onNext()
            })
        }
    }
    
    func onDeclineFriendRequest(userID: String) -> CocoaAction {
        return CocoaAction {
            return self.userAPI.declineFriend(userID: self.authAPI.SignedInUserID, friendID: userID).do(onNext: {
                self.reload.onNext()
            })
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
}
