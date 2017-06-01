//
//  BirthdaySexViewModel.swift
//  Moon
//
//  Created by Evan Noble on 5/31/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift

class BirthdaySexViewModel {
    
    let sexPickerViewOptions = ["Male", "Female", "Rather Not Say"]
    
    // Dependencies
    var validationUtility: SignUpValidation!
    var newUser: NewUser!
    var dateFormatter: DateFormatter!
    
    // Inputs
    var birthday = BehaviorSubject<Date>(value: Date())
    var sex = BehaviorSubject<(Int, Int)>(value: (0, 0))
    
    // Outputs
    var birthdayString: Observable<String>!
    var sexString: Observable<String>!
    var validInfo: Observable<Void>!
    
    init() {
        createDateFormatter()
        createOutput()
    }
    
    fileprivate func createDateFormatter() {
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
    }
    
    fileprivate func createOutput() {
        birthdayString = birthday
            .map({ (date) -> String in
                return self.dateFormatter.string(from: date)
            })
            .do(onNext: { (birthdayString) in
                self.newUser.birthday = birthdayString
            })
        
        sexString = sex
            .map({ (row, section) -> String in
                print(section)
                print(row)
                return self.sexPickerViewOptions[row]
            })
    }
    
    func createEmailUsernameViewModel() -> EmailUsernameViewModel {
        let vm = EmailUsernameViewModel()
        vm.newUser = newUser
        vm.validationUtility = validationUtility
        return vm
    }
    
}
