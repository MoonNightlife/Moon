//
//  CreateEditGroupViewModel.swift
//  Moon
//
//  Created by Evan Noble on 7/23/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Action

class CreateEditGroupViewModel: BackType, NetworkingInjected, AuthNetworkingInjected, StorageNetworkingInjected, ImageNetworkingInjected {
    // MARK: - Global
    private var groupID: String?
    private let group = Variable<Group?>(nil)
    private var members = Variable<[GroupMemberSnapshot]>([])
    private var friends = Variable<[UserSnapshot]>([])
    private var selectedGroupMemberSnapshot = Variable<GroupMemberSnapshot?>(nil)
    private var validGroupName: Observable<Bool> {
        return self.groupName.asObservable()
            .map({
                if self.groupID == nil {
                    return ValidationUtility.validGroupName(name: $0)
                } else {
                    return true
                }
            })
    }
    var bag = DisposeBag()
    enum GroupError: Error {
        case noGroupName
    }
    
    // MARK: - Dependencies
    var sceneCoordinator: SceneCoordinatorType
    
    // MARK: - Actions
    lazy var onAddUser: Action<Void, Void> = { this in
        return Action {_ in
            guard let groupMember = this.selectedGroupMemberSnapshot.value else {
                return Observable.just()
            }
            
            guard !this.members.value.contains(groupMember) else {
                return Observable.just()
                    .do(onNext: {
                        this.friendSearchText.onNext("")
                        this.selectedGroupMemberSnapshot.value = nil
                    })
            }

            this.members.value += [groupMember]
            
            if let groupID = this.groupID, let userID = groupMember.id {
                return this.groupAPI.addUserToGroup(groupID: groupID, userID: userID)
                    .do(onNext: {
                        this.friendSearchText.onNext("")
                        this.selectedGroupMemberSnapshot.value = nil
                    })
            } else {
                return Observable.just()
                    .do(onNext: {
                        this.friendSearchText.onNext("")
                        this.selectedGroupMemberSnapshot.value = nil
                    })
            }
        }
    }(self)
    
    lazy var updateName: Action<String, Void> = {
        return Action { name in
            if let groupID = self.groupID {
                return self.groupAPI.updateGroupName(groupID: groupID, groupName: name)
            } else {
                return Observable.empty()
            }
        }
    }()
    
    lazy var onSave: CocoaAction = {
        return Action(enabledIf: self.validGroupName) {_ in
            guard let groupName = self.groupName.value else {
                return Observable.error(GroupError.noGroupName)
            }
            var memberIDStrings = self.members.value.flatMap({
                $0.id
            })
            memberIDStrings.append(self.authAPI.SignedInUserID)
            return self.groupAPI.createGroup(groupName: groupName, members: memberIDStrings)
                .flatMap({ groupID -> Observable<Void> in
                    guard let image = self.newGroupImage.value,
                        let imageData = UIImageJPEGRepresentation(image, 0.25) else {
                        return Observable.just()
                    }
                    
                    return self.storageAPI.uploadGroupPictureFrom(data: imageData, forGroup: groupID)
                })
                .flatMap({_ -> Observable<Void> in
                    return self.preformBackTransition()
                })
        }
    }()
    
    lazy var onRemoveUser: Action<String, Void> = { this in
        return Action { userID in
            this.members.value = this.members.value.filter({
                $0.id != userID
            })
            if let groupID = this.groupID {
                return this.groupAPI.removeUserFromGroup(groupID: groupID, userID: userID)
            } else {
                return Observable.just()
            }
        }
    }(self)
    
    lazy var onLeaveGroup: CocoaAction = {
        return CocoaAction {_ in 
            return self.groupAPI.removeUserFromGroup(groupID: self.groupID!, userID: self.authAPI.SignedInUserID)
                .flatMap({
                    return self.sceneCoordinator.pop()
                })
        }
    }()
    
    // MARK: - Inputs
    var groupName = Variable<String?>(nil)
    var friendSearchText = PublishSubject<String?>()
    var selectedFriend = PublishSubject<SearchSnapshotSectionModel.Item>()
    var newGroupImage = Variable<UIImage?>(nil)
    
    // MARK: - Outputs
    var showBackArrow: Bool {
        // If we are creating a group then the groupID will be nil
        // and we have presented the controller modally, so the arrow
        // should be down instead of back
        return groupID != nil
        
    }
    
