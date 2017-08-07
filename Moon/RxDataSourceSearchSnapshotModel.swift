//
//  RxDataSourceSearchSnapshotModel.swift
//  Moon
//
//  Created by Evan Noble on 6/14/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxDataSources
import Action

enum SearchSnapshotSectionModel {
    case searchResults(title: String, items: [SearchSnapshotSectionItem])
    case loadMore(title: String, items: [SearchSnapshotSectionItem])
    case loading(title: String, items: [SearchSnapshotSectionItem])
}

enum SearchSnapshotSectionItem: IdentifiableType, Equatable {
    
    static func == (lhs: SearchSnapshotSectionItem, rhs: SearchSnapshotSectionItem) -> Bool {
        return lhs.identity == rhs.identity
    }
    
    var identity: String {
        switch self {
        case let .searchResult(snapshot):
            return snapshot.id!
        case .loadMore:
            return "0"
        case .loading:
            return "1"
        case let .contact(name, phoneNumber):
            return name + phoneNumber
        case .algoliaLogo:
            return "2"
        }
    }
    
    case searchResult(snapshot: Snapshot)
    case contact(name: String, phoneNumber: String)
    case loadMore(loadAction: CocoaAction)
    case loading
    case algoliaLogo
}

extension SearchSnapshotSectionModel: AnimatableSectionModelType {
    typealias Item = SearchSnapshotSectionItem
    
    var identity: String {
        switch self {
        case let .searchResults(title, _):
            return title
        case let .loadMore(title, _):
            return title
        case let .loading(title, _):
            return title
            
        }
    }
    
    var items: [SearchSnapshotSectionItem] {
        switch self {
        case let .searchResults(_, items):
            return items.map {$0}
        case let .loadMore(_, items):
            return items.map {$0}
        case let .loading(_, items):
            return items.map {$0}
        }
    }
    
    var titles: String {
        switch self {
        case let .searchResults(title, _):
            return title
        case let .loadMore(title, _):
            return title
        case let .loading(title, _):
            return title
        }
    }
    
    init(original: SearchSnapshotSectionModel, items: [Item]) {
        switch original {
        case let .searchResults(t, _):
            self = .searchResults(title: t, items: items)
        case let .loadMore(t, _):
            self = .loadMore(title: t, items: items)
        case let .loading(t, _):
            self = .loading(title: t, items: items)
        }
        
    }
    
    private static func snapshotsToSnapshotSectionItem(snapshots: [Snapshot]) -> [SearchSnapshotSectionItem] {
        return snapshots.map({
            return SearchSnapshotSectionItem.searchResult(snapshot: $0)
        })
    }
    
    static func loadMoreSectionModel(withAction: CocoaAction) -> SearchSnapshotSectionModel {
        return SearchSnapshotSectionModel.loadMore(title: "Load More", items: [.loadMore(loadAction: withAction)])
    }
    
    static func loadingSectionModel() -> SearchSnapshotSectionModel {
        return SearchSnapshotSectionModel.loading(title: "Loading", items: [.loading])
    }
    
    static func algoliaSectionModel() -> SearchSnapshotSectionModel {
        return SearchSnapshotSectionModel.searchResults(title: "", items: [.algoliaLogo])
    }
    
    static func snapshotsToSnapshotSectionModel(withTitle: String, snapshots: [Snapshot]) -> SearchSnapshotSectionModel {
        let items = snapshotsToSnapshotSectionItem(snapshots: snapshots)
        return SearchSnapshotSectionModel.searchResults(title: withTitle, items: items)
    }
    
    static func contactsToSearchResultsSectionModel(title: String, contacts: [(name: String, phoneNumber: String)]) -> SearchSnapshotSectionModel {
        let items = contacts.map({
            return SearchSnapshotSectionItem.contact(name: $0.0, phoneNumber: $0.1)
        })
        return SearchSnapshotSectionModel.searchResults(title: title, items: items)
    }
}
