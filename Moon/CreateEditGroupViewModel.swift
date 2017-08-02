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

class CreateEditGroupViewModel: BackType, NetworkingInjected, AuthNetworkingInjected {
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
            
            this.members.value += [groupMember]
            
            if let groupID = this.groupID, let userID = groupMember.id {
                return this.groupAPI.addUserToGroup(groupID: groupID, userID: userID)
                    .do(onNext: {
                        this.selectedGroupMemberSnapshot.value = nil
                    })
            } else {
                return Observable.just()
                    .do(onNext: {
                        this.selectedGroupMemberSnapshot.value = nil
                    })
            }
        }
    }(self)
    
    lazy var onSave: CocoaAction = { this in
        return Action(enabledIf: this.validGroupName) {_ in
            guard let groupName = this.groupName.value else {
                return Observable.error(GroupError.noGroupName)
            }
            var memberIDStrings = this.members.value.flatMap({
                $0.id
            })
            memberIDStrings.append(this.authAPI.SignedInUserID)
            return this.groupAPI.createGroup(groupName: groupName, members: memberIDStrings)
                .flatMap({
                    return this.preformBackTransition()
                })
        }
    }(self)
    
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
        return CocoaAction {
            print("Leaving Group")
            return Observable.just()
        }
    }()
    
    // MARK: - Inputs
    var groupImage = PublishSubject<UIImage>()
    var groupName = Variable<String?>(nil)
    var friendSearchText = PublishSubject<String?>()
    var selectedFriend = PublishSubject<SearchSnapshotSectionModel.Item>()
    
    // MARK: - Outputs
    var showBackArrow: Bool {
        // If we are creating a group then the groupID will be nil
        // and we have presented the controller modally, so the arrow
        // should be down instead of back
        return groupID != nil
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
            return [GroupMemberSectionModel(header: "Members", items: $0)]
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
    }
    
    func getActionForBottomButton() -> CocoaAction {
        if let groupID = groupID {
            return CocoaAction {
                return self.groupAPI.removeUserFromGroup(groupID: groupID, userID: self.authAPI.SignedInUserID)
            }
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
