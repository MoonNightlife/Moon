//
//  SMSValidationService.swift
//  Moon
//
//  Created by Evan Noble on 7/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift

protocol SMSValidationService {
    //    func sendVerificationCodeTo(PhoneNumber phoneNumber: String) -> Observable<Void>
    //    func verifyNumberWith(Code code: String) -> Observable<Void>
    static func formatPhoneNumberForGuiFrom(string: String, countryCode: CountryCode) -> String?
    static func formatPhoneNumberForStorageFrom(string: String, countryCode: CountryCode) -> String?
}
