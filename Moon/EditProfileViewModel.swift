//
//  EditProfileViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/18/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import Action
import RxSwift

struct EditProfileViewModel: BackType, StorageNetworkingInjected, ImageNetworkingInjected, NetworkingInjected, AuthNetworkingInjected {
    
    // Local
    private let bag = DisposeBag()
    var validInputs: Observable<Bool>!
    
    // Dependencies
    var sceneCoordinator: SceneCoordinatorType
    
    // Output
    var profilePictures = Variable<[UIImage]>([])
    
    // Input
    var bio = Variable<String?>(nil)
    var firstName = Variable<String?>(nil)
    var lastName = Variable<String?>(nil)
    
    init(coordinator: SceneCoordinatorType, userID: String, photoService: PhotoService = KingFisherPhotoService()) {
        sceneCoordinator = coordinator
        
        let defaultImageArray = [#imageLiteral(resourceName: "AddMorePicsIcon"), #imageLiteral(resourceName: "AddMorePicsIcon"), #imageLiteral(resourceName: "AddMorePicsIcon"), #imageLiteral(resourceName: "AddMorePicsIcon"), #imageLiteral(resourceName: "AddMorePicsIcon"), #imageLiteral(resourceName: "AddMorePicsIcon")]
        storageAPI.getProfilePictureDownloadUrlForUser(id: userID).filterNil()
            .flatMap({
                return photoService.getImageFor(url: $0)
            })
            .toArray()
            .map({
                var temp = $0
                for _ in ($0.count..<6) {
                    temp.append(#imageLiteral(resourceName: "AddMorePicsIcon"))
                }
                return temp
            })
            .catchErrorJustReturn(defaultImageArray)
            .startWith(defaultImageArray)
            .bind(to: profilePictures).addDisposableTo(bag)
        
        let validName = Observable.combineLatest(firstName.asObservable(), lastName.asObservable())
            .map {
                ValidationUtility.validName(firstName: $0, lastName: $1)
            }
        
        //TODO: Validate the bio text length
        
        self.validInputs = validName
    }
    
    func onSave() -> CocoaAction {
        return CocoaAction(enabledIf: self.validInputs, workFactory: {
            let profile = UserProfile()
            profile.firstName = self.firstName.value
            profile.lastName = self.lastName.value
            profile.bio = self.bio.value
            profile.id = self.authAPI.SignedInUserID
            
            return self.userAPI.update(profile: profile).flatMap({
                return self.sceneCoordinator.pop()
            })
        })
    }
}
