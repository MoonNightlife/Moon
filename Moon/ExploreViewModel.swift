//
//  ExploreViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import Action
import RxDataSources

typealias SpecialSection = AnimatableSectionModel<String, Special>

struct ExploreViewModel: ImageNetworkingInjected, NetworkingInjected {
    
    // Local
    private let disposeBag = DisposeBag()

    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    
    // Inputs
    var selectedSpecialIndex = BehaviorSubject<AlcoholType>(value: .beer)
    var reloadSpecial = PublishSubject<Void>()
    
    // Outputs
    lazy var topBars: Action<Void, [TopBar]> = { this in
        return Action(workFactory: {_ in
            return this.barAPI.getTopBarsIn(region: "Dallas")
        })
    }(self)
    
    lazy var specials: Observable<[SpecialSection]> = { this in
        return Observable.combineLatest(this.specialSectionObservable(type: .beer), this.specialSectionObservable(type: .wine), this.specialSectionObservable(type: .liquor), this.reloadSpecial, this.selectedSpecialIndex)
            .map({ (beer, wine, liquor, _, index) -> [SpecialSection] in
                switch index {
                case .beer:
                    return beer
                case .liquor:
                    return liquor
                case .wine:
                    return wine
                }
            })
    }(self)
    
    init(coordinator: SceneCoordinatorType) {
        self.sceneCoordinator = coordinator
        
    }
    
    func specialSectionObservable(type: AlcoholType) -> Observable<[SpecialSection]> {
        return self.barAPI.getSpecialsIn(region: "Dallas", type: type.rawValue)
            .catchErrorJustReturn([])
            .map({
                return [SpecialSection(model: "Specials", items: $0)]
            })
    }
    
    func showBar(barID: String) -> CocoaAction {
        return CocoaAction {
            let vm = BarProfileViewModel(coordinator: self.sceneCoordinator, barID: barID)
            return self.sceneCoordinator.transition(to: Scene.Bar.profile(vm), type: .modal)
        }
    }
    
    func onLike(specialID: String) -> CocoaAction {
        return CocoaAction {
            print("Liked Special")
            return self.userAPI.likeSpecial(userID: "123", specialID: specialID)
        }
    }
    
    func onViewBar(barID: String) -> CocoaAction {
        return CocoaAction {
            print("View Bar Profile")
            let vm = BarProfileViewModel(coordinator: self.sceneCoordinator, barID: barID)
            return self.sceneCoordinator.transition(to: Scene.Bar.profile(vm), type: .modal)
        }
    }
    
    func onViewLikers(specialID: String) -> CocoaAction {
        return CocoaAction {_ in
            let vm = UsersTableViewModel(coordinator: self.sceneCoordinator, sourceID: .special(id: specialID))
            return self.sceneCoordinator.transition(to: Scene.User.usersTable(vm), type: .modal)
        }
    }
    
    func onChangeAttendence(barID: String) -> CocoaAction {
        return CocoaAction {_ in
            return Observable.empty()
        }
    }
}
