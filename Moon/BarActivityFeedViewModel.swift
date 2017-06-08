//
//  BarActivityFeedViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import Action

typealias ActivitySection = AnimatableSectionModel<String, BarActivity>

struct BarActivityFeedViewModel {
    
    // Private
    private let disposeBag = DisposeBag()
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    
    // Inputs
    
    // Outputs
    lazy var refreshAction: Action<Void, [ActivitySection]> = {
        return Action { _ in
            let section = [ActivitySection(model: "", items: createFakeBarActivities().slice(start: Int(arc4random_uniform(UInt32(createFakeBarActivities().count-1))), end: createFakeBarActivities().count-1))]
            return Observable.just(section)
        }
    }()
    
    init(coordinator: SceneCoordinatorType) {
        self.sceneCoordinator = coordinator

    }
    
    func onLike(activity: BarActivity) -> CocoaAction {
        return CocoaAction {
            print("Show \(activity)")
            return Observable.empty()
        }
    }
    
    func onViewUser(activity: BarActivity) -> CocoaAction {
        return CocoaAction {
            print("Show \(activity)")
            return Observable.empty()
        }
    }
    
    func onViewBar(activity: BarActivity) -> CocoaAction {
        return CocoaAction {
            let vm = BarProfileViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.Bar.profile(vm), type: .modal)
        }
    }
    
    func onViewLikers(activity: BarActivity) -> CocoaAction {
        return CocoaAction {
            print("Show \(activity)")
            return Observable.empty()
        }
    }
}
