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
import SwaggerClient

enum UserSectionModel {
    case friendsSection(title: String, items: [UserSectionItem])
    case friendRequestsSection(title: String, items: [UserSectionItem])
}

enum UserSectionItem: IdentifiableType, Equatable {

    static func ==(lhs: UserSectionItem, rhs: UserSectionItem) -> Bool {
        return lhs.identity == rhs.identity
    }

    var identity: String {
        switch self {
        case let .friend(snapshot):
            return snapshot.id ?? "0"
        case let .friendRequest(snapshot):
            return snapshot.id ?? "0"
        }
    }

    case friend(snapshot: UserSnapshot)
    case friendRequest(snapshot: UserSnapshot)
    
    
}

extension UserSectionModel: AnimatableSectionModelType {
    typealias Item = UserSectionItem
    
    var identity: String {
        switch self {
        case let .friendsSection(title, _):
            return title
        case let .friendRequestsSection(title, _):
            return title
        }
    }
    
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
