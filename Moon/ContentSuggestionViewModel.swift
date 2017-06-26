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

struct ContentSuggestionsViewModel: ImageDownloadType {
    
    // Private
    private let bag = DisposeBag()
    
    // Dependencies
    let sceneCoordinator: SceneCoordinatorType
    var photoService: PhotoService
    
    // Actions
    lazy var onShowUser: Action<Int, Void> = { this in
        return Action(workFactory: { index in
            return Observable.just().withLatestFrom(this.suggestedFriends.asObservable())
                .map({ searchSection in
                    return ProfileViewModel(coordinator: this.sceneCoordinator, userID: searchSection[0].items[index]._id ?? "0")
                })
                .flatMap({
                    return this.sceneCoordinator.transition(to: Scene.User.profile($0), type: .popover)
                })
        })
    }(self)
    
    lazy var onShowBar: Action<Int, Void> = { this in
        return Action(workFactory: { index in
            return Observable.just().withLatestFrom(this.suggestedFriends.asObservable())
                .map({ searchSection in
                    return BarProfileViewModel(coordinator: this.sceneCoordinator, barID: searchSection[0].items[index]._id ?? "0")
                })
                .flatMap({
                    return this.sceneCoordinator.transition(to: Scene.Bar.profile($0), type: .modal)
            })
        })
    }(self)
    
    // Outputs
    var suggestedFriends: Driver<[SearchSection]>!
    var suggestedBars: Driver<[SearchSection]>!
    
    init(coordinator: SceneCoordinatorType, photoService: PhotoService = KingFisherPhotoService()) {
        self.sceneCoordinator = coordinator
        self.photoService = photoService

    }
    
    func onAddFriend(userID: String) -> CocoaAction {
        return CocoaAction {
            print("Add Friend \(userID)")
            return Observable.empty()
        }
    }
    
    func onChangeAttendance(barID: String) -> CocoaAction {
        return CocoaAction {
            print("Go to Bar with id: \(barID)")
            return Observable.empty()
        }
    }

}
