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
import RxOptional

struct BarInfoViewModel {
    // Private
    private let defaultInfo = BarInfo(website: "www.apple.com", address: "108 Mast Ct, Mooresville NC", phoneNumber: "1-800–692–7753")
    
    // Dependencies
    let sceneCoordinator: SceneCoordinatorType
    let geocoder: CLGeocoder
    
    // Outputs
    var addressString: Driver<String>
    var addressURL: Observable<URL?>
    var websiteString: Driver<String>
    var websiteURL: Observable<URL?>
    var phoneNumberString: Driver<String>
    var phoneNumberURL: Observable<URL?>
    
    // Inputs
    
    init(coordinator: SceneCoordinatorType, geocoder: CLGeocoder = CLGeocoder(), barInfo: Observable<BarInfo>) {
        sceneCoordinator = coordinator
        self.geocoder = geocoder
    
        let sharedBarInfo = barInfo.share()
        addressString = sharedBarInfo.map({ $0.address }).replaceNilWith("No Address").asDriver(onErrorJustReturn: defaultInfo.address!)
        websiteString = sharedBarInfo.map({ $0.website }).replaceNilWith("No Website").asDriver(onErrorJustReturn: defaultInfo.website!)
        phoneNumberString = sharedBarInfo.map({ $0.phoneNumber }).replaceNilWith("No Phone Number").asDriver(onErrorJustReturn: defaultInfo.phoneNumber!)
        
        addressURL = sharedBarInfo.map({ $0.address }).map(BarInfoViewModel.createAddressURL)
        websiteURL = sharedBarInfo.map({ $0.website }).map(BarInfoViewModel.createWebsiteURL)
        phoneNumberURL = sharedBarInfo.map({ $0.phoneNumber }).map(BarInfoViewModel.createPhoneNumberURL)
        
    }
    
    func onBack() -> CocoaAction {
        return CocoaAction {
            return self.sceneCoordinator.pop()
        }
    }
}

extension BarInfoViewModel {
    static func createPhoneNumberURL(phoneNumber: String?) -> URL? {
        guard let formattedPhoneNumber = phoneNumber?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() else {
            return nil
        }
        
        return URL(string: "tel://\(formattedPhoneNumber)")
    }
    
    static func createAddressURL(address: String?) -> URL? {
        guard let formattedAddress = address?.replacingOccurrences(of: " ", with: "%20") else {
            return nil
        }
        
        return URL(string: "http://maps.apple.com/?address=\(formattedAddress)")
    }
    
    static func createWebsiteURL(website: String?) -> URL? {
        guard let web = website else {
            return nil
        }
        
        return URL(string: "http://\(web)")
    }
}
