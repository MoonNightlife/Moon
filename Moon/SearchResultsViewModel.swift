//
//  SearchResultsViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/11/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import Action

struct SearchResultsViewModel {
    
    private let bag = DisposeBag()
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    
    // Actions
    lazy var onShowResult: Action<Int, Void> = { this in
        return Action(workFactory: { index in
            return this.performTransition(index: index)
        })
    }(self)
    
    lazy var loadMoreResults: CocoaAction = { this in
        return CocoaAction(workFactory: { _ in
            print("Load more results")
            return Observable.empty()
        })
    }(self)
    
    // Inputs
    var selectedSearchType = BehaviorSubject<SearchType>(value: .users)
    
    // Outputs
    let searchResults: Driver<[SearchSectionModel]>!
    
    init(coordinator: SceneCoordinatorType, searchText: BehaviorSubject<String>) {
        sceneCoordinator = coordinator
        
        searchText.subscribe(onNext: {
            print($0)
        })
        .addDisposableTo(bag)
        

        searchResults = Observable.combineLatest(searchText, selectedSearchType)
            .flatMap({ (text, type) -> Observable<[Snapshot]> in
                return SearchResultsViewModel.getSearchResultsFor(text: text, type: type)
                        .map(SearchResultsViewModel.snapshotsToSearchSectionItems)
                        .map(SearchResultsViewModel.sectionItemsToSectionModel)
            })
            .asDriver(onErrorJustReturn: [SearchSectionModel.searchResultsSection(title: "", items: [])])
    
    }
    
    func performTransition(index: Int) -> Observable<Void> {
        let selectedSearchResult = Observable.combineLatest(searchResults.asObservable(), selectedSearchType)
        return Observable.just().withLatestFrom(selectedSearchResult).flatMapLatest({ (results, type) -> Observable<Void> in
            switch type {
            case .users:
                let vm = ProfileViewModel(coordinator: self.sceneCoordinator)
                return self.sceneCoordinator.transition(to: Scene.User.profile(vm), type: .popover)
            case .bars:
                let vm = BarProfileViewModel(coordinator: self.sceneCoordinator)
                return self.sceneCoordinator.transition(to: Scene.Bar.profile(vm), type: .modal)
            }
        })
    }
    

    
    func onShowProfile() -> Action<String, Void> {
        return Action(workFactory: { _ in
            let vm = ProfileViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.User.profile(vm), type: .popover)
        })
    }
    
    
    // MARK: - Helper functions to convert 
    static func snapshotsToSearchSectionItems(snapshots: [Snapshot]) -> [SearchSectionItem] {
        return snapshots.map({
            SearchSectionItem.searchResultItem(snapshot: $0)
        })
    }
    
    static func sectionItemsToSectionModel(items: [SearchSectionItem]) -> [SearchSectionModel] {
        return [SearchSectionModel.searchResultsSection(title: "Results", items: items)]
    }
    
    static func loadMoreSectionModel(withAction: CocoaAction) -> SearchSectionModel {
        return SearchSectionModel.loadMore(title: "Load More", items: [.loadMoreItem(loadAction: withAction)])
    }

}
