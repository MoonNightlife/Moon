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
            let vm = ProfileViewModel(coordinator: this.sceneCoordinator)
            return this.sceneCoordinator.transition(to: Scene.User.profile(vm), type: .popover)
        })
    }(self)
    
    lazy var onShowBar: Action<Int, Void> = { this in
        return Action(workFactory: { index in
            let vm = BarProfileViewModel(coordinator: this.sceneCoordinator)
            return this.sceneCoordinator.transition(to: Scene.Bar.profile(vm), type: .modal)
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
