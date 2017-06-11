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

struct ContentSuggestionsViewModel {
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    
    // Inputs
    
    // Outputs
    var suggestedFriends: Driver<[UserSearchSection]>!
    var suggestedBars: Driver<[BarSearchSection]>!
    
    init(coordinator: SceneCoordinatorType) {
        sceneCoordinator = coordinator
        
        let activities = createFakeBarActivities()
        let friendSuggestions = activities.map({ activity in
            return UserCell(name: activity.name!, id: activity.userId!, picture: activity.profileImage!)
        })
        
        self.suggestedFriends = Observable.just([UserSearchSection(model: "", items: friendSuggestions)]).asDriver(onErrorJustReturn: [UserSearchSection(model: "", items: [])])
        
        let bars = createTempTopBarData()
        let barSuggestions = bars.map({ bar in
            return BarCell(name: bar.barName, id: "336", picture: bar.imageName)
        })
        
        self.suggestedBars = Observable.just([BarSearchSection(model: "", items: barSuggestions)]).asDriver(onErrorJustReturn: [BarSearchSection(model: "", items: [])])
    }
}
