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

class EditProfileViewModel: BackType, StorageNetworkingInjected, ImageNetworkingInjected, NetworkingInjected, AuthNetworkingInjected {
    
    // Local
    private let bag = DisposeBag()
    var validInputs: Observable<Bool> {
        return Observable.combineLatest(firstName.asObservable(), lastName.asObservable())
            .map { first, last -> Bool in
                return ValidationUtility.validName(firstName: first, lastName: last)
        }

    }
    
    // Dependencies
    var sceneCoordinator: SceneCoordinatorType
    
    // Output
    var profilePictures = Variable<[UIImage]>([])
    var bioText: Observable<String?>
    var firstNameText: Observable<String?>
    var lastNameText: Observable<String?>
    
    // Input
    var bio = Variable<String?>(nil)
    var firstName = Variable<String?>(nil)
    var lastName = Variable<String?>(nil)
    
    init(coordinator: SceneCoordinatorType, userID: String, photoService: PhotoService = KingFisherPhotoService(), editInfo: EditProfileInfo) {
        sceneCoordinator = coordinator
        
        bioText = bio.asObservable().skip(1).startWith(editInfo.bio)
        firstNameText = firstName.asObservable().skip(1).startWith(editInfo.firstName)
        lastNameText = lastName.asObservable().skip(1).startWith(editInfo.lastName)
        
        let defaultImageArray = [#imageLiteral(resourceName: "AddMorePicsIcon"), #imageLiteral(resourceName: "AddMorePicsIcon"), #imageLiteral(resourceName: "AddMorePicsIcon"), #imageLiteral(resourceName: "AddMorePicsIcon"), #imageLiteral(resourceName: "AddMorePicsIcon"), #imageLiteral(resourceName: "AddMorePicsIcon")]
        Observable.of(["pic1.jpg", "pic2.jpg", "pic3.jpg", "pic4.jpg", "pic5.jpg", "pic6.jpg"])
            .flatMap({ [unowned self] picNames in
                return Observable.from(picNames).flatMap({
                    return self.storageAPI.getProfilePictureDownloadUrlForUser(id: self.authAPI.SignedInUserID, picName: $0)
                        .catchErrorJustReturn(nil)
                        .filterNil()
                        .flatMap({ [unowned self] url in
                            return self.photoService.getImageFor(url: url)
                        })
                })
            }).toArray()
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
    
        //TODO: Validate the bio text length
    }
    
    private func prepareArrayForUpload(photoArray: [UIImage]) -> [String: Data] {
        var uploadDic = [String: Data]()
        
        let uploadImages = photoArray.filter({
            $0 != #imageLiteral(resourceName: "AddMorePicsIcon")
        })
        
        let uploadData = uploadImages.map({
            return UIImageJPEGRepresentation($0, 0.25)
        }).filter({ $0 != nil })
        
        for (index, element) in uploadData.enumerated() {
            uploadDic["pic\(index + 1).jpg"] = element!
        }
        
        return uploadDic
    }
    
    private func uploadImages() -> Observable<[Void]> {
        let uploads = prepareArrayForUpload(photoArray: self.profilePictures.value).map({
            return self.storageAPI.uploadProfilePictureFrom(data: $1, forUser: self.authAPI.SignedInUserID, imageName: $0)
        })
        
        return Observable.zip(uploads)
    }

    func onSave() -> CocoaAction {
        return CocoaAction(enabledIf: self.validInputs, workFactory: {
            let profile = UserProfile()
            profile.firstName = self.firstName.value
            profile.lastName = self.lastName.value
            profile.bio = self.bio.value
            profile.id = self.authAPI.SignedInUserID
            
            return self.userAPI.update(profile: profile)
                .flatMap({
                    return self.uploadImages()
                })
                .flatMap({ _ in
                    return self.sceneCoordinator.pop()
                })
        })
    }
}
