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

struct BarProfileViewModel: ImageDownloadType {
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    var photoService: PhotoService
    
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
    
    func onShowProfile() -> CocoaAction {
        return CocoaAction {_ in
            let vm = ProfileViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.User.profile(vm), type: .popover)
        }
    }
    
    func onViewLikers() -> CocoaAction {
        return CocoaAction {_ in
            let vm = UsersTableViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.User.usersTable(vm), type: .modal)
        }
    }
    
    func onLikeActivity() -> CocoaAction {
        return CocoaAction {_ in
            print("Like Activity")
            return Observable.empty()
        }
    }
    
    func onLikeEvent() -> CocoaAction {
        return CocoaAction {_ in
            print("Like Event")
            return Observable.empty()
        }
    }
    
    func onShareEvent() -> CocoaAction {
        return CocoaAction {_ in
            print("Share Event")
            return Observable.empty()
        }
    }
    
    func onLikeSpecial() -> CocoaAction {
        return CocoaAction {_ in
            print("Like Special")
            return Observable.empty()
        }
    }
    
    // Outputs
    var specials: Driver<[SpecialCell]> {
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
    
    init(coordinator: SceneCoordinatorType, photoService: PhotoService = KingFisherPhotoService()) {
        self.sceneCoordinator = coordinator
        self.photoService = photoService
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
    
    fileprivate func getSpecials() -> Driver<[SpecialCell]> {
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
