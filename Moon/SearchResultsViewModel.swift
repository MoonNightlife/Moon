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
            .flatMap({ (text, type) -> Observable<[SearchSectionModel]> in
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
                let user = results[0]
                let vm = ProfileViewModel(coordinator: self.sceneCoordinator)
                return self.sceneCoordinator.transition(to: Scene.User.profile(vm), type: .popover)
            case .bars:
                let bar = results[0]
                let vm = BarProfileViewModel(coordinator: self.sceneCoordinator)
                return self.sceneCoordinator.transition(to: Scene.Bar.profile(vm), type: .modal)
            }
        })
    }
    
    static func getSearchResultsFor(text: String, type: SearchType) -> Observable<[SearchSnapshot]> {
        switch type {
        case .bars:
            return SearchResultsViewModel.getBars()
        case .users:
            return SearchResultsViewModel.getUsers()
        }
    }
    
    static func snapshotsToSearchSectionItems(snapshots: [SearchSnapshot]) -> [SearchSectionItem] {
        return snapshots.map({
            SearchSectionItem.searchResultItem(snapshot: $0)
        })
    }
    
    static func sectionItemsToSectionModel(items: [SearchSectionItem]) -> [SearchSectionModel] {
        return [SearchSectionModel.searchResultsSection(title: "Results", items: items)]
    }
    
    func loadMoreSectionModel(withAction: CocoaAction) -> SearchSectionModel {
        return SearchSectionModel.loadMore(title: "Load More", items: [.loadMoreItem(loadAction: withAction)])
    }
    
    func getUserSnapShots() -> Observable<[SearchSectionItem]> {
        let activities = createFakeBarActivities()
        let users = activities.map({ activity in
            return SearchSectionItem.searchResultItem(snapshot: SearchSnapshot(name: activity.name!, id: activity.userId!, picture: activity.profileImage!))
        })
        return Observable.just(users)
    }
    
    func getBarSnapShots() -> Observable<[SearchSectionItem]> {
        let fakeBars = createTempTopBarData()
        let bars = fakeBars.map({ bar in
            return SearchSectionItem.searchResultItem(snapshot: SearchSnapshot(name: bar.barName, id: "336", picture: bar.imageURL.absoluteString))
        })
        return Observable.just(bars)
    }
    
    func onShowProfile() -> Action<String, Void> {
        return Action(workFactory: { _ in
            let vm = ProfileViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.User.profile(vm), type: .popover)
        })
    }
    
    static func getBars() -> Observable<[SearchSnapshot]> {
        let bars = createTempTopBarData()
        let barSuggestions = bars.map({ bar in
            return SearchSnapshot(name: bar.barName, id: "336", picture: bar.imageURL.absoluteString)
        })
        return Observable.just(barSuggestions)
    }
    
    static func getUsers() -> Observable<[SearchSnapshot]> {
        let activities = createFakeBarActivities()
        let friendSuggestions = activities.map({ activity in
            return SearchSnapshot(name: activity.name!, id: activity.userId!, picture: activity.profileImage!)
        })
        return Observable.just(friendSuggestions)
    }

}
