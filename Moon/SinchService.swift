//
//  SinchService.swift
//  Moon
//
//  Created by Evan Noble on 12/5/16.
//  Copyright © 2016 Evan Noble. All rights reserved.
//

import Foundation
import SinchVerification
import RxSwift

class SinchService: SMSValidationService {
    
    enum SinchError: Error {
        case formattingFailed
        case verificationFailed
    }
    
    private let sinchAPIKey = "1c4d1e22-0863-479a-8d15-4ecc6d2f6807"
    private var verification: SINVerificationProtocol?
    
    func formatPhoneNumberForGuiFrom(string: String, countryCode: CountryCode) -> String? {
        do {
            let phoneNumber = try SINPhoneNumberUtil().parse(string, defaultRegion: countryCode.isoAlpha2)
            return SINPhoneNumberUtil().formatNumber(phoneNumber, format: .national)
        } catch {
            return nil
        }
    }
    
    func formatPhoneNumberForStorageFrom(string: String, countryCode: CountryCode) -> String? {
        do {
            let phoneNumber = try SINPhoneNumberUtil().parse(string, defaultRegion: countryCode.isoAlpha2)
            return SINPhoneNumberUtil().formatNumber(phoneNumber, format: .E164)
        } catch {
            return nil
        }
    }
    
    private func getDevicesCountryCode() -> String {
        // Get user's current region by carrier info
        return SINDeviceRegion.currentCountryCode()
    }
    
    func sendVerificationCodeTo(phoneNumber: String, countryCode: String) -> Observable<Void> {
        
        return Observable.create({ (observer) -> Disposable in
            do {
                let phoneNumber = try SINPhoneNumberUtil().parse(phoneNumber, defaultRegion: countryCode)
                let phoneNumberInE164 = SINPhoneNumberUtil().formatNumber(phoneNumber, format: .E164)
                let verification = SINVerification.smsVerification(withApplicationKey: self.sinchAPIKey, phoneNumber: phoneNumberInE164)
                // retain the verification instance
                self.verification = verification
                verification.initiate(completionHandler: {(result, error) -> Void in
                    if result.success {
                        observer.onNext()
                    } else if let e = error {
                        observer.onError(e)
                    }
                    observer.onCompleted()
                })
            } catch {
                observer.onError(SinchError.formattingFailed)
                observer.onCompleted()
            }
           return Disposables.create()
        })
    }
    
    func verifyNumberWith(Code code: String) -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            self.verification!.verifyCode(code, completionHandler: {(success: Bool, error: Error?) -> Void in
                if success {
                    observer.onNext()
                } else {
                    if let error = error {
                        observer.onError(error)
                    } else {
                        observer.onError(SinchError.verificationFailed)
                    }
                }
                observer.onCompleted()
            })
            return Disposables.create()
        })
    }
}
