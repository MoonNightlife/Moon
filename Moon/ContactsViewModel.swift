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
import SwaggerClient

typealias SnapshotSectionModel = AnimatableSectionModel<String, UserSnapshot>

struct ContactsViewModel: BackType, ImageDownloadType {
    // Private
    let bag = DisposeBag()
    
    // Dependencies
    let sceneCoordinator: SceneCoordinatorType
    let contactService: ContactService
    var photoService: PhotoService

    // Actions
    var checkContactAccess: Action<Void, Bool>
    
    // Outputs
    var UserInContacts: Observable<[SnapshotSectionModel]>
    
    init(coordinator: SceneCoordinatorType, contactService: ContactService = ContactService(), photoService: PhotoService = KingFisherPhotoService()) {
        self.sceneCoordinator = coordinator
        self.contactService = contactService
        self.photoService = photoService
        
        checkContactAccess = Action(workFactory: {_ in 
            return contactService.requestForAccess()
        })
        
        UserInContacts = checkContactAccess.elements.filter({ $0 }).flatMap({ _ -> Observable<[String]> in
                return ContactsViewModel.getPhoneNumbers(service: contactService)
            })
            .flatMap({
                ContactsViewModel.getUsersWith(phoneNumbers: $0)
            })
            .map({
                return [ContactsViewModel.userSnapshotsToSnapshotSectionModel(snapshots: $0)]
            })
        
    }
    
    static func getPhoneNumbers(service: ContactService) -> Observable<[String]> {
        return service.getContacts().map({
            return $0.flatMap({
                SinchService.formatPhoneNumberForStorageFrom(string: $0, countryCode: CountryCode.US)
            })
        })
    }
    
    static func getUsersWith(phoneNumbers: [String]) -> Observable<[UserSnapshot]> {
//        let userSnapshot = createFakeUsers().map({
//            return UserSnapshot(name: $0.firstName!, id: $0.id!, picture: #imageLiteral(resourceName: "pic1.jpg"))
//        })
//        return Observable.just(userSnapshot)
        return Observable.empty()
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
