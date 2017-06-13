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
}

extension View.Search {
    func getViewID() -> Int {
        switch self {
        case .results: return 2
        case .suggestions: return 1
        }
    }
}
