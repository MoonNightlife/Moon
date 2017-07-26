//
//  RxDataSourceUserModel.swift
//  Moon
//
//  Created by Evan Noble on 6/21/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxDataSources
import Action

enum UserSectionModel {
    case friendsSection(title: String, items: [UserSectionItem])
    case friendRequestsSection(title: String, items: [UserSectionItem])
}

enum UserSectionItem {

    case friend(snapshot: Snapshot)
    case friendRequest(snapshot: Snapshot)
        
}

extension UserSectionModel: SectionModelType {
    typealias Item = UserSectionItem
    
    var items: [UserSectionItem] {
        switch self {
        case let .friendsSection(_, items):
            return items.map {$0}
        case let .friendRequestsSection(_, items):
            return items.map {$0}
        }
    }
    
    var titles: String {
        switch self {
        case let .friendsSection(title, _):
            return title
        case let .friendRequestsSection(title, _):
            return title
        }
    }
    
    init(original: UserSectionModel, items: [Item]) {
        switch original {
        case let .friendsSection(t, _):
            self = .friendsSection(title: t, items: items)
        case let .friendRequestsSection(t, _):
            self = .friendRequestsSection(title: t, items: items)
        }
    }
}
