//
//  RxDataSourceSearchModel.swift
//  Moon
//
//  Created by Evan Noble on 6/14/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxDataSources
import Action

enum SnapshotSectionModel {
    case searchResultsSection(title: String, items: [SnapshotSectionItem])
    case loadMore(title: String, items: [SnapshotSectionItem])
}

enum SnapshotSectionItem {
    case searchResultItem(snapshot: Snapshot)
    case loadMoreItem(loadAction: CocoaAction)
}

extension SnapshotSectionModel: SectionModelType {
    typealias Item = SnapshotSectionItem
    
    var items: [SnapshotSectionItem] {
        switch self {
        case let .searchResultsSection(_, items):
            return items.map {$0}
        case let .loadMore(_, items):
            return items.map {$0}
        }
    }
    
    var titles: String {
        switch self {
        case let .searchResultsSection(title, _):
            return title
        case let .loadMore(title, _):
            return title
        }
    }
    
    init(original: SnapshotSectionModel, items: [Item]) {
        switch original {
        case let .searchResultsSection(t, _):
            self = .searchResultsSection(title: t, items: items)
        case let .loadMore(t, _):
            self = .loadMore(title: t, items: items)
        }
    }
}
