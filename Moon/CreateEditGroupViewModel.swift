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

struct CreateEditGroupViewModel: BackType, NetworkingInjected {
    // MARK: - Global
    var groupID: String?
    var members = Variable<[GroupMemberSnapshot]>([])
    var bag = DisposeBag()
    
    // MARK: - Dependencies
    var sceneCoordinator: SceneCoordinatorType
    
    // MARK: - Actions
    lazy var onAddUser: Action<String, Void> = {
        return Action {
            print("Add user \($0)")
            return Observable.just()
        }
    }()
    
    lazy var onRemoveUser: Action<String, Void> = {
        return Action {
            print("Remove user \($0)")
            return Observable.just()
        }
    }()
    
    lazy var onLeaveGroup: CocoaAction = {
        return CocoaAction {
            print("Leaving Group")
            return Observable.just()
        }
    }()
    
    // MARK: - Inputs
    var groupImage = PublishSubject<UIImage>()
    var groupName = PublishSubject<String>()
    var friendSearchText = PublishSubject<String>()
    
    // MARK: - Outputs
    var showBackArrow: Bool {
        // If we are creating a group then the groupID will be nil
        // and we have presented the controller modally, so the arrow
        // should be down instead of back
        return groupID != nil
    }
    
    var displayUsers: Observable<[GroupMemberSectionModel]> {
        return members.asObservable().map({
            return [GroupMemberSectionModel(header: "Members", items: $0)]
        })
    }

    init(sceneCoordinator: SceneCoordinatorType, groupID: String?) {
        self.sceneCoordinator = sceneCoordinator
        self.groupID = groupID
        
        self.groupAPI.getGroupMembers(groupID: "-KptJGIkA3_u5IASSFmn").bind(to: members).addDisposableTo(bag)
    }
    
    func onBack() -> CocoaAction {
        return CocoaAction {
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
    
}
