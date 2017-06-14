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
    //private let userLoadCounter: Variable<Int>
    //private let barLoadCounter: Variable<Int>
    
    // Inputs
    var searchText = BehaviorSubject<String?>(value: nil)
    
    lazy var loadMoreUserResults: CocoaAction = { this in
        return CocoaAction(workFactory: { _ in
            print("Load more user results")
            return Observable.empty()
        })
    }(self)
    
    lazy var loadMoreBarResults: CocoaAction = { this in
        return CocoaAction(workFactory: {
            print("Load more bar results")
            return Observable.empty()
        })
    }(self)
    
    // Outputs
    var searchResults: Driver<[SearchSectionModel]>!
    
    init(coordinator: SceneCoordinatorType) {
        sceneCoordinator = coordinator
        
        searchText.subscribe { (text) in
            print(text)
        }
        .addDisposableTo(bag)
    
        let users = getUserSnapShots().map({SearchSectionModel.searchResultsSection(title: "Users", items: $0)})
        let bars = getBarSnapShots().map({SearchSectionModel.searchResultsSection(title: "Bars", items: $0)})
        let loadMore = SearchSectionModel.loadMore(title: "Load More", items: [.loadMoreItem(loadAction: loadMoreUserResults)])
        
        //let results = Observable.combineLatest(users, bars)
        
        searchResults = searchText
            .withLatestFrom(users)
            .map({
                return [$0, loadMore]
            })
            .asDriver(onErrorJustReturn: [])
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
            return SearchSectionItem.searchResultItem(snapshot: SearchSnapshot(name: bar.barName, id: "336", picture: bar.imageName))
        })
        return Observable.just(bars)
    }

}
