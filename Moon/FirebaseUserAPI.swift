//
//  FirebaseUserAPI.swift
//  Moon
//
//  Created by Evan Noble on 6/29/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import ObjectMapper
import RxOptional
import Alamofire

struct FirebaseUserAPI: UserAPIType {
    
    struct UserFunction {
        private static let userBaseURL = "https://us-central1-moon-4409e.cloudfunctions.net/"
        
        static let updateProfile = userBaseURL + "updateProfile"
    }
    
    func acceptFriend(userID: String, friendID: String) -> Observable<Void> {
        return Observable.empty()
    }
    func declineFriend(userID: String, friendID: String) -> Observable<Void> {
        return Observable.empty()
    }
    func requestFriend(userID: String, friendID: String) -> Observable<Void> {
        return Observable.empty()
    }
    func getFriendRequest(userID: String) -> Observable<[Snapshot]> {
        return Observable.empty()
    }
    
    func blockUser(userID: String, blockID: String) -> Observable<Void> {
        return Observable.empty()
    }
    func unblockUser(userID: String, blockID: String) -> Observable<Void> {
        return Observable.empty()
    }
    func getBlockedUserList(userID: String) -> Observable<[Snapshot]> {
        return Observable.empty()
    }
    
    func getFriends(userID: String) -> Observable<[Snapshot]> {
        return Observable.empty()
    }
    func getUserProfile(userID: String) -> Observable<UserProfile> {
        return RxAlamofire
            .requestJSON(.get, UserFunction.updateProfile)
            .map({ (_, json) -> UserProfile? in
                return Mapper<UserProfile>().map(JSONObject: json)
            })
            .errorOnNil()
            
    }
    func getActivityLikes(activityID: String) -> Observable<[Snapshot]> {
        return Observable.empty()
    }
    func getActivityFeed(userID: String) -> Observable<[Activity]> {
        return Observable.empty()
    }
    
    func goToBar(userID: String, barID: String) -> Observable<Void> {
        return Observable.empty()
    }
    func likeActivity(userID: String, activityID: String) -> Observable<Void> {
        return Observable.empty()
    }
    func likeSpecial(userID: String, specialID: String) -> Observable<Void> {
        return Observable.empty()
    }
    func likeEvent(userID: String, eventID: String) -> Observable<Void> {
        return Observable.empty()
    }
    func update(profile: UserProfile) -> Observable<Void> {
        return Observable.empty()
    }
}
