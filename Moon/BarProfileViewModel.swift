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
    private let bar: Observable<BarProfile>
    
    // Dependencies
    let sceneCoordinator: SceneCoordinatorType
    var photoService: PhotoService
    let barAPI: BarAPIType
    private let userAPI: UserAPIType
    
    // Inputs
    var selectedUserIndex = BehaviorSubject<UsersGoingType>(value: .everyone)
    var reloadDisplayUsers = PublishSubject<Void>()
    
    // Outputs
    var barPics = Variable<[UIImage]>([])
    var barName: Observable<String>
    var displayedUsers = Variable<[Activity]>([])
    var specials = Variable<[Special]>([])
    var events = Variable<[BarEvent]>([])
    
    init(coordinator: SceneCoordinatorType, photoService: PhotoService = KingFisherPhotoService(), barAPI: BarAPIType = BarAPIController(), userAPI: UserAPIType = UserAPIController(), barID: String) {
        self.sceneCoordinator = coordinator
        self.photoService = photoService
        self.barAPI = barAPI
        self.userAPI = userAPI
        
        bar = barAPI.getBarInfo(barID: barID)
        
        barName = bar.map({ $0.name ?? "No Name" })
        
        bar.map({ $0.specials }).filterNil().catchErrorJustReturn([]).bind(to: specials).addDisposableTo(bag)
        bar.map({ $0.events }).filterNil().catchErrorJustReturn([]).bind(to: events).addDisposableTo(bag)
        
        bar.map({ $0.barPics }).filter({ $0 != nil }).flatMap({ pictureURLs in
            return Observable.from(pictureURLs!).flatMap({
                return photoService.getImageFor(url: URL(string: $0)!)
            }).toArray()
            
        }).catchErrorJustReturn([]).bind(to: barPics).addDisposableTo(bag)
        
        barInfo = bar.map({ bar in
            return BarInfo(website: bar.website, address: bar.address, phoneNumber: bar.phoneNumber)
        })
        
        let peopleGoing = barAPI.getBarPeople(barID: barID)
        let friendsGoing = barAPI.getBarFriends(barID: barID, userID: SignedInUser.userID)
        
//         Observable.combineLatest(peopleGoing, friendsGoing, reloadDisplayUsers, selectedUserIndex)
//            .map({ (people, friends, _, userType) -> [UserSnapshot] in
//                switch userType {
//                case .everyone:
//                    return people
//                case .friends:
//                    return friends
//                }
//            })
//            .bind(to: displayedUsers)
//            .addDisposableTo(bag)
        
        
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
            return self.userAPI.goToBar(userID: "123123", barID: "594bfb53fc13ae69de000cff")
        }
    }
    
    func onViewMore() -> CocoaAction {
        return CocoaAction {
            //TODO: probably should remove this from event card
            print("View More")
            return Observable.empty()
        }
    }
    
    func onShowProfile(userID: String) -> CocoaAction {
        return CocoaAction {_ in
            let vm = ProfileViewModel(coordinator: self.sceneCoordinator, userID: userID)
            return self.sceneCoordinator.transition(to: Scene.User.profile(vm), type: .popover)
        }
    }
    
    func onViewLikers(eventID: String) -> CocoaAction {
        return CocoaAction {_ in
            let vm = UsersTableViewModel(coordinator: self.sceneCoordinator, sourceID: .event(id: eventID))
            return self.sceneCoordinator.transition(to: Scene.User.usersTable(vm), type: .modal)
        }
    }
    
    func onViewLikers(specialID: String) -> CocoaAction {
        return CocoaAction {_ in
            let vm = UsersTableViewModel(coordinator: self.sceneCoordinator, sourceID: .special(id: specialID))
            return self.sceneCoordinator.transition(to: Scene.User.usersTable(vm), type: .modal)
        }
    }
    
    func onViewLikers(activityID: String) -> CocoaAction {
        return CocoaAction {_ in
            let vm = UsersTableViewModel(coordinator: self.sceneCoordinator, sourceID: .activity(id: activityID))
            return self.sceneCoordinator.transition(to: Scene.User.usersTable(vm), type: .modal)
        }
    }
    
    func onLikeActivity(activityID: String) -> CocoaAction {
        return CocoaAction {_ in
            //TODO: add api call
            print("like activity needs implementation")
            return Observable.empty()
        }
    }
    
    func onLikeEvent(eventID: String) -> CocoaAction {
        return CocoaAction {_ in
            print("Like Event")
            return self.userAPI.likeEvent(userID: "123123", eventID: eventID)
        }
    }
    
    func onShareEvent(eventID: String, barID: String) -> CocoaAction {
        return CocoaAction {_ in
            //TODO: add api call
            print("Share event needs implementation")
            return Observable.empty()
        }
    }
    
    func onLikeSpecial(specialID: String) -> CocoaAction {
        return CocoaAction {_ in
            print("Like Special")
            return self.userAPI.likeSpecial(userID: "123123", specialID: specialID)
        }
    }

}
