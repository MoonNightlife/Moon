//
//  NameViewModel.swift
//  Moon
//
//  Created by Evan Noble on 5/31/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift

class NameViewModel {
    
    // Private
    private let disposeBag = DisposeBag()
    
    // Inputs
    var firstName = BehaviorSubject<String?>(value: "")
    var lastNmae = BehaviorSubject<String?>(value: "")
    
    // Ouputs
    var dataValid: Observable<Bool>!
    
    // Dependencies
    var validationUtility: SignUpValidation!
    var newUser: NewUser!
    
    init() {
        creatOutputs()
    }
    
    private func creatOutputs() {
        dataValid = Observable.combineLatest(firstName, lastNmae)
            .do(onNext: {
                self.newUser.firstName = $0
                self.newUser.lastName = $1
            })
            .map({
                guard let fn = $0, let ln = $1 else {
                    return false
                }
                
                return self.validationUtility.valid(firstName: fn) && self.validationUtility.valid(lastName: ln)
            })
    }
    
    func createBirthdaySexViewModel() -> BirthdaySexViewModel {
        let vm = BirthdaySexViewModel()
        vm.newUser = self.newUser
        vm.validationUtility = validationUtility
        
        return vm
    }
}
