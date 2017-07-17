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

class ContactUtility {
    
    let contactStore = CNContactStore()
    let keysToFetch = [CNContactPhoneNumbersKey, CNContactGivenNameKey, CNContactFamilyNameKey] as [CNKeyDescriptor]
    
    func getContacts() -> Observable<[(name: String, phoneNumber: String)]> {
        return Observable.create({ (observer) -> Disposable in
            let fetchRequest = CNContactFetchRequest(keysToFetch: self.keysToFetch)
            fetchRequest.unifyResults = true
            
            var phoneNumbers = [(name: String, phoneNumber: String)]()
            do {
                try self.contactStore.enumerateContacts(with: fetchRequest, usingBlock: { (contact, _) in
                    let numbers = self.phoneNumbersFrom(contact: contact)
                    phoneNumbers.append(contentsOf: numbers)
                })
            } catch {
                print("Error getting contacts")
            }
            
            observer.onNext(phoneNumbers)
            
            return Disposables.create()
        })
    }
    
    private func phoneNumbersFrom(contact: CNContact) -> [(name: String, phoneNumber: String)] {
        var phoneNumbers = [(name: String, phoneNumber: String)]()
        
        contact.phoneNumbers.forEach { (labeledNumber) in
            if labeledNumber.label == CNLabelPhoneNumberiPhone {
                phoneNumbers.append((contact.givenName + " " + contact.familyName, labeledNumber.value.stringValue))
            } else if labeledNumber.label == CNLabelPhoneNumberMobile {
                phoneNumbers.append((contact.givenName + " " + contact.familyName, labeledNumber.value.stringValue))
            }
        }
        
        return phoneNumbers
    }
    
    func requestForAccess() -> Observable<Bool> {
        return Observable.create({ (observer) -> Disposable in
            let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
            
            switch authorizationStatus {
            case .authorized:
                observer.onNext(true)
            case .notDetermined:
                self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, _) -> Void in
                    observer.onNext(access)
                })
            default:
                observer.onNext(false)
            }
            
            return Disposables.create()
        })

    }
    
}
