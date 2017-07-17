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

struct ContactsViewModel: BackType, ImageNetworkingInjected, NetworkingInjected, PhoneNumberValidationInjected {
    // Private
    let bag = DisposeBag()
    
    // Dependencies
    let sceneCoordinator: SceneCoordinatorType
    let contactService: ContactUtility

    // Actions
    var checkContactAccess: Action<Void, Bool>
    
    // Outputs
    var UserInContacts: Observable<[SnapshotSectionModel]> {
        return checkContactAccess.elements.filter({ $0 }).flatMap({ _ -> Observable<[String]> in
            return self.getPhoneNumbers(service: self.contactService)
            })
            .flatMap({_ in
                //TODO: get users with phonenumbers
                return Observable.empty()
            })
            .map({
                return [SnapshotSectionModel.snapshotsToSnapshotSectionModel(withTitle: "Users", snapshots: $0)]
            })
    }
    
    init(coordinator: SceneCoordinatorType, contactService: ContactUtility = ContactUtility()) {
        self.sceneCoordinator = coordinator
        self.contactService = contactService
        
        checkContactAccess = Action(workFactory: {_ in 
            return contactService.requestForAccess()
        })
        
        
    }
    
    func getPhoneNumbers(service: ContactUtility) -> Observable<[String]> {
        return service.getContacts().map({
            return $0.flatMap({
                self.phoneNumberService.formatPhoneNumberForStorageFrom(string: $0, countryCode: CountryCode.US)
            })
        })
    }

    static func snapshotsToSnapshotSectionItem(snapshots: [Snapshot]) -> [SnapshotSectionItem] {
        return snapshots.map({
            return SnapshotSectionItem.searchResult(snapshot: $0)
        })
    }
    
    static func snapshotsToSnapshotSectionModel(sectionItems: [SnapshotSectionItem]) -> SnapshotSectionModel {
        return SnapshotSectionModel.searchResults(title: "Results", items: sectionItems)
    }
    
    func onAddFriend(userID: String) -> CocoaAction {
        return CocoaAction {
            print("Add friend")
            return Observable.empty()
        }
    }

}
