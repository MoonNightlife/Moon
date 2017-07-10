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

struct SearchResultsViewModel: ImageNetworkingInjected, NetworkingInjected {
    
    private let bag = DisposeBag()
    var searchText: Observable<String>
    
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
    var searchResults: Observable<[SnapshotSectionModel]> {
        return Observable.combineLatest(searchText, selectedSearchType)
            .flatMapLatest({ (searchText, type) -> Observable<[SnapshotSectionModel]> in
                switch type {
                case .users:
                    return self.userAPI.searchForUser(searchText: searchText).map({
                        return [SnapshotSectionModel.snapshotsToSnapshotSectionModel(withTitle: "Users", snapshots: $0)]
                    })
                case .bars:
                    return self.barAPI.searchForBar(searchText: searchText).map({
                        return [SnapshotSectionModel.snapshotsToSnapshotSectionModel(withTitle: "Bars", snapshots: $0)]
                    })
                    
                }
            })
    }
    
    init(coordinator: SceneCoordinatorType, searchText: BehaviorSubject<String>) {
        sceneCoordinator = coordinator
        
        self.searchText = searchText
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { query in return query.characters.count > 2 }
        
        searchText.subscribe(onNext: {
            print($0)
        })
        .addDisposableTo(bag)
        
    }
    
    func performTransition(index: Int) -> Observable<Void> {
        let selectedSearchResult = Observable.combineLatest(searchResults.asObservable(), selectedSearchType)
        return Observable.just().withLatestFrom(selectedSearchResult).flatMapLatest({ (results, type) -> Observable<Void> in
            // The first section contains the search results
            // That is why we can use results[0], results[1] is reserved for the load more section
            if case let .searchResult(snapshot) = results[0].items[index] {
                switch type {
                case .users:
                    let vm = ProfileViewModel(coordinator: self.sceneCoordinator, userID: snapshot.id ?? "0")
                    return self.sceneCoordinator.transition(to: Scene.User.profile(vm), type: .popover)
                case .bars:
                    let vm = BarProfileViewModel(coordinator: self.sceneCoordinator, barID: snapshot.id ?? "0")
                    return self.sceneCoordinator.transition(to: Scene.Bar.profile(vm), type: .modal)
                }
            } else {
                return Observable.empty()
            }
        })
    }
    
//    func onShowProfile() -> Action<String, Void> {
//        return Action(workFactory: { _ in
//            let vm = ProfileViewModel(coordinator: self.sceneCoordinator)
//            return self.sceneCoordinator.transition(to: Scene.User.profile(vm), type: .popover)
//        })
//    }

}
