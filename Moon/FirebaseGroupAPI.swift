//
//  FirebaseGroupAPI.swift
//  Moon
//
//  Created by Evan Noble on 7/26/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import ObjectMapper
import RxOptional
import Alamofire
import AlamofireObjectMapper

struct FirebaseGroupAPI: GroupAPIType {

    struct GroupFunction {
        private static let groupBaseURL = "https://us-central1-moon-4409e.cloudfunctions.net/"
        
        static let createGroup = groupBaseURL + "createGroup"
        static let updateGroupName = groupBaseURL + "updateGroupName"
        static let removeUserFromGroup = groupBaseURL + "removeUserFromGroup"
        static let addUserToGroup = groupBaseURL + "addUserToGroup"
        static let getGroup = groupBaseURL + "getGroup"
        static let getGroupMembers = groupBaseURL + "getGroupMembers"
        static let getGroupMembersWithStatus = groupBaseURL + "getMembersWithStatus"
        static let getMembersActivity = groupBaseURL + "getMembersActivity"
        static let startPlan = groupBaseURL + "startPlan"
        static let addVenueToPlan = groupBaseURL + "addVenueToPlan"
        //TODO: Check functions name once implemented
        static let placeVote = groupBaseURL + "voteForVenue"
        static let checkGroupStatus = groupBaseURL + "getGroupStatus"
        static let getGroupsForUser = groupBaseURL + "getGroupsForUser"
        static let getActivityGroupLikers = groupBaseURL + "getActivityGroupLikers"
    }
    
    func createGroup(groupName: String, members: [String]) -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "groupName": groupName,
                "members": members
            ]
            let request = Alamofire.request(GroupFunction.createGroup, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
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
    
    func updateGroupName(groupName: String) -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "groupName": groupName
            ]
            let request = Alamofire.request(GroupFunction.updateGroupName, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
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
    
    func removeUserFromGroup(groupID: String, userID: String) -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "id": groupID,
                "userId": userID
            ]
            let request = Alamofire.request(GroupFunction.removeUserFromGroup, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
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
    
    func addUserToGroup(groupID: String, userID: String) -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "id": groupID,
                "userId": userID
            ]
            let request = Alamofire.request(GroupFunction.addUserToGroup, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
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
    
    func getGroup(groupID: String) -> Observable<Group> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "id": groupID
            ]
            let request = Alamofire.request(GroupFunction.getGroup, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseObject(completionHandler: { (response: DataResponse<Group>) in
                    switch response.result {
                    case .success(let group):
                        observer.onNext(group)
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
    
    func getGroupMembers(groupID: String) -> Observable<[GroupMemberSnapshot]> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "id": groupID
            ]
            let request = Alamofire.request(GroupFunction.getGroupMembers, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseArray(completionHandler: { (response: DataResponse<[GroupMemberSnapshot]>) in
                    switch response.result {
                    case .success(let groupSnapshot):
                        observer.onNext(groupSnapshot)
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
    
    func getGroupMembersWithStatus(groupID: String) -> Observable<[GroupMemberSnapshot]> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "id": groupID
            ]
            let request = Alamofire.request(GroupFunction.getGroupMembersWithStatus, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseArray(completionHandler: { (response: DataResponse<[GroupMemberSnapshot]>) in
                    switch response.result {
                    case .success(let groupSnapshot):
                        observer.onNext(groupSnapshot)
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
    
    func getMembersActivity(groupID: String) -> Observable<[Activity]> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "id": groupID
            ]
            let request = Alamofire.request(GroupFunction.getMembersActivity, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseArray(completionHandler: { (response: DataResponse<[Activity]>) in
                    switch response.result {
                    case .success(let groupSnapshot):
                        observer.onNext(groupSnapshot)
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
    
    func startPlan(groupID: String, endTime: Double) -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "id": groupID,
                "endTime": endTime
            ]
            let request = Alamofire.request(GroupFunction.startPlan, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
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
    
    func addVenueToPlan(groupID: String, barID: String) -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "id": groupID,
                "barId": barID
            ]
            let request = Alamofire.request(GroupFunction.addVenueToPlan, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
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
    
    func placeVote(userID: String, groupID: String, barID: String) -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "id": groupID,
                "barId": barID,
                "userId": userID
            ]
            let request = Alamofire.request(GroupFunction.placeVote, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
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
    
    func checkGroupStatusEndpoint(userID: String, groupID: String) -> Observable<Bool> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "id": userID,
                "groupId": groupID
            ]
            let request = Alamofire.request(GroupFunction.checkGroupStatus, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
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
    
    func getGroupsForUser(userID: String) -> Observable<[GroupSnapshot]> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "id": userID
            ]
            let request = Alamofire.request(GroupFunction.getGroupsForUser, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseArray(completionHandler: { (response: DataResponse<[GroupSnapshot]>) in
                    switch response.result {
                    case .success(let groupSnapshot):
                        observer.onNext(groupSnapshot)
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
    
    func getActivityGroupLikers(groupID: String) -> Observable<[UserSnapshot]> {
        return Observable.create({ (observer) -> Disposable in
            let body: Parameters = [
                "id": groupID
            ]
            let request = Alamofire.request(GroupFunction.getActivityGroupLikers, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
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
}
