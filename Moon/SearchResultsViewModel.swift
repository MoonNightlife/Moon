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

struct SearchResultsViewModel: ImageNetworkingInjected, NetworkingInjected, StorageNetworkingInjected {
    
    private let bag = DisposeBag()
    var searchText: Observable<String>
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    
    // Actions
    lazy var onShowResult: Action<SearchSnapshotSectionModel.Item, Void> = { this in
        return Action(workFactory: { snap in
            return this.performTransition(snapshotSection: snap)
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
    var showLoadingIndicator = Variable<Bool>(false)
    
    var searchResults: Observable<[SearchSnapshotSectionModel]> {
        return Observable.combineLatest(searchText, selectedSearchType)
            .flatMapLatest({ (searchText, type) -> Observable<[SearchSnapshotSectionModel]> in
                guard !searchText.isEmpty else {
                    return Observable.just([SearchSnapshotSectionModel.snapshotsToSnapshotSectionModel(withTitle: "Users", snapshots: []), SearchSnapshotSectionModel.loadingSectionModel()])
                }
                
                switch type {
                case .users:
                    return self.userAPI.searchForUser(searchText: searchText)
                        .do(onSubscribed: { 
                            self.showLoadingIndicator.value = true
                        }, onDispose: { 
                            self.showLoadingIndicator.value = false
                        })
                        .map({
                            return [SearchSnapshotSectionModel.snapshotsToSnapshotSectionModel(withTitle: "Users", snapshots: $0), SearchSnapshotSectionModel.loadingSectionModel()]
                        })
                case .bars:
                    return self.barAPI.searchForBar(searchText: searchText)
                        .do(onSubscribed: {
                            self.showLoadingIndicator.value = true
                        }, onDispose: {
                            self.showLoadingIndicator.value = false
                        })
                        .map({
                            return [SearchSnapshotSectionModel.snapshotsToSnapshotSectionModel(withTitle: "Bars", snapshots: $0), SearchSnapshotSectionModel.loadingSectionModel()]
                        })
                    
                }
            })
    }
    
    init(coordinator: SceneCoordinatorType, searchText: BehaviorSubject<String>) {
        sceneCoordinator = coordinator
        
        self.searchText = searchText
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }
    
    func performTransition(snapshotSection: SearchSnapshotSectionModel.Item) -> Observable<Void> {
        
        guard case let .searchResult(snap) = snapshotSection, let id = snap.id else {
            return Observable.empty()
        }
        
        let isBar = snap.username == nil ? true : false
        
        if isBar {
            let vm = BarProfileViewModel(coordinator: self.sceneCoordinator, barID: id)
            return self.sceneCoordinator.transition(to: Scene.Bar.profile(vm), type: .modal)
        } else {
            let vm = ProfileViewModel(coordinator: self.sceneCoordinator, userID: id)
            return self.sceneCoordinator.transition(to: Scene.User.profile(vm), type: .popover)
        }
    }
    
    func getProfileImage(id: String) -> Action<Void, UIImage> {
        return Action(workFactory: {_ in
            return self.storageAPI.getProfilePictureDownloadUrlForUser(id: id, picName: "pic1.jpg")
                .errorOnNil()
                .flatMap({
                    self.photoService.getImageFor(url: $0)
                })
                .catchErrorJustReturn(#imageLiteral(resourceName: "DefaultProfilePic"))
        })
    }
}
