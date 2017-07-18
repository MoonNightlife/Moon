//
//  FirebaseBarAPI.swift
//  Moon
//
//  Created by Evan Noble on 6/29/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

struct FirebaseBarAPI: BarAPIType {
    
    struct BarFunction {
        private static let barBaseURL = "https://us-central1-moon-4409e.cloudfunctions.net/"
        
        static let getTopBarsInRegion = barBaseURL + "getTopBarsInRegion"
        static let getSpecialsInRegionByType = barBaseURL + "getSpecialsInRegionByType"
        static let getEventsInRegion = barBaseURL + "getEventsInRegion"
        static let getBarsInRegion =  barBaseURL + "getBarsForRegion"
        static let getSuggestedBars = barBaseURL + "getSuggestedBars"
        
        static let getBarProfile = barBaseURL + "getBarProfile"
        static let getBarEvents = barBaseURL + "getBarEvents"
        static let getBarSpecials = barBaseURL + "getBarSpecials"
        
        static let getBarFriends = barBaseURL + "getBarFriends"
        static let getBarPeople = barBaseURL + "getBarPeople"
        
        static let getEventLikers = barBaseURL + "getEventLikers"
        static let getSpecialLikers = barBaseURL + "getSpecialLikers"
        
        static let searchForBar = barBaseURL + "searchBar"
        static let isAttending = barBaseURL + "isAttending"
    }
    
    func getBarFriends(barID: String, userID: String) -> Observable<[Activity]> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "barId": "\(barID)",
                "userId": "\(userID)"
            ]
            let request = Alamofire.request(BarFunction.getBarFriends, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseArray(completionHandler: { (response: DataResponse<[Activity]>) in
                    switch response.result {
                    case .success(let activities):
                        observer.onNext(activities)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                })
            
            return Disposables.create {
                request.cancel()
            }
        })

    }
    func getBarPeople(barID: String) -> Observable<[Activity]> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "id": "\(barID)"
            ]
            let request = Alamofire.request(BarFunction.getBarPeople, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseArray(completionHandler: { (response: DataResponse<[Activity]>) in
                    switch response.result {
                    case .success(let activities):
                        observer.onNext(activities)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                })
            
            return Disposables.create {
                request.cancel()
            }
        })

    }
    func getBarInfo(barID: String) -> Observable<BarProfile> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "id": "\(barID)"
            ]
            let request = Alamofire.request(BarFunction.getBarProfile, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseObject(completionHandler: { (response: DataResponse<BarProfile>) in
                    switch response.result {
                    case .success(let profile):
                        observer.onNext(profile)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                })
            
            return Disposables.create {
                request.cancel()
            }
        })
    }
    func getBarEvents(barID: String) -> Observable<[BarEvent]> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "id": "\(barID)"
            ]
            let request = Alamofire.request(BarFunction.getBarEvents, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseArray(completionHandler: { (response: DataResponse<[BarEvent]>) in
                    switch response.result {
                    case .success(let events):
                        observer.onNext(events)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                })
            
            return Disposables.create {
                request.cancel()
            }
        })
    }
    func getBarSpecials(barID: String) -> Observable<[Special]> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "id": "\(barID)"
            ]
            let request = Alamofire.request(BarFunction.getBarSpecials, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseArray(completionHandler: { (response: DataResponse<[Special]>) in
                    switch response.result {
                    case .success(let specials):
                        observer.onNext(specials)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                })
            
            return Disposables.create {
                request.cancel()
            }
        })
    }
    func getBarsIn(region: String) -> Observable<[TopBar]> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "region": "\(region)"
            ]
            let request = Alamofire.request(BarFunction.getBarsInRegion, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseArray(completionHandler: { (response: DataResponse<[TopBar]>) in
                    switch response.result {
                    case .success(let topBars):
                        observer.onNext(topBars)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                })
            
            return Disposables.create {
                request.cancel()
            }
        })

    }
    func getEventsIn(region: String) -> Observable<[BarEvent]> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "region": "\(region)"
            ]
            let request = Alamofire.request(BarFunction.getEventsInRegion, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseArray(completionHandler: { (response: DataResponse<[BarEvent]>) in
                    switch response.result {
                    case .success(let events):
                        observer.onNext(events)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                })
            
            return Disposables.create {
                request.cancel()
            }
        })

    }
    func getSpecialsIn(region: String, type: AlcoholType, dayOfWeek: DayOfWeek) -> Observable<[Special]> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "region": "\(region)",
                "type": type.toInt(),
                "day": dayOfWeek.rawValue
            ]
            let request = Alamofire.request(BarFunction.getSpecialsInRegionByType, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseArray(completionHandler: { (response: DataResponse<[Special]>) in
                    switch response.result {
                    case .success(let specials):
                        observer.onNext(specials)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                })
            
            return Disposables.create {
                request.cancel()
            }
        })
    }
    
    func getTopBarsIn(region: String) -> Observable<[TopBar]> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "region": "\(region)"
            ]
            let request = Alamofire.request(BarFunction.getTopBarsInRegion, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseArray(completionHandler: { (response: DataResponse<[TopBar]>) in
                    switch response.result {
                    case .success(let profiles):
                        observer.onNext(profiles)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                })
            
            return Disposables.create {
                request.cancel()
            }
        })
    }
    
    func getEventLikers(eventID: String) -> Observable<[UserSnapshot]> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "id": eventID
            ]
            let request = Alamofire.request(BarFunction.getEventLikers, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseArray(completionHandler: { (response: DataResponse<[UserSnapshot]>) in
                    switch response.result {
                    case .success(let snapshots):
                        observer.onNext(snapshots)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                })
            
            return Disposables.create {
                request.cancel()
            }
        })
    }
    func getSpecialLikers(specialID: String) -> Observable<[UserSnapshot]> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "id": specialID
            ]
            let request = Alamofire.request(BarFunction.getSpecialLikers, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseArray(completionHandler: { (response: DataResponse<[UserSnapshot]>) in
                    switch response.result {
                    case .success(let snapshots):
                        observer.onNext(snapshots)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                })
            
            return Disposables.create {
                request.cancel()
            }
        })
    }
    func searchForBar(searchText: String) -> Observable<[BarSnapshot]> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "searchText": searchText
            ]
            let request = Alamofire.request(BarFunction.searchForBar, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseArray(completionHandler: { (response: DataResponse<[BarSnapshot]>) in
                    switch response.result {
                    case .success(let snapshots):
                        observer.onNext(snapshots)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                })
            
            return Disposables.create {
                request.cancel()
            }
        })
    }
    
    func getSuggestedBars(region: String) -> Observable<[BarSnapshot]> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "region": region
            ]
            let request = Alamofire.request(BarFunction.getSuggestedBars, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseArray(completionHandler: { (response: DataResponse<[BarSnapshot]>) in
                    switch response.result {
                    case .success(let profiles):
                        observer.onNext(profiles)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                })
            
            return Disposables.create {
                request.cancel()
            }
        })
    }
    
    func isAttending(userID: String, barID: String) -> Observable<Bool> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "id": userID,
                "barId": barID
            ]
            let request = Alamofire.request(BarFunction.isAttending, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success(let value):
                        if let isAttending = value as? Bool {
                            observer.onNext(isAttending)
                            observer.onCompleted()
                            
                        } else {
                            observer.onError(APIError.jsonCastingFailure)
                        }
                    case .failure(let error):
                        observer.onError(error)
                    }
                })
            
            return Disposables.create {
                request.cancel()
            }
        })
    }
}
