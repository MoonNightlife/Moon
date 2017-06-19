//
//  ContactsViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/16/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import Action
import RxCocoa
import RxSwift
import RxDataSources

typealias SnapshotSectionModel = AnimatableSectionModel<String, UserSnapshot>

struct ContactsViewModel: BackType {
    // Private
    
    // Dependencies
    let sceneCoordinator: SceneCoordinatorType
    
    // Inputs
    
    // Actions
    
    // Outputs
    var usersInContacts: Driver<[SnapshotSectionModel]> {
        return ContactsViewModel.getUsersInContacts().map(ContactsViewModel.userSnapshotsToSnapshotSectionModel).map({ [$0] }).asDriver(onErrorJustReturn: [SnapshotSectionModel(model: "", items: [])])
    }
    
    init(coordinator: SceneCoordinatorType) {
        self.sceneCoordinator = coordinator
        
    }
    
    static func getUsersInContacts() -> Observable<[UserSnapshot]> {
        let userSnapshot = createFakeUsers().map({
            return UserSnapshot(name: $0.firstName!, id: $0.id!, picture: ($0.pics?[0])!)
        })
        return Observable.just(userSnapshot)
    }
    
    static func userSnapshotsToSnapshotSectionModel(snapshots: [UserSnapshot]) -> SnapshotSectionModel {
        return SnapshotSectionModel(model: "Users", items: snapshots)
    }
    
    func onAddFriend(userID: String) -> CocoaAction {
        return CocoaAction {
            print("Add friend")
            return Observable.empty()
        }
    }

}
