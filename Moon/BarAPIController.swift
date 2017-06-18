//
//  BarAPIController.swift
//  Moon
//
//  Created by Evan Noble on 6/14/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import SwaggerClient

protocol BarAPIType {
    func getBarFriends(barID: String, userID: String) -> Observable<[UserProfile]>
    func getBarPeople(barID: String) -> Observable<[UserProfile]>
    
    func getBarInfo(barID: String) -> Observable<BarProfile>
    func getBarEvents(barID: String) -> Observable<[BarEvents]>
    func getBarSpecials(barID: String) -> Observable<[Specials]>
    
    func getBarsIn(region: String) -> Observable<[BarProfile]>
    func getEventsIn(region: String) -> Observable<[BarEvents]>
    func getSpecialsIn(region: String) -> Observable<[Specials]>
    func getTopBarsIn(region: String) -> Observable<[BarProfile]>
    
    func getEventLikes(eventID: String) -> Observable<[UserProfile]>
}

class BarAPIController: BarAPIType {
    func getBarFriends(barID: String, userID: String) -> Observable<[UserProfile]> {
        return Observable.create({ (observer) -> Disposable in
            BarAPI.getBarFriends(barID: barID, userID: userID, completion: { (profiles, error) in
                if let p = profiles {
                    observer.onNext(p)
                } else if let e = error {
                    observer.onError(e)
                }
                observer.onCompleted()
            })
            return Disposables.create()
        })
    }
    
    func getBarPeople(barID: String) -> Observable<[UserProfile]> {
        return Observable.create({ (observer) -> Disposable in
            BarAPI.getBarPeople(barID: barID, completion: { (profiles, error) in
                if let p = profiles {
                    observer.onNext(p)
                } else if let e = error {
                    observer.onError(e)
                }
                observer.onCompleted()
            })
            return Disposables.create()
        })
    }
}

extension BarAPIController {
    func getBarInfo(barID: String) -> Observable<BarProfile> {
        return Observable.create({ (observer) -> Disposable in
            BarAPI.getBarInfo(barID: barID, completion: { (profile, error) in
                if let p = profile {
                    observer.onNext(p)
                } else if let e = error {
                    observer.onError(e)
                }
                observer.onCompleted()
            })
            return Disposables.create()
        })
    }
    func getBarEvents(barID: String) -> Observable<[BarEvents]> {
        return Observable.create({ (observer) -> Disposable in
            BarAPI.listBarEvents(barID: barID, completion: { (events, error) in
                if let barEvents = events {
                    observer.onNext(barEvents)
                } else if let e = error {
                    observer.onError(e)
                }
                observer.onCompleted()
            })
            return Disposables.create()
        })
    }
    func getBarSpecials(barID: String) -> Observable<[Specials]> {
        return Observable.create({ (observer) -> Disposable in
            BarAPI.listBarSpecials(barID: barID, completion: { (specials, error) in
                if let s = specials {
                    observer.onNext(s)
                } else if let e = error {
                    observer.onError(e)
                }
                observer.onCompleted()
            })
            return Disposables.create()
        })
    }
}

extension BarAPIController {
    func getBarsIn(region: String) -> Observable<[BarProfile]> {
        return Observable.create({ (observer) -> Disposable in
            BarAPI.listBars(region: region, completion: { (profiles, error) in
                if let p = profiles {
                    observer.onNext(p)
                } else if let e = error {
                    observer.onError(e)
                }
                observer.onCompleted()
            })
            return Disposables.create()
        })
    }
    func getEventsIn(region: String) -> Observable<[BarEvents]> {
        return Observable.create({ (observer) -> Disposable in
            print("No Correct APi Call yet")
            observer.onCompleted()
            return Disposables.create()
        })
    }
    func getSpecialsIn(region: String) -> Observable<[Specials]> {
        return Observable.create({ (observer) -> Disposable in
            BarAPI.listSpecials(region: region, completion: { (specials, error) in
                if let s = specials {
                    //TODO: API should return array of specials
                    observer.onNext([s])
                } else if let e = error {
                    observer.onError(e)
                }
                observer.onCompleted()
            })
            return Disposables.create()
        })
    }
    func getTopBarsIn(region: String) -> Observable<[BarProfile]> {
        return Observable.create({ (observer) -> Disposable in
            BarAPI.listTop(region: region, completion: { (profiles, error) in
                if let p = profiles {
                    observer.onNext(p)
                } else if let e = error {
                    observer.onError(e)
                }
                observer.onCompleted()
            })
            return Disposables.create()
        })
    }
}

extension BarAPIController {
    func getEventLikes(eventID: String) -> Observable<[UserProfile]> {
        return Observable.create({ (observer) -> Disposable in
            BarAPI.listLiked(eventID: eventID, completion: { (profiles, error) in
                if let p = profiles {
                    observer.onNext(p)
                } else if let e = error {
                    observer.onError(e)
                }
                observer.onCompleted()
            })
            return Disposables.create()
        })
    }
}
