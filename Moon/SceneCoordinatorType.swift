//
//  SceneCoordinatorType.swift
//  Moon
//
//  Created by Evan Noble on 6/1/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import RxSwift

protocol SceneCoordinatorType {
    init(window: UIWindow)
    
    /// transition to another scene
    @discardableResult
    func transition(to scene: SceneType, type: SceneTransitionType) -> Observable<Void>
    
    /// pop scene from navigation stack or dismiss current modal
    @discardableResult
    func pop(animated: Bool) -> Observable<Void>
    
    // pop scene from navigation stack
    // this method should be used if the navigation controller is presented modally
    // and you just want to pop a view controller off the stack instead of removeing the
    // whole navigation stack
    @discardableResult
    func popVCOffNavStack(animated: Bool) -> Observable<Void>
    
    @discardableResult
    func changeChild(To view: ChildViewType) -> Observable<Void>
}

extension SceneCoordinatorType {
    @discardableResult
    func pop() -> Observable<Void> {
        return pop(animated: true)
    }
}
