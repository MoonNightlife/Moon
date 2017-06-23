//
//  ProfileViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import RxOptional

struct ProfileViewModel {
    
    // Private
    private let bag = DisposeBag()

    // Dependecies
    private let scenceCoordinator: SceneCoordinatorType
    
    // Inputs
    
    // Outputs
    var username: Observable<String>
    var fullName: Observable<String>
    var bio: Observable<String>
    var activityBarName: Observable<String>
    var profilePictures = Variable<[UIImage]>([])
    
    init(coordinator: SceneCoordinatorType, userAPI: UserAPIType = UserAPIController(), photoService: PhotoService = KingFisherPhotoService()) {
        self.scenceCoordinator = coordinator
        
        let userProfile = userAPI.getUserProfile(userID: "01")
        
        username = userProfile.map({ $0.username }).replaceNilWith("No Username").catchErrorJustReturn("Fake Username")
        fullName = userProfile.map({
            let firstName = $0.firstName ?? "No First Name"
            let lastName = $0.lastName ?? "No Last Name"
            return firstName + " " + lastName
        }).catchErrorJustReturn("Fake Name")
        //TODO: Add bio when api adds property to model
        bio = userProfile.map({ _ in "No Bio" }).catchErrorJustReturn("Fake Bio")
        activityBarName = userProfile.map({ $0.activity }).filterNil().map({ $0.barName }).replaceNilWith("No Plans").catchErrorJustReturn("Fake Planr")
        
        userProfile.map({ $0.profilePics }).filterNil().flatMap({ pictureURLs in
            return Observable.from(pictureURLs).flatMap({
                return photoService.getImageFor(url: baseURL.appendingPathComponent($0))
            }).toArray()
        }).catchErrorJustReturn([]).bind(to: profilePictures).addDisposableTo(bag)
    }
    
    func onDismiss() -> CocoaAction {
        return CocoaAction {
            return self.scenceCoordinator.pop()
        }
    }
    
    func onShowFriends() -> CocoaAction {
        return CocoaAction {
            let vm = UsersTableViewModel(coordinator: self.scenceCoordinator)
            return self.scenceCoordinator.transition(to: Scene.User.usersTable(vm), type: .modal)
        }
    }
    
    func onEdit() -> CocoaAction {
        return CocoaAction {
            let vm = EditProfileViewModel(coordinator: self.scenceCoordinator)
            return self.scenceCoordinator.transition(to: Scene.User.edit(vm), type: .modal)
        }
    }
    
}
