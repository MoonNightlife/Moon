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
    private let editProfileInfo = Variable<EditProfileInfo>(EditProfileInfo())
    private let user: Observable<UserProfile>
    private let acceptedFriendRequest = PublishSubject<Void>()
    
    // Dependecies
    private let sceneCoordinator: SceneCoordinatorType
    var userAPI: UserAPIType
    
    // Action
    lazy var numberOfFriendRequest: Action<Void, String?> = { this in
        return Action(enabledIf: this.isSignedInUserProfile.asObservable(), workFactory: {
            return this.userAPI.getFriendRequest(userID: this.authAPI.SignedInUserID)
                .map({
                    return $0.isEmpty ? nil : "\($0.count)"
                })
        })
    }(self)
    
    // Inputs
    var reload: Action<Void, UserProfile>
    var reloadActionButton = PublishSubject<Void>()
    var reloadPhotos = PublishSubject<Void>()
    var reportUser = PublishSubject<Void>()
    
    // Outputs
    var username: Observable<String>
    var fullName: Observable<String>
    var bio: Observable<String>
    var activityBarName: Observable<String>
    var isSignedInUserProfile = Variable(false)
    var profilePictures = Variable<[UIImage]>([])
    var actionButton: Observable<ProfileActionButton>
    var numberOfLikes: Observable<String>
    var hasLiked: Observable<Bool> {
        return self.userAPI.hasLikedActivity(userID: self.authAPI.SignedInUserID, ActivityID: self.userID)
    }
    var showPlan: Observable<Bool> {
        let backendResult = self.userAPI.canViewFullProfile(userID: self.userID, viewerID: self.authAPI.SignedInUserID)
        return Observable.merge(backendResult, acceptedFriendRequest.asObservable().map({true}))
    }
    var showLikeButton: Observable<Bool> {
        return user
            .map({
                $0.barId
            })
            .map({
                if $0 == nil {
                    return false
                } else {
                    return true
                }
            })
            .startWith(false)
    }
    
    init(coordinator: SceneCoordinatorType, userID: String, userAPI: UserAPIType = FirebaseUserAPI(), photoService: PhotoService = KingFisherPhotoService(), authAPI: AuthAPIType = FirebaseAuthAPI(), storageAPI: StorageAPIType = FirebaseStorageAPI()) {
        self.sceneCoordinator = coordinator
        
        self.userID = userID
        self.userAPI = userAPI
        
        reportUser
            .flatMap({
                return userAPI.reportUser(userId: userID)
            })
            .subscribe()
            .addDisposableTo(bag)
        
        if authAPI.SignedInUserID == userID {
            isSignedInUserProfile.value = true
            actionButton = Observable.just(.edit)
        } else {
            isSignedInUserProfile.value = false
            
            let areFriends = reloadActionButton.flatMap({
                return userAPI.areFriends(userID1: authAPI.SignedInUserID, userID2: userID)
            })
            let sentRequest = reloadActionButton.flatMap({
                return userAPI.sentFriendRequest(userID1: authAPI.SignedInUserID, userID2: userID)
            })
            let pendingRequest = reloadActionButton.flatMap({
                return userAPI.pendingFriendRequest(userID1: authAPI.SignedInUserID, userID2: userID)
            })
            
            actionButton = Observable.zip(areFriends, sentRequest, pendingRequest).map({ areFriends, sentRequest, pendingRequest in
                if areFriends {
                    return .removeFriend
                } else if sentRequest {
                    return .cancelRequest
                } else if pendingRequest {
                    return .acceptRequest
                } else {
                    return .addFriend
                }
            })
        }
        
        reload = Action(workFactory: {
            return userAPI.getUserProfile(userID: userID).catchErrorJustReturn(UserProfile()).shareReplay(1)
        })
        
        user = reload.elements
        
        numberOfLikes = user.map { $0.numberOfLikes }.filterNil().map { "\($0)" }
        
        user.map({
            EditProfileInfo(firstName: $0.firstName, lastName: $0.lastName, bio: $0.bio)
        })
        .bind(to: editProfileInfo)
        .addDisposableTo(bag)
        
        user.map({ user in
            return user.barId
        }).bind(to: barID).addDisposableTo(bag)
        
        username = user.map({ $0.username }).replaceNilWith("No Username")
        fullName = user.map({
            let firstName = $0.firstName ?? "No First Name"
            let lastName = $0.lastName ?? "No Last Name"
            return firstName + " " + lastName
        })
    
        bio = user.map({ $0.bio }).replaceNilWith("")
        activityBarName = user.map({ $0.barName }).replaceNilWith("No Plans")

        let newPhotos = reloadPhotos.flatMap({ () -> Observable<[UIImage]> in
            return Observable.of(["pic1.jpg", "pic2.jpg", "pic3.jpg", "pic4.jpg", "pic5.jpg", "pic6.jpg"])
                .flatMap({ picNames in
                    return Observable.from(picNames).flatMap({
                        return storageAPI.getProfilePictureDownloadUrlForUser(id: userID, picName: $0)
                            .catchErrorJustReturn(nil)
                            .filterNil()
                            .flatMap({ url in
                                return photoService.getImageAndNameFor(url: url)
                                    .catchErrorJustReturn((#imageLiteral(resourceName: "DefaultProfilePic"), "default"))
                            })
                    })
                }).toArray()
                .map({
                    let imageOrder = ["pic1.jpg", "pic2.jpg", "pic3.jpg", "pic4.jpg", "pic5.jpg", "pic6.jpg"].slice(start: 0, end: $0.count)
                    return $0.sorted { imageOrder.index(of: $0.imageName)! < imageOrder.index(of: $1.imageName)! }.map({ $0.image })
                })
                .map ({
                    return $0.isNotEmpty ? $0 : [#imageLiteral(resourceName: "DefaultProfilePic")]
                })
            })
        
        newPhotos.bind(to: profilePictures).addDisposableTo(bag)
    }
    
    func onDismiss() -> CocoaAction {
        return CocoaAction {
            return self.sceneCoordinator.pop()
        }
    }
    
    func onShowFriends() -> CocoaAction {
        return CocoaAction {
            if self.authAPI.SignedInUserID == self.userID {
                let friendVM = UsersTableViewModel(coordinator: self.sceneCoordinator, sourceID: .user(id: self.userID))
                let groupVM = ViewGroupsViewModel(sceneCoordinator: self.sceneCoordinator)
                let vm = RelationshipViewModel(sceneCoordinator: self.sceneCoordinator)
                
                return self.sceneCoordinator.transition(to: Scene.Group.relationship(vm, friendVM, groupVM), type: .modal)
            } else {
                let vm = UsersTableViewModel(coordinator: self.sceneCoordinator, sourceID: .user(id: self.userID))
                return self.sceneCoordinator.transition(to: Scene.User.usersTable(vm), type: .modal)
            }
        }
    }
    
    func onEdit() -> CocoaAction {
        return CocoaAction {
            let vm = EditProfileViewModel(coordinator: self.sceneCoordinator, userID: self.userID, editInfo: self.editProfileInfo.value)
            return self.sceneCoordinator.transition(to: Scene.User.edit(vm), type: .modal)
        }
    }
    
    func onViewBar() -> CocoaAction {
        return CocoaAction {_ in
            if let id = self.barID.value {
                let vm = BarProfileViewModel(coordinator: self.sceneCoordinator, barID: id)
                return self.sceneCoordinator.transition(to: Scene.Bar.profile(vm), type: .modal)
            } else {
                return Observable.empty()
            }           
        }
    }
        
    func onAddFriend() -> CocoaAction {
        return CocoaAction { _ in
            return self.userAPI.requestFriend(userID: self.authAPI.SignedInUserID, friendID: self.userID).do(onNext: {
                self.reloadActionButton.onNext()
            })
        }
    }
    
    func onRemoveFriend() -> CocoaAction {
        return CocoaAction { _ in
            return self.userAPI.removeFriend(userID: self.authAPI.SignedInUserID, friendID: self.userID).do(onNext: {
                self.reloadActionButton.onNext()
            })

        }
    }
    
    func onAcceptRequest() -> CocoaAction {
        return CocoaAction { _ in
            return self.userAPI.acceptFriend(userID: self.authAPI.SignedInUserID, friendID: self.userID).do(onNext: {
                self.reloadActionButton.onNext()
                self.acceptedFriendRequest.onNext()
            })

        }
    }
    
    func onDeclineRequest() -> CocoaAction {
        return CocoaAction { _ in
            return self.userAPI.declineFriend(userID: self.authAPI.SignedInUserID, friendID: self.userID).do(onNext: {
                self.reloadActionButton.onNext()
            })

        }
    }
    
    func onCancelRequest() -> CocoaAction {
        return CocoaAction { _ in
            return self.userAPI.cancelFriend(userID: self.authAPI.SignedInUserID, friendID: self.userID).do(onNext: {
                self.reloadActionButton.onNext()
            })

        }
    }

    func onLikeActivity() -> CocoaAction {
        return CocoaAction {_ in 
            return self.userAPI.likeActivity(userID: self.authAPI.SignedInUserID, activityUserID: self.userID)
        }
    }
    
    func onViewLikers() -> CocoaAction {
        return CocoaAction { _ in
            let vm = UsersTableViewModel(coordinator: self.sceneCoordinator, sourceID: .activity(id: self.userID))
            return self.sceneCoordinator.transition(to: Scene.User.usersTable(vm), type: .modal)
        }
    }

}
