//
//  WebViewViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/9/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import Action

struct WebViewViewModel {
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    // Outputs
    let url: URL
    // Inputs
    
    init(coordinator: SceneCoordinatorType, url: URL) {
        sceneCoordinator = coordinator
        self.url = url
    }
    
    func onBack() -> CocoaAction {
        return CocoaAction { _ in
            return self.sceneCoordinator.pop()
        }
    }
}
