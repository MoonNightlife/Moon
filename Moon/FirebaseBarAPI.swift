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

struct FirebaseBarAPI: BarAPIType {
    
    let barBaseURL = "https://us-central1-moon-4409e.cloudfunctions.net/"
    
    func getBarFriends(barID: String, userID: String) -> Observable<[Activity]> {
        return Observable.empty()
    }
    func getBarPeople(barID: String) -> Observable<[Activity]> {
        return Observable.empty()
    }
    func getBarInfo(barID: String) -> Observable<BarProfile> {
        return Observable.empty()
    }
    func getBarEvents(barID: String) -> Observable<[BarEvent]> {
        return Observable.empty()
    }
    func getBarSpecials(barID: String) -> Observable<[Special]> {
        return Observable.empty()
    }
    func getBarsIn(region: String) -> Observable<[BarProfile]> {
        return Observable.empty()
    }
    func getEventsIn(region: String) -> Observable<[BarEvent]> {
        return Observable.empty()
    }
    func getSpecialsIn(region: String) -> Observable<[Special]> {
        return Observable.empty()
    }
    func getSpecialsIn(region: String, type: String) -> Observable<[Special]> {
        return Observable.empty()
    }
    func getTopBarsIn(region: String) -> Observable<[BarProfile]> {
        return Observable.empty()
    }
    func getEventLikes(eventID: String) -> Observable<[Snapshot]> {
        return Observable.empty()
    }
}
