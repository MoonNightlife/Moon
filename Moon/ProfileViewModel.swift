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
import SwaggerClient

struct ProfileViewModel {
    
    // Local
    private let bag = DisposeBag()
    private let barID = Variable<String?>(nil)

    // Dependecies
    private let scenceCoordinator: SceneCoordinatorType
    private let userID: String
    private let userAPI: UserAPIType
    
    // Inputs
    
    // Outputs
    var username: Observable<String>
    var fullName: Observable<String>
    var bio: Observable<String>
    var activityBarName: Observable<String>
    var profilePictures = Variable<[UIImage]>([])
    var isSignedInUserProfile = Variable(false)
    var numFriendRequests = Variable<String?>(nil)
    
    init(coordinator: SceneCoordinatorType, userAPI: UserAPIType = UserAPIController(), photoService: PhotoService = KingFisherPhotoService(), userID: String) {
        self.scenceCoordinator = coordinator
        self.userID = userID
        self.userAPI = userAPI
        
        if SignedInUser.userID == userID {
            isSignedInUserProfile.value = true
            userAPI.getFriendRequest(userID: userID)
                .catchErrorJustReturn([])
                .map({
                    return $0.count
                })
                .map({
                    return $0 == 0 ? "\($0)" : nil
                })
                .bind(to: numFriendRequests)
                .addDisposableTo(bag)
        } else {
            isSignedInUserProfile.value = false
        }
        
        let user = userAPI.getUserProfile(userID: userID).catchErrorJustReturn(UserProfile())
        
        user.map({ user in
            return user.activity?.barID
        }).bind(to: barID).addDisposableTo(bag)
        
        username = user.map({ $0.username }).replaceNilWith("No Username")
        fullName = user.map({
            let firstName = $0.firstName ?? "No First Name"
            let lastName = $0.lastName ?? "No Last Name"
            return firstName + " " + lastName
        }).catchErrorJustReturn("No Name")
        //TODO: Add bio when api adds property to model
        bio = user.map({ _ in "No Bio" })
        activityBarName = user.map({ $0.activity }).filterNil().map({ $0.barName }).replaceNilWith("No Plans")
        
        user.map({ $0.profilePics }).filterNil()
            .flatMap({ pictureURLs in
                return Observable.from(pictureURLs).flatMap({
                    return photoService.getImageFor(url: URL(string: $0)!)
                }).toArray()
            })
            .catchErrorJustReturn([])
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
            let vm = EditProfileViewModel(coordinator: self.scenceCoordinator)
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
            return self.userAPI.requestFriend(userID: SignedInUser.userID, friendID: self.userID)
        }
    }
    
}
