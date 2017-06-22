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
    
    // Outputs
    var users: Observable<[UserSectionModel]>
    
    // Inputs
    var reload = PublishSubject<Void>()
    
    init(coordinator: SceneCoordinatorType, photoService: PhotoService = KingFisherPhotoService(), userAPI: UserAPIType = UserAPIController()) {
        sceneCoordinator = coordinator
        self.photoService = photoService
        self.userAPI = userAPI
        
        let friendsNetworkCall = userAPI.getFriends(userID: "01").map({ profiles -> [UserSnapshot] in
            //TODO: remove this once api returns snapshots instead of profiles
            return profiles.map({ profile in
                let snap = UserSnapshot()
                snap.fullName = profile.firstName
                snap.profilePic = profile.profilePics!.first
                snap.id = profile.id
                return snap
            })
        }).map({
            return $0.map(UserSectionItem.friend)
        }).map({
            return UserSectionModel.friendsSection(title: "Friends", items: $0)
        })
        
        let friendRequestNetworkCall = userAPI.getFriendRequest(userID: "01").map({
            return $0.map(UserSectionItem.friendRequest)
        }).map({
            return UserSectionModel.friendsSection(title: "Friend Requests", items: $0)
        })
        
        let friends = reload.flatMap({
            return friendsNetworkCall
        })
        
        let friendRequest = reload.flatMap({
            return friendRequestNetworkCall
        })

        users = Observable.zip(friends, friendRequest).map({
            // The order of the two elements in the array will determine which section shows first
            return [$1, $0]
        })
        
    }
    
    func onShowUser() -> CocoaAction {
        return CocoaAction {
            let vm = ProfileViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.User.profile(vm), type: .popover)
        }
    }
    
    func onShowContacts() -> CocoaAction {
        return CocoaAction {
            let vm = ContactsViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.UserDiscovery.contacts(vm), type: .push)
        }
    }
    
    func onAcceptFriendRequest(userID: String?) -> CocoaAction {
        return CocoaAction {
            print("Accept Friend Request")
            guard let id = userID else {
                //TODO: Display error
                return Observable.empty()
            }
            return self.userAPI.declineFriend(userID: "01", friendID: id)
        }
    }
    
    func onDeclineFriendRequest(userID: String?) -> CocoaAction {
        return CocoaAction {
            print("Decline Friend Request")
            guard let id = userID else {
                //TODO: Display error
                return Observable.empty()
            }
            return self.userAPI.acceptFriend(userID: "01", friendID: id)
        }
    }
}
