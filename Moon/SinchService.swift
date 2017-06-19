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

protocol SMSValidationService {
//    func sendVerificationCodeTo(PhoneNumber phoneNumber: String) -> Observable<Void>
//    func verifyNumberWith(Code code: String) -> Observable<Void>
    static func formatPhoneNumberForGuiFrom(string: String, countryCode: CountryCode) -> String?
    static func formatPhoneNumberForStorageFrom(string: String, countryCode: CountryCode) -> String?
}

class SinchService: NSObject, SMSValidationService {
    
    enum SinchError: Error {
        case formattingError
    }
    
    private let sinchAPIKey = "1c4d1e22-0863-479a-8d15-4ecc6d2f6807"
    private var verification: SINVerificationProtocol?
    
    static func formatPhoneNumberForGuiFrom(string: String, countryCode: CountryCode) -> String? {
        do {
            let phoneNumber = try SINPhoneNumberUtil().parse(string, defaultRegion: countryCode.isoAlpha2)
            return SINPhoneNumberUtil().formatNumber(phoneNumber, format: .national)
        } catch {
            return nil
        }
    }
    
    static func formatPhoneNumberForStorageFrom(string: String, countryCode: CountryCode) -> String? {
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
    
//    func sendVerificationCodeTo(PhoneNumber phoneNumber: String) -> Observable<Void> {
//        
//        return Observable.create({ (observer) -> Disposable in
//            let defaultRegion = self.getDevicesCountryCode()
//            do {
//                let phoneNumber = try SINPhoneNumberUtil().parse(phoneNumber, defaultRegion: defaultRegion)
//                let phoneNumberInE164 = SINPhoneNumberUtil().formatNumber(phoneNumber, format: .E164)
//                let verification = SINVerification.smsVerification(withApplicationKey: self.sinchAPIKey, phoneNumber: phoneNumberInE164)
//                // retain the verification instance
//                self.verification = verification
//                verification.initiate(completionHandler: {(success, error) -> Void in
//                    if success {
//                        observer.onNext(.Success)
//                    } else if let e = error {
//                        observer.onError(e)
//                    }
//                    observer.onCompleted()
//                })
//            } catch {
//                observer.onError(SinchError.formattingError)
//                observer.onCompleted()
//            }
//            return AnonymousDisposable {
//                
//            }
//        })
//    }
//    
//    func verifyNumberWith(Code code: String) -> Observable<Void> {
//        return Observable.create({ (observer) -> Disposable in
//            self.verification!.verifyCode(code, completionHandler: {(success: Bool, error: NSError?) -> Void in
//                if success {
//                    observer.onNext(.Success)
//                } else {
//                    if let error = error {
//                        observer.onNext(SMSValidationResponse.Error(error: error))
//                    } else {
//                        observer.onNext(.Error(error: SMSValidationError.ValidationError))
//                    }
//                }
//                observer.onCompleted()
//            })
//            return AnonymousDisposable {
//                
//            }
//        })
//    }
}
