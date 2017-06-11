//
//  SearchViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/11/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation

struct SearchViewModel {
    // Dependencies
    let sceneCoordinator: SceneCoordinatorType
    
    // Inputs
    
    // Outputs
    
    init(coordinator: SceneCoordinatorType) {
        sceneCoordinator = coordinator
    }
    
    func createContentSuggestedViewModel() -> ContentSuggestionsViewModel {
        return ContentSuggestionsViewModel(coordinator: sceneCoordinator)
    }
    
    func createSearchResultsViewModel() -> SearchResultsViewModel {
        return SearchResultsViewModel(coordinator: sceneCoordinator)
    }
}
