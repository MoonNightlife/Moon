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
    func sendVerificationCodeTo(phoneNumber: String, countryCode: String) -> Observable<Void>
    func verifyNumberWith(Code code: String) -> Observable<Void>
    func formatPhoneNumberForGuiFrom(string: String, countryCode: CountryCode) -> String?
    func formatPhoneNumberForStorageFrom(string: String, countryCode: CountryCode) -> String?
}
