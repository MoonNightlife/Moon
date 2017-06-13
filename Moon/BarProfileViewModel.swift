//
//  BarProfileViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/8/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import Action
import RxSwift
import RxCocoa

enum UsersGoingType: Int {
    case everyone = 0
    case friends = 1
}

struct BarProfileViewModel {
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    
    // Inputs
    lazy var selectedUserIndex: Action<UsersGoingType, [FakeUser]> = {
        return Action(workFactory: {
            switch $0 {
            case .everyone:
                return Observable.just(createFakeUsers())
            case .friends:
                var users = createFakeUsers()
                users.replaceSubrange(0...3, with: [])
                return Observable.just(users)
            }
        })
    }()
    
    lazy var onShowProfile: Action<String, Void> = { this in
        return Action<String, Void> {_ in 
            let vm = ProfileViewModel(coordinator: this.sceneCoordinator)
            return this.sceneCoordinator.transition(to: Scene.User.profile(vm), type: .popover)
        }
    }(self)
    
    lazy var onViewLikers: Action<String, Void> = { this in
        return Action<String, Void> {_ in
            let vm = UsersTableViewModel(coordinator: this.sceneCoordinator)
            return this.sceneCoordinator.transition(to: Scene.User.usersTable(vm), type: .modal)
        }
    }(self)
    
    lazy var onLikeActivity: Action<String, Void> = { this in
        return Action<String, Void> {_ in 
            print("Like Activity")
            return Observable.empty()
        }
    }(self)
    
    lazy var onLikeEvent: Action<String, Void> = { this in
        return Action<String, Void> {_ in
            print("Like Event")
            return Observable.empty()
        }
    }(self)
    
    lazy var onShareEvent: Action<String, Void> = { this in
        return Action<String, Void> {_ in
            print("Share Event")
            return Observable.empty()
        }
    }(self)
    
    lazy var onLikeSpecial: Action<String, Void> = { this in
        return Action<String, Void> {_ in
            print("Like Special")
            return Observable.empty()
        }
    }(self)
    
    // Outputs
    var specials: Driver<[Special]> {
        return getSpecials()
    }
    var events: Driver<[FeaturedEvent]> {
        return getEvents()
    }
    var barPictures: Driver<[UIImage]> {
        return getBarPics()
    }
    var barName: Driver<String> {
        return getBarName()
    }
    
    init(coordinator: SceneCoordinatorType) {
        self.sceneCoordinator = coordinator

    }
    
    func onBack() -> CocoaAction {
        return CocoaAction {_ in 
            return self.sceneCoordinator.pop()
        }
    }
    
    func onShowInfo() -> CocoaAction {
        return CocoaAction {
            let vm = BarInfoViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.Bar.info(vm), type: .popover)
        }
    }
    
    func onAttendBar() -> CocoaAction {
        return CocoaAction {
            print("Attend bar")
            return Observable.empty()
        }
    }
}

extension BarProfileViewModel {
    
    fileprivate func getSpecials() -> Driver<[Special]> {
        return Observable.just(createFakeSpecials()).asDriver(onErrorJustReturn: [])
    }
    
    fileprivate func getEvents() -> Driver<[FeaturedEvent]> {
        return Observable.just(createFakeEvents()).asDriver(onErrorJustReturn: [])
    }
    
    fileprivate func getBarName() -> Driver<String> {
        return Observable.just("Avenu Lounge").asDriver(onErrorJustReturn: "")
    }
    
    fileprivate func getBarPics() -> Driver<[UIImage]> {
        let barPicNames = ["b1.jpg", "b2.jpg", "b3.jpg", "b4.jpg", "b5.jpg"]
        var images = [UIImage]()
        barPicNames.forEach { (picName) in
            guard let image = UIImage(named: picName) else {
                return
            }
            images.append(image)
        }
        return Observable.just(images).asDriver(onErrorJustReturn: [])
    }
}
