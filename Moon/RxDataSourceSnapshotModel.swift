//
//  RxDataSourceSearchModel.swift
//  Moon
//
//  Created by Evan Noble on 6/14/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxDataSources
import SwaggerClient
import Action

enum SnapshotSectionModel {
    case searchResults(title: String, items: [SnapshotSectionItem])
    case loadMore(title: String, items: [SnapshotSectionItem])
}

enum SnapshotSectionItem: IdentifiableType, Equatable {
    
    static func == (lhs: SnapshotSectionItem, rhs: SnapshotSectionItem) -> Bool {
        return lhs.identity == rhs.identity
    }
    
    var identity: String {
        switch self {
        case let .searchResult(snapshot):
            return snapshot.id!
        case .loadMore:
            return "0"
        }
    }
    
    case searchResult(snapshot: Snapshot)
    case loadMore(loadAction: CocoaAction)
}

extension SnapshotSectionModel: AnimatableSectionModelType {
    typealias Item = SnapshotSectionItem
    
    var identity: String {
        switch self {
        case let .searchResults(title, _):
            return title
        case let .loadMore(title, _):
            return title
        }
    }
    
    var items: [SnapshotSectionItem] {
        switch self {
        case let .searchResults(_, items):
            return items.map {$0}
        case let .loadMore(_, items):
            return items.map {$0}
        }
    }
    
    var titles: String {
        switch self {
        case let .searchResults(title, _):
            return title
        case let .loadMore(title, _):
            return title
        }
    }
    
    init(original: SnapshotSectionModel, items: [Item]) {
        switch original {
        case let .searchResults(t, _):
            self = .searchResults(title: t, items: items)
        case let .loadMore(t, _):
            self = .loadMore(title: t, items: items)
        }
    }
    
    private static func snapshotsToSnapshotSectionItem(snapshots: [Snapshot]) -> [SnapshotSectionItem] {
        return snapshots.map({
            return SnapshotSectionItem.searchResult(snapshot: $0)
        })
    }
    
    static func loadMoreSectionModel(withAction: CocoaAction) -> SnapshotSectionModel {
        return SnapshotSectionModel.loadMore(title: "Load More", items: [.loadMore(loadAction: withAction)])
    }
    
    static func snapshotsToSnapshotSectionModel(withTitle: String, snapshots: [Snapshot]) -> SnapshotSectionModel {
        let items = snapshotsToSnapshotSectionItem(snapshots: snapshots)
        return SnapshotSectionModel.searchResults(title: "Results", items: items)
    }
}
