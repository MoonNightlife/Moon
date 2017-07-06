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
import AlamofireObjectMapper

struct FirebaseUserAPI: UserAPIType {
    
    struct UserFunction {
        private static let userBaseURL = "https://us-central1-moon-4409e.cloudfunctions.net/"
        
        static let updateProfile = userBaseURL + "updateProfile"
        static let getUserProfile = userBaseURL + "getUserProfile"
        static let getFriends = userBaseURL + "getFriends"
        static let updatePhotoUrls = userBaseURL + "updatePhotoUrls"
        
        static let requestFriend = userBaseURL + "requestFriend"
        static let getFriendRequest = userBaseURL + "getFriendRequest"
        static let declineFriendRequest = userBaseURL + "declineFriendRequest"
        static let acceptFriendRequest = userBaseURL + "acceptFriendRequest"
        
        static let likeSpecial = userBaseURL + "likeSpecial"
        static let likeActivity = userBaseURL + "likeActivity"
        
        static let getActivityLikes = userBaseURL + "getActivityLikes"
        static let getActivityFeed = userBaseURL + "getActivityFeed"
    }
    
    func acceptFriend(userID: String, friendID: String) -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "userId": "\(userID)",
                "friendID": "\(friendID)"
            ]
            let request = Alamofire.request(UserFunction.acceptFriendRequest, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .response(completionHandler: {
                    if let e = $0.error {
                        observer.onError(e)
                    } else {
                        observer.onNext()
                        observer.onCompleted()
                    }
                })
            
            return Disposables.create {
                request.cancel()
            }
        })
    }
    
    func declineFriend(userID: String, friendID: String) -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "userId": "\(userID)",
                "friendID": "\(friendID)"
            ]
            let request = Alamofire.request(UserFunction.declineFriendRequest, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .response(completionHandler: {
                    if let e = $0.error {
                        observer.onError(e)
                    } else {
                        observer.onNext()
                        observer.onCompleted()
                    }
                })
            
            return Disposables.create {
                request.cancel()
            }
        })
    }
    
    func requestFriend(userID: String, friendID: String) -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "userId": "\(userID)",
                "friendID": "\(friendID)"
            ]
            let request = Alamofire.request(UserFunction.requestFriend, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .response(completionHandler: {
                    if let e = $0.error {
                        observer.onError(e)
                    } else {
                        observer.onNext()
                        observer.onCompleted()
                    }
                })
            
            return Disposables.create {
                request.cancel()
            }
        })
    }
    
    func getFriendRequest(userID: String) -> Observable<[Snapshot]> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "userId": "\(userID)"
            ]
            let request = Alamofire.request(UserFunction.getFriendRequest, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseArray(completionHandler: { (response: DataResponse<[Snapshot]>) in
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
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "userId": "\(userID)"
            ]
            let request = Alamofire.request(UserFunction.getFriends, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseArray(completionHandler: { (response: DataResponse<[Snapshot]>) in
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
    
    func getUserProfile(userID: String) -> Observable<UserProfile> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "userId": "\(userID)"
            ]
            let request = Alamofire.request(UserFunction.getUserProfile, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseObject(completionHandler: { (response: DataResponse<UserProfile>) in
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
    
    func getActivityLikes(activityID: String) -> Observable<[Snapshot]> {
        return Observable.empty()
    }
    func getActivityFeed(userID: String) -> Observable<[Activity]> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "id": "\(userID)"
            ]
            let request = Alamofire.request(UserFunction.getActivityFeed, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
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
    
    func goToBar(userID: String, barID: String) -> Observable<Void> {
        return Observable.empty()
    }
    func likeActivity(userID: String, activityUserID: String) -> Observable<Void> {
        return Observable.empty()
    }
    func likeSpecial(userID: String, specialID: String) -> Observable<Void> {
        return Observable.empty()
    }
    func likeEvent(userID: String, eventID: String) -> Observable<Void> {
        return Observable.empty()
    }
    func update(profile: UserProfile) -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = profile.toJSON()
            let request = Alamofire.request(UserFunction.updateProfile, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .response(completionHandler: {
                    if let e = $0.error {
                        observer.onError(e)
                    } else {
                        observer.onNext()
                        observer.onCompleted()
                    }
                })
            
            return Disposables.create {
                request.cancel()
            }
        })
    }
}
