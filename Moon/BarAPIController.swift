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

let baseURL = URL(string: "http://localhost:8081")!

protocol BarAPIType {
    func getBarFriends(barID: String, userID: String) -> Observable<[UserSnapshot]>
    func getBarPeople(barID: String) -> Observable<[UserSnapshot]>
    
    func getBarInfo(barID: String) -> Observable<BarProfile>
    func getBarEvents(barID: String) -> Observable<[BarEvent]>
    func getBarSpecials(barID: String) -> Observable<[Special]>
    
    func getBarsIn(region: String) -> Observable<[BarProfile]>
    func getEventsIn(region: String) -> Observable<[BarEvent]>
    func getSpecialsIn(region: String) -> Observable<[Special]>
    func getTopBarsIn(region: String) -> Observable<[BarProfile]>
    
    func getEventLikes(eventID: String) -> Observable<[UserProfile]>
}

class BarAPIController: BarAPIType {
    func getBarFriends(barID: String, userID: String) -> Observable<[UserSnapshot]> {
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
    
    func getBarPeople(barID: String) -> Observable<[UserSnapshot]> {
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
    func getBarEvents(barID: String) -> Observable<[BarEvent]> {
        return Observable.create({ (observer) -> Disposable in
            BarAPI.listBarEvent(barID: barID, completion: { (events, error) in
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
    func getBarSpecials(barID: String) -> Observable<[Special]> {
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
    func getEventsIn(region: String) -> Observable<[BarEvent]> {
        return Observable.create({ (observer) -> Disposable in
            BarAPI.listEvents(region: region, completion: { (events, error) in
                if let e = events {
                    observer.onNext(e)
                } else if let er = error {
                    observer.onError(er)
                }
                observer.onCompleted()
            })
            return Disposables.create()
        })
    }
    func getSpecialsIn(region: String) -> Observable<[Special]> {
        return Observable.create({ (observer) -> Disposable in
            BarAPI.listSpecials(region: region, completion: { (specials, error) in
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
    func getTopBarsIn(region: String) -> Observable<[BarProfile]> {
        return Observable.create({ (observer) -> Disposable in
            BarAPI.listTop(region: region, completion: { (profiles, error) in
                if let p = profiles {
                    observer.onNext(p)
                } else if let e = error {
                    print(e)
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
