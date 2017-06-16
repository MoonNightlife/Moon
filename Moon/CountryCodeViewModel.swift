//
//  CountryCodeViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/15/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import Action
import RxSwift

struct CountryCodeViewModel: BackType {
    // Private
    
    // Dependencies
    let sceneCoordinator: SceneCoordinatorType
    
    // Inputs
    
    // Actions
    let updateCode: Action<CountryCode, Void>
    
    // Outputs
    var countryCodes: Observable<[String]> {
        return Observable.just([CountryCode.US.description, CountryCode.BZ.description])
    }
    
    init(coordinator: SceneCoordinatorType, updateCountryCode: Action<CountryCode, Void>) {
        self.sceneCoordinator = coordinator
        self.updateCode = updateCountryCode
    }
}
