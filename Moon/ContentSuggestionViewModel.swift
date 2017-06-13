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
    var suggestedFriends: Driver<[SearchSection]>!
    var suggestedBars: Driver<[SearchSection]>!
    
    init(coordinator: SceneCoordinatorType) {
        sceneCoordinator = coordinator
        
        let activities = createFakeBarActivities()
        let friendSuggestions = activities.map({ activity in
            return SearchSnapshot(name: activity.name!, id: activity.userId!, picture: activity.profileImage!)
        })
        
        self.suggestedFriends = Observable.just([SearchSection(model: "", items: friendSuggestions)]).asDriver(onErrorJustReturn: [SearchSection(model: "", items: [])])
        
        let bars = createTempTopBarData()
        let barSuggestions = bars.map({ bar in
            return SearchSnapshot(name: bar.barName, id: "336", picture: bar.imageName)
        })
        
        self.suggestedBars = Observable.just([SearchSection(model: "", items: barSuggestions)]).asDriver(onErrorJustReturn: [SearchSection(model: "", items: [])])
    }
}
