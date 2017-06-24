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

struct SearchResultsViewModel: ImageDownloadType {
    
    private let bag = DisposeBag()
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    var photoService: PhotoService
    
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
    let searchResults: Observable<[SnapshotSectionModel]>
    
    init(coordinator: SceneCoordinatorType, searchText: BehaviorSubject<String>, photoService: PhotoService = KingFisherPhotoService()) {
        sceneCoordinator = coordinator
        self.photoService = photoService
        
        searchText.subscribe(onNext: {
            print($0)
        })
        .addDisposableTo(bag)
        
        searchResults = Observable.empty()
        _ = Observable.combineLatest(searchText, selectedSearchType)
                .flatMapLatest({ (searchText, type) -> Observable<Void> in
                    switch type {
                    case .users: return Observable.empty()
                        //TODO: add user search api call
                        
                    case .bars: return Observable.empty()
                        //TODO: add bar search api call
                    
                    }
                })
    
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

}
