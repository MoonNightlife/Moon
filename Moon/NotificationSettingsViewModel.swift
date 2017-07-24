//
//  NotificationSettingsViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/8/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import Action

class NotificationSettingsViewModel: NetworkingInjected, AuthNetworkingInjected {
    // Global
    var bag = DisposeBag()
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    
    // Outputs
    var notificationSettings =  Variable<[NotificationSetting]?>(nil)
    
    init(coordinator: SceneCoordinatorType) {
        sceneCoordinator = coordinator
        
        self.userAPI.getNotificationSettings(userID: self.authAPI.SignedInUserID).bind(to: notificationSettings).addDisposableTo(bag)
    }
    
    func onBack() -> CocoaAction {
        return CocoaAction { [unowned self] in
            if let settings = self.notificationSettings.value {
                return self.userAPI.updateNotificationSettings(userID: self.authAPI.SignedInUserID, settings: settings).flatMap({
                    return self.sceneCoordinator.pop()
                })

            } else {
                return self.sceneCoordinator.pop()
            }
        }
    }
    
    func onUpdateSetting(nameOfSetting: String) {
        notificationSettings.value = notificationSettings.value!.map({
            var temp = $0
            if temp.name == nameOfSetting {
                temp.activated = !temp.activated!
            }
            return temp
        })
    }
    
    func onSave() -> CocoaAction {
        return CocoaAction {
            
            return Observable.empty()
        }
    }
}
