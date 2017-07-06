//
//  ProfileViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import RxOptional

struct ProfileViewModel: ImageNetworkingInjected, StorageNetworkingInjected, AuthNetworkingInjected {
    
    // Local
    private let bag = DisposeBag()
    private let barID = Variable<String?>(nil)
    private let userID: String
    
    // Dependecies
    private let scenceCoordinator: SceneCoordinatorType
    var userAPI: UserAPIType
    
    // Inputs
    var reload: Action<Void, UserProfile>
    
    // Outputs
    var username: Observable<String>
    var fullName: Observable<String>
    var bio: Observable<String>
    var activityBarName: Observable<String>
    var isSignedInUserProfile = Variable(false)
    var numFriendRequests = Variable<String?>(nil) 
    var profilePictures = Variable<[UIImage]>([])
    
    init(coordinator: SceneCoordinatorType, userID: String, userAPI: UserAPIType = FirebaseUserAPI(), photoService: PhotoService = KingFisherPhotoService(), authAPI: AuthAPIType = FirebaseAuthAPI()) {
        self.scenceCoordinator = coordinator
        
        self.userID = userID
        self.userAPI = userAPI
        
        if authAPI.SignedInUserID == userID {
            isSignedInUserProfile.value = true
            userAPI.getFriendRequest(userID: userID)
                .catchErrorJustReturn([])
                .map({
                    return $0.count
                })
                .map({
                    return $0 > 0 ? "\($0)" : nil
                })
                .bind(to: numFriendRequests)
                .addDisposableTo(bag)
        } else {
            isSignedInUserProfile.value = false
        }
        
        reload = Action(workFactory: {
            return userAPI.getUserProfile(userID: userID).catchErrorJustReturn(UserProfile()).shareReplay(1)
        })
        
        let user = reload.elements
        
        user.map({ user in
            return user.barId
        }).bind(to: barID).addDisposableTo(bag)
        
        username = user.map({ $0.username }).replaceNilWith("No Username")
        fullName = user.map({
            let firstName = $0.firstName ?? "No First Name"
            let lastName = $0.lastName ?? "No Last Name"
            return firstName + " " + lastName
        })
    
        bio = user.map({ $0.bio }).replaceNilWith("No Bio")
        activityBarName = user.map({ $0.barName }).replaceNilWith("No Plans")

        storageAPI.getProfilePictureDownloadUrlForUser(id: userID).filterNil()
            .flatMap({
                return photoService.getImageFor(url: $0)
            })
            .toArray()
            .catchErrorJustReturn([#imageLiteral(resourceName: "DefaultProfilePic")])
            .startWith([#imageLiteral(resourceName: "DefaultProfilePic")])
            .bind(to: profilePictures).addDisposableTo(bag)
        
    }
    
    func onDismiss() -> CocoaAction {
        return CocoaAction {
            return self.scenceCoordinator.pop()
        }
    }
    
    func onShowFriends() -> CocoaAction {
        return CocoaAction {
            let vm = UsersTableViewModel(coordinator: self.scenceCoordinator, sourceID: .user(id: self.userID))
            return self.scenceCoordinator.transition(to: Scene.User.usersTable(vm), type: .modal)
        }
    }
    
    func onEdit() -> CocoaAction {
        return CocoaAction {
            let vm = EditProfileViewModel(coordinator: self.scenceCoordinator, userID: self.userID)
            return self.scenceCoordinator.transition(to: Scene.User.edit(vm), type: .modal)
        }
    }
    
    func onViewBar() -> CocoaAction {
        return CocoaAction {_ in
            if let id = self.barID.value {
                let vm = BarProfileViewModel(coordinator: self.scenceCoordinator, barID: id)
                return self.scenceCoordinator.transition(to: Scene.Bar.profile(vm), type: .modal)
            } else {
                return Observable.empty()
            }           
        }
    }
    
    func onAddFriend() -> CocoaAction {
        return CocoaAction { _ in
            return self.userAPI.requestFriend(userID: self.authAPI.SignedInUserID, friendID: self.userID)
        }
    }
    
}
