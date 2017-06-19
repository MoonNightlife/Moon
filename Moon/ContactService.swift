//
//  ContactService.swift
//  Moon
//
//  Created by Evan Noble on 6/17/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import Contacts
import RxSwift

class ContactService {
    
    let contactStore = CNContactStore()
    let keysToFetch = [String]()
    
    func getContacts() -> Observable<[CNContact]> {
        return Observable.create({ (observer) -> Disposable in
            do {
                //contactStore
                //observer.onNext(contacts)
                
            }
            catch {
                
            }
            
            return Disposables.create()
        })
    }
    
    func requestForAccess() -> Observable<Bool> {
        return Observable.create({ (observer) -> Disposable in
            let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
            
            switch authorizationStatus {
            case .authorized:
                observer.onNext(true)
            case .denied, .notDetermined:
                self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, _) -> Void in
                    if access {
                        observer.onNext(access)
                    } else {
                        if authorizationStatus == CNAuthorizationStatus.denied {
                            observer.onNext(false)
                        }
                    }
                })
                
            default:
                observer.onNext(true)
            }
            
            return Disposables.create()
        })

    }
    
}
