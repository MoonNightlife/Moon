//
//  SpecialsViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import Action
import RxDataSources

typealias SpecialSection = AnimatableSectionModel<String, SpecialCell>

struct SpecialsViewModel {
    
    // Private
    private let disposeBag = DisposeBag()
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    private let barAPI: BarAPIType
    private let userAPI: UserAPIType
    
    // Inputs
    
    // Outputs
    var specials: Action<Void, [SpecialSection]>
    
    init(coordinator: SceneCoordinatorType, barAPI: BarAPIType = BarAPIController(), userAPI: UserAPIType = UserAPIController()) {
        self.sceneCoordinator = coordinator
        self.barAPI = barAPI
        self.userAPI = userAPI
        
        specials = Action(workFactory: { _ in
            return barAPI.getSpecialsIn(region: "dallas").map({
                    return $0.map({ special in
                        return SpecialCell(from: special)
                    })
                })
                .map({
                    return [SpecialSection(model: "Specials", items: $0)]
                })
        })
    }
    
    func onLike(specialID: String) -> CocoaAction {
        return CocoaAction {
            print("Liked Special")
            return self.userAPI.likeSpecial(userID: "123", specialID: specialID)
        }
    }
}
