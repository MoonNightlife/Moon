//
//  BarInfoViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/12/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action

struct BarInfoViewModel {
    // Private
    private let defaultInfo = BarInfo(website: "www.pornhub.com", address: "6969 Master Bateson Lane", phoneNumber: "1-800-jack-off")
    
    // Dependencies
    let sceneCoordinator: SceneCoordinatorType
    
    // Output
    var address: Driver<String>!
    var website: Driver<String>!
    var phoneNumber: Driver<String>!
    
    // Input
    
    init(coordinator: SceneCoordinatorType) {
        sceneCoordinator = coordinator
        
        let barInfo = getFakeInfo().share()
        
        address = barInfo.map({
            $0.address
        }).asDriver(onErrorJustReturn: defaultInfo.address)
        
        website = barInfo.map({
            $0.website
        }).asDriver(onErrorJustReturn: defaultInfo.address)
        
        phoneNumber = barInfo.map({
            $0.phoneNumber
        }).asDriver(onErrorJustReturn: defaultInfo.address)
        
    }
    
    func onBack() -> CocoaAction {
        return CocoaAction {
            return self.sceneCoordinator.pop()
        }
    }
    
    func onCall() -> CocoaAction {
        return CocoaAction {
            print("Make Call")
            return Observable.empty()
        }
    }
    
    func onViewWebsite() -> CocoaAction {
        return CocoaAction {
            print("View Website")
            return Observable.empty()
        }
    }
    
    func onGetDirections() -> CocoaAction {
        return CocoaAction {
            print("View in map")
            return Observable.empty()
        }
    }
    
    func getFakeInfo() -> Observable<BarInfo> {
        let barInfo = BarInfo(website: "www.pornhub.com", address: "6969 Master Bateson Lane", phoneNumber: "1-800-jack-off")
        return Observable.just(barInfo)
    }
}
