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
import CoreLocation

struct BarInfoViewModel {
    // Private
    private let defaultInfo = BarInfo(website: "www.apple.com", address: "108 Mast Ct, Mooresville NC", phoneNumber: "1-800–692–7753")
    let barInfo: Observable<BarInfo>
    
    // Dependencies
    let sceneCoordinator: SceneCoordinatorType
    let geocoder: CLGeocoder
    
    // Outputs
    var addressString: Driver<String>!
    var websiteString: Driver<String>!
    var phoneNumberString: Driver<String>!
    
    // Inputs
    lazy var onCall: Action<Void, URL?> = { this in
        return Action(workFactory: {_ in
            return this.barInfo.map({ $0.phoneNumber }).map(this.createPhoneNumberURL)
        })
    }(self)
    
    lazy var onViewWebsite: Action<Void, URL?> = { this in
        return Action(workFactory: {_ in
            return this.barInfo.map({ info in
                return URL(string: "http://\(info.website)")
            })
        })
    }(self)
    
    lazy var onViewAddress: Action<Void, URL?> = { this in
        return Action(workFactory: {_ in
            return this.barInfo.map({ $0.address }).map(this.createAddressURL)
        })
    }(self)
    
    init(coordinator: SceneCoordinatorType, geocoder: CLGeocoder = CLGeocoder()) {
        sceneCoordinator = coordinator
        self.geocoder = geocoder
        
        barInfo = {
            let barInfo = BarInfo(website: "www.apple.com", address: "108 Mast Ct, Mooresville NC", phoneNumber: "1-800–692–7753")
            return Observable.just(barInfo)
        }()
        
        addressString = barInfo.map({
            $0.address
        }).asDriver(onErrorJustReturn: defaultInfo.address)
        
        websiteString = barInfo.map({
            $0.website
        }).asDriver(onErrorJustReturn: defaultInfo.website)
        
        phoneNumberString = barInfo.map({
            $0.phoneNumber
        }).asDriver(onErrorJustReturn: defaultInfo.phoneNumber)
        
    }
    
    func onBack() -> CocoaAction {
        return CocoaAction {
            return self.sceneCoordinator.pop()
        }
    }
}

extension BarInfoViewModel {
    fileprivate func createPhoneNumberURL(phoneNumber: String) -> URL? {
        let formattedPhoneNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return URL(string: "tel://\(formattedPhoneNumber)")
    }
    
    fileprivate func createAddressURL(address: String) -> URL? {
        let formattedAddress = address.replacingOccurrences(of: " ", with: "%20")
        return URL(string: "http://maps.apple.com/?address=\(formattedAddress)")
    }
}
