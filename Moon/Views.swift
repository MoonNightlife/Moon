//
//  Views.swift
//  Moon
//
//  Created by Evan Noble on 6/12/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation

protocol ChildViewType {
    func getViewID() -> Int
}

enum View {
    enum Search: ChildViewType {
        case results
        case suggestions
    }
    
    enum Relationship: ChildViewType {
        case friends
        case groups
    }
}

extension View.Search {
    func getViewID() -> Int {
        switch self {
        case .results: return 2
        case .suggestions: return 1
        }
    }
}

extension View.Relationship {
    func getViewID() -> Int {
        switch self {
        case .friends: return 1
        case .groups: return 2
        }
    }
    
    static func from(int: Int) -> View.Relationship {
        switch int {
        case 0:
            return self.friends
        case 1:
            return self.groups
        default:
            return self.friends
        }
    }
}
