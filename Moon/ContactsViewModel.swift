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

class ContactsViewModel: BackType, ImageNetworkingInjected, NetworkingInjected, PhoneNumberValidationInjected, StorageNetworkingInjected, AuthNetworkingInjected {
    // Private
    let bag = DisposeBag()
    var usersInContactsVariable = Variable<[UserSnapshot]>([])
    
    // Dependencies
    let sceneCoordinator: SceneCoordinatorType
    let contactService: ContactUtility

    // Actions
    var checkContactAccess: Action<Void, Bool>
    
    lazy var onShowUser: Action<SnapshotSectionModel.Item, Void> = {
        return Action { model in
            
            return Observable.just()
                .map({ _ -> String? in
                    if case let .searchResult(snapshot) = model {
                        return snapshot.id
                    } else {
                        return nil
                    }
                })
                .filterNil()
                .map({ id -> ProfileViewModel in
                    return ProfileViewModel(coordinator: self.sceneCoordinator, userID: id)
                })
                .flatMap({
                    return self.sceneCoordinator.transition(to: Scene.User.profile($0), type: .popover)
                })
        }
    }()
    
    // Outputs
    var usersInContacts: Observable<[SnapshotSectionModel]>!
    var showLoadingIndicator = Variable(false)
    
    init(coordinator: SceneCoordinatorType, contactService: ContactUtility = ContactUtility()) {
        self.sceneCoordinator = coordinator
        self.contactService = contactService
        
        checkContactAccess = Action(workFactory: {_ in 
            return contactService.requestForAccess()
        })
        
        let contacts = checkContactAccess.elements.filter({ $0 }).flatMap({ _ -> Observable<[(String, String)]> in
            return self.getPhoneNumbers(service: self.contactService)
        })
        
        contacts
            .do(onNext: { _ in
                self.showLoadingIndicator.value = true
            })
            .map({
                return $0.map({
                    return $0.1
                })
            })
            .flatMap({
                return self.userAPI.getUserBy(phoneNumbers: $0, userID: self.authAPI.SignedInUserID)
            })
            .catchErrorJustReturn([])
            .map({
                return $0.filter({
                    $0.id != self.authAPI.SignedInUserID
                })
            })
            .do(onNext: { _ in
                self.showLoadingIndicator.value = false
            })
            .bind(to: usersInContactsVariable)
            .addDisposableTo(bag)
        
        let usersInContactsSectionModel = usersInContactsVariable.asObservable()
            .map({
                SnapshotSectionModel.snapshotsToSnapshotSectionModel(withTitle: "Users In Contacts", snapshots: $0)
            })
        
        let contactsSectionModel = contacts
            .map({
                return $0.flatMap({
                    if let formattedPhoneNumber = self.phoneNumberService.formatPhoneNumberForGuiFrom(string: $0.1, countryCode: CountryCode.US) {
                        return ($0.0, formattedPhoneNumber)
                    } else {
                        return nil
                    }
                })
            })
            .map({
                SnapshotSectionModel.contactsToSearchResultsSectionModel(title: "Invite By Phone Number", contacts: $0)
            })
        
        usersInContacts = Observable.combineLatest([usersInContactsSectionModel, contactsSectionModel])
    }
    
    func getPhoneNumbers(service: ContactUtility) -> Observable<[(String, String)]> {
        return service.getContacts().map({
            return $0.flatMap({
                if let formattedPhoneNumber = self.phoneNumberService.formatPhoneNumberForStorageFrom(string: $0.phoneNumber, countryCode: CountryCode.US) {
                    return ($0.name, formattedPhoneNumber)
                } else {
                    return nil
                }
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
        return CocoaAction { [unowned self] _ in
            return self.userAPI.requestFriend(userID: self.authAPI.SignedInUserID, friendID: userID)
                .do(onNext: {
                    self.usersInContactsVariable.value = self.usersInContactsVariable.value.filter({
                        $0.id != userID
                    })
                })
        }
    }
    
    func getProfileImage(id: String) -> Action<Void, UIImage> {
        return Action(workFactory: { [unowned self] _ in
            return self.storageAPI.getProfilePictureDownloadUrlForUser(id: id, picName: "pic1.jpg")
                .errorOnNil()
                .flatMap({
                    self.photoService.getImageFor(url: $0)
                })
                .catchErrorJustReturn(#imageLiteral(resourceName: "DefaultProfilePic"))
        })
    }
 
}
