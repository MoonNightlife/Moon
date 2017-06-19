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
    private let users = ContentSuggestionsViewModel.getUserSuggections()
    private let bars = ContentSuggestionsViewModel.getBarSuggestions()
    
    // Dependencies
    let sceneCoordinator: SceneCoordinatorType
    var photoService: PhotoService
    
    // Actions
    lazy var onShowUser: Action<Int, Void> = { this in
        return Action(workFactory: { index in
            return this.users.flatMap({ (users) -> Observable<Void> in
                print(users[index].id)
                let vm = ProfileViewModel(coordinator: this.sceneCoordinator)
                return this.sceneCoordinator.transition(to: Scene.User.profile(vm), type: .popover)
            })
        })
    }(self)
    
    lazy var onShowBar: Action<Int, Void> = { this in
        return Action(workFactory: { index in
            return this.bars.flatMap({ (bars) -> Observable<Void> in
                print(bars[index].id)
                let vm = BarProfileViewModel(coordinator: this.sceneCoordinator)
                return this.sceneCoordinator.transition(to: Scene.Bar.profile(vm), type: .modal)
            })
        })
    }(self)
    
    // Outputs
    var suggestedFriends: Driver<[SearchSection]>!
    var suggestedBars: Driver<[SearchSection]>!
    
    init(coordinator: SceneCoordinatorType, photoService: PhotoService = KingFisherPhotoService()) {
        self.sceneCoordinator = coordinator
        self.photoService = photoService
        
        self.suggestedFriends = users.map({ [SearchSection(model: "", items: $0)] }).asDriver(onErrorJustReturn: [SearchSection(model: "", items: [])])
        self.suggestedBars = bars.map({ [SearchSection(model: "", items: $0)] }).asDriver(onErrorJustReturn: [SearchSection(model: "", items: [])])
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
    
    static func getBarSuggestions() -> Observable<[SearchSnapshot]> {
        let bars = createTempTopBarData()
        let barSuggestions = bars.map({ bar in
            return SearchSnapshot(name: bar.barName, id: "336", picture: bar.imageURL.absoluteString)
        })
        return Observable.just(barSuggestions)
    }
    
    static func getUserSuggections() -> Observable<[SearchSnapshot]> {
        let activities = createFakeBarActivities()
        let friendSuggestions = activities.map({ activity in
            return SearchSnapshot(name: activity.name!, id: activity.userId!, picture: activity.profileImage!)
        })
        return Observable.just(friendSuggestions)
    }

}
