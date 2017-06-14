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

enum SearchSectionModel {
    case searchResultsSection(title: String, items: [SearchSectionItem])
    case loadMore(title: String, items: [SearchSectionItem])
}

enum SearchSectionItem {
    case searchResultItem(snapshot: SearchSnapshot)
    case loadMoreItem(loadAction: CocoaAction)
}

extension SearchSectionModel: SectionModelType {
    typealias Item = SearchSectionItem
    
    var items: [SearchSectionItem] {
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
    
    init(original: SearchSectionModel, items: [Item]) {
        switch original {
        case let .searchResultsSection(t, _):
            self = .searchResultsSection(title: t, items: items)
        case let .loadMore(t, _):
            self = .loadMore(title: t, items: items)
        }
    }
}