    var showNameErrorMessage: Observable<Bool> {
        return groupName.asObservable().filterNil().skip(1).map(ValidationUtility.validGroupName).map(!)
    }
    
    var bottomButtonStyle: CreateEditGroupBottomButtonType {
        if groupID == nil {
            return .save
        } else {
            return .leave
        }
    }
    
    var displayUsers: Observable<[GroupMemberSectionModel]> {
        return members.asObservable().map({
            let filteredSnapshots = $0.filter({
                // Remove the id of the signed in user. 
                // If the signed in user wants to leave the group, he hits the leave button
                $0.id != self.authAPI.SignedInUserID
            })
            return [GroupMemberSectionModel(header: "Members", items: filteredSnapshots)]
        })
    }
    
    var friendSearchResults: Observable<[SearchSnapshotSectionModel]> {
        return Observable.combineLatest(friends.asObservable(), friendSearchText.filterNil())
            .map { (friends: [UserSnapshot], searchText: String) -> [UserSnapshot] in
                return friends.filter({ friend -> Bool in
                    return friend.name?.lowercased().contains(searchText.lowercased()) ?? false
                })
            }
            .map({ (snapshots: [UserSnapshot]) -> [SearchSnapshotSectionModel] in
                return [SearchSnapshotSectionModel.snapshotsToSnapshotSectionModel(withTitle: "Users", snapshots: snapshots)]
            })
    }
    
    var selectedFriendText: Observable<String?> {
        return selectedGroupMemberSnapshot.asObservable()
            .map({
                $0?.name
            })
    }
    
    var groupNameText: Observable<String?> {
        return group.asObservable().filterNil()
            .map({
                $0.name
            })
    }
    
    var groupImage: Observable<UIImage> {
        if let groupID = self.groupID {
            return self.storageAPI.getGroupPictureDownloadURLForGroup(id: groupID)
                .errorOnNil()
                .flatMap({
                    self.photoService.getImageFor(url: $0)
                })
                .catchErrorJustReturn(#imageLiteral(resourceName: "DefaultGroupPic"))
        } else {
            return Observable.just(#imageLiteral(resourceName: "DefaultGroupPic"))
        }
    }

    init(sceneCoordinator: SceneCoordinatorType, groupID: String?) {
        self.sceneCoordinator = sceneCoordinator
        self.groupID = groupID
        
        if let groupID = groupID {
            self.groupAPI.getGroupMembers(groupID: groupID).bind(to: members).addDisposableTo(bag)
            self.groupAPI.getGroup(groupID: groupID).bind(to: group).addDisposableTo(bag)
        } else {
            
        }
        selectedFriend
            .map { searchResult -> GroupMemberSnapshot? in
                if case let .searchResult(snapshot) = searchResult {
                    return GroupMemberSnapshot(snapshot: snapshot)
                } else {
                    return nil
                }
            }
            .bind(to: selectedGroupMemberSnapshot)
            .addDisposableTo(bag)
        
        self.userAPI.getFriends(userID: self.authAPI.SignedInUserID).bind(to: friends).addDisposableTo(bag)
        
        self.newGroupImage
            .asObservable()
            .filterNil()
            .map({
                UIImageJPEGRepresentation($0, 0.25)
            })
            .filterNil()
            .flatMap({ imageData -> Observable<Void> in
                guard let groupID = self.groupID else {
                    return Observable.empty()
                }
                return self.storageAPI.uploadGroupPictureFrom(data: imageData, forGroup: groupID)
            })
            .subscribe()
            .addDisposableTo(bag)
    }
    
    func getActionForBottomButton() -> CocoaAction {
        if groupID != nil {
            return self.onLeaveGroup
        } else {
            return self.onSave
        }
        
    }
    
    func onBack() -> CocoaAction {
        return CocoaAction {
          return self.preformBackTransition()
        }
    }
    
    func preformBackTransition() -> Observable<Void> {
        if self.groupID == nil {
        // If we are creating a group then the view was presented modally
        // and can be dismissed noramlly
        return self.sceneCoordinator.pop()
        } else {
        // If we are editing a scene then it was presenting by a navigation controller.
        // To only pop off the edit scene and not dismiss the whole nav view controller
        // we must use this other method, because the navigation controller was presented modally
        return self.sceneCoordinator.popVCOffNavStack(animated: true)
        }
    }
    
}
