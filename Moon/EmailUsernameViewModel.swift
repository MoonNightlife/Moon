//
//  EmailUsernameViewModel.swift
//  Moon
//
//  Created by Evan Noble on 5/31/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift

class EmailUsernameViewModel {
    // Dependencies
    var validationUtility: SignUpValidation!
    var newUser: NewUser!
    
    // Inputs
    var username = BehaviorSubject<String?>(value: "")
    var email = BehaviorSubject<String?>(value: "")
    
    // Outputs
    var emailValid: Observable<Bool>!
    var usernameValid: Observable<Bool>!
    var allFieldsValid: Observable<Bool>!
    
    init() {
        prepareOutputs()
    }
    
    func prepareOutputs() {
        emailValid = email
            .map({ (email) -> Bool in
                guard let e = email else {
                    return false
                }
                
                return self.validationUtility.valid(email: e)
            })
        
        usernameValid = username
            .map({ (username) -> Bool in
                guard let un = username else {
                    return false
                }
                
                return self.validationUtility.valid(username: un)
            })
        
        allFieldsValid = Observable.combineLatest(usernameValid, emailValid)
            .map({
                return $0 && $1
            })
    }
}
