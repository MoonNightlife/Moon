//
//  GroupActivityViewModel.swift
//  Moon
//
//  Created by Evan Noble on 7/23/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import Action
import RxSwift

struct GroupActivityViewModel: BackType, NetworkingInjected {
    // MARK: - Global
    private let bag = DisposeBag()
    private let groupID: String
    private var group = Variable<Group?>(nil)
    
    // MARK: - Dependencies
    var sceneCoordinator: SceneCoordinatorType
    
    // MARK: - Actions
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    var groupName: Observable<String?> {
        return group.asObservable().filterNil().map { $0.name }
    }
    
    var barName: Observable<String?> {
        return group.asObservable().filterNil().map { $0.activityInfo?.barName }
    }
    
    var displayUsers: Observable<[SnapshotSectionModel]> {
        //TODO: Change to only return members that are going
        return self.groupAPI.getGroupMembers(groupID: groupID)
            .map({
                return [SnapshotSectionModel(header: "Users", items: $0)]
            })
    }
    
    var groupPicture: Observable<UIImage> {
        return Observable.just(#imageLiteral(resourceName: "DefaultGroupPic"))
    }
    
    init(sceneCoordinator: SceneCoordinatorType, groupID: String) {
        self.sceneCoordinator = sceneCoordinator
        self.groupID = groupID
        
        self.groupAPI.getGroup(groupID: groupID).bind(to: group).addDisposableTo(bag)
    }
    
    func onShowProfile() -> CocoaAction {
        return CocoaAction {
            //TODO: show profile
            return Observable.just()
        }
    }
    
    func onLikeUserActivity() -> CocoaAction {
        return CocoaAction {
            //TODO: like user activity
            return Observable.just()
        }
    }
    
    func onViewUserActivityLikes() -> CocoaAction {
        return CocoaAction {
            //TODO: view likers
            return Observable.just()
        }
    }
    
    func onLikeGroupActivity() -> CocoaAction {
        //TODO: Like group activity
        return CocoaAction {
            return Observable.just()
        }
    }
    
    func onViewGroupLikers() -> CocoaAction {
        return CocoaAction {
            //TODO: Implement functionality
            return Observable.just()
        }
    }
    
    func onViewBar() -> CocoaAction {
        //TODO: view bar profile
        return CocoaAction {
            return Observable.just()
        }
    }
}
