//
//  ExploreViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import SwaggerClient
import Action
import RxDataSources

typealias SpecialSection = AnimatableSectionModel<String, Special>

struct ExploreViewModel: ImageDownloadType {
    
    // Local
    private let disposeBag = DisposeBag()
    let beerSpecials: Observable<[SpecialSection]>
    let wineSpecials: Observable<[SpecialSection]>
    let liquorSpecials: Observable<[SpecialSection]>

    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    private let barAPI: BarAPIType
    private let userAPI: UserAPIType
    var photoService: PhotoService
    
    // Inputs
    var selectedSpecialIndex = BehaviorSubject<AlcoholType>(value: .beer)
    var reloadSpecial = PublishSubject<Void>()
    
    // Outputs
    var topBars: Action<Void, [TopBar]>
    var specials: Observable<[SpecialSection]>
    
    init(coordinator: SceneCoordinatorType, barAPI: BarAPIType = BarAPIController(), photoService: PhotoService = KingFisherPhotoService(), userAPI: UserAPIType = UserAPIController()) {
        self.sceneCoordinator = coordinator
        self.photoService = photoService
        self.barAPI = barAPI
        self.userAPI = userAPI
        
        topBars = Action(workFactory: {_ in 
            return barAPI.getTopBarsIn(region: "Dallas").map({
                return $0.map({ bar in
                    return TopBar(from: bar)
                })
            })
        })
        
        beerSpecials = ExploreViewModel.specialSectionObservable(type: .beer, barAPI: barAPI)
        wineSpecials = ExploreViewModel.specialSectionObservable(type: .wine, barAPI: barAPI)
        liquorSpecials = ExploreViewModel.specialSectionObservable(type: .liquor, barAPI: barAPI)
        
        specials = Observable.combineLatest(beerSpecials, wineSpecials, liquorSpecials, reloadSpecial, selectedSpecialIndex)
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
    }
    
    static func specialSectionObservable(type: AlcoholType, barAPI: BarAPIType) -> Observable<[SpecialSection]> {
        return barAPI.getSpecialsIn(region: "Dallas", type: type.rawValue)
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
}
