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
import SwaggerClient

enum UsersGoingType: Int {
    case everyone = 0
    case friends = 1
}

struct BarProfileViewModel: ImageDownloadType, BackType {
    
    // Local
    private let bag = DisposeBag()
    private let barInfo: Observable<BarInfo>
    
    // Dependencies
    let sceneCoordinator: SceneCoordinatorType
    var photoService: PhotoService
    let barAPI: BarAPIType
    
    // Inputs
    var selectedUserIndex = BehaviorSubject<UsersGoingType>(value: .everyone)
    
    // Outputs
    var barPics = Variable<[UIImage]>([])
    var barName: Observable<String>
    var displayedUsers = Variable<[UserSnapshot]>([])
    var specials = Variable<[SpecialCell]>([])
    var events = Variable<[FeaturedEvent]>([])
    
    init(coordinator: SceneCoordinatorType, photoService: PhotoService = KingFisherPhotoService(), barAPI: BarAPIType = BarAPIController(), userAPI: UserAPIType = UserAPIController()) {
        self.sceneCoordinator = coordinator
        self.photoService = photoService
        self.barAPI = barAPI
        
         let bar = barAPI.getBarInfo(barID: "594bfb53fc13ae69de000cff")
        
        barName = bar.map({ $0.name ?? "No Name" })
        
        bar.map({ $0.specials }).filter({ $0 != nil }).map({ return $0!.map(SpecialCell.init) })
            .catchErrorJustReturn([]).bind(to: specials).addDisposableTo(bag)
        bar.map({ $0.events }).filter({ $0 != nil }).map({ return $0!.map(FeaturedEvent.init) }).catchErrorJustReturn([]).bind(to: events).addDisposableTo(bag)
        
        bar.map({ $0.peopleAttending }).filterNil().bind(to: displayedUsers).addDisposableTo(bag)
        
        bar.map({ $0.barPics }).filter({ $0 != nil }).flatMap({ pictureURLs in
            return Observable.from(pictureURLs!).flatMap({
                return photoService.getImageFor(url: URL(string: $0)!)
            }).toArray()
            
        }).catchErrorJustReturn([]).bind(to: barPics).addDisposableTo(bag)
        
        barInfo = bar.map({ bar in
            return BarInfo(website: bar.website, address: bar.address, phoneNumber: bar.phoneNumber)
        })
        
    }
    
    func onShowInfo() -> CocoaAction {
        return CocoaAction {
            let vm = BarInfoViewModel(coordinator: self.sceneCoordinator, barInfo: self.barInfo)
            return self.sceneCoordinator.transition(to: Scene.Bar.info(vm), type: .popover)
        }
    }
    
    func onAttendBar() -> CocoaAction {
        return CocoaAction {
            print("Attend bar")
            return Observable.empty()
        }
    }
    
    func onViewMore() -> CocoaAction {
        return CocoaAction {
            print("View More")
            return Observable.empty()
        }
    }
    
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

}
