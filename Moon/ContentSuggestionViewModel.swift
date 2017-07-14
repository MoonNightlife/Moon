//
//  ContentSuggestionViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/9/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import RxDataSources

struct ContentSuggestionsViewModel: ImageNetworkingInjected, NetworkingInjected, AuthNetworkingInjected, StorageNetworkingInjected {
    
    // Private
    private let bag = DisposeBag()
    
    // Dependencies
    let sceneCoordinator: SceneCoordinatorType
    
    // Actions
    var reloadSuggestedBars = PublishSubject<Void>()
    var reloadSuggestedFriends = PublishSubject<Void>()
    
    lazy var onShowBar: Action<Snapshot, Void> = { this in
        return Action(workFactory: { snap in
            return Observable.just()
                .map({
                    return snap.id
                })
                .filterNil()
                .map({
                    return BarProfileViewModel(coordinator: this.sceneCoordinator, barID: $0)
                })
                .flatMap({
                    return this.sceneCoordinator.transition(to: Scene.Bar.profile($0), type: .modal)
            })
        })
    }(self)
    
    // Outputs
    var suggestedFriends: Driver<[SearchSection]> {
        return reloadSuggestedFriends.flatMap({ _ in
            return self.userAPI.getSuggestedFriends(userID: self.authAPI.SignedInUserID)
        })
        .map({
            return [SearchSection(model: "Users", items: $0)]
        })
        .asDriver(onErrorJustReturn: [])
    }
    
    var suggestedBars: Driver<[SearchSection]> {
        return reloadSuggestedBars.flatMap({ _ in
            return self.barAPI.getSuggestedBars(region: "Dallas")
        })
            .map({
                return [SearchSection(model: "Bars", items: $0)]
            })
            .asDriver(onErrorJustReturn: [])
    }
    
    init(coordinator: SceneCoordinatorType) {
        self.sceneCoordinator = coordinator
        
    }
    
    func onAddFriend(userID: String) -> CocoaAction {
        return CocoaAction {
            return self.userAPI.requestFriend(userID: self.authAPI.SignedInUserID, friendID: userID)
                .do(onNext: {
                    self.reloadSuggestedFriends.onNext()
                })
        }
    }
    
    func onChangeAttendance(barID: String) -> CocoaAction {
        return CocoaAction {
            print("Go to Bar with id: \(barID)")
            return Observable.empty()
        }
    }
    
    func getProfileImage(id: String) -> Action<Void, UIImage> {
        return Action(workFactory: {_ in
            return self.storageAPI.getProfilePictureDownloadUrlForUser(id: id, picName: "pic1.jpg")
                .errorOnNil()
                .flatMap({
                    self.photoService.getImageFor(url: $0)
                })
                .catchErrorJustReturn(#imageLiteral(resourceName: "DefaultProfilePic"))
        })
    }
    
    func getFirstBarImage(id: String) -> Action<Void, UIImage> {
        return Action(workFactory: {_ in
            return self.storageAPI.getBarPictureDownloadUrlForBar(id: id, picName: "pic1.jpg")
                .filterNil()
                .flatMap({
                    self.photoService.getImageFor(url: $0)
                })
        })
    }
    
    func onShowProfile(userID: String) -> CocoaAction {
        return CocoaAction { _ in
            let vm = ProfileViewModel(coordinator: self.sceneCoordinator, userID: userID)
            return self.sceneCoordinator.transition(to: Scene.User.profile(vm), type: .popover)
        }
    }

}
