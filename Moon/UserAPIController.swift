//
//  UserAPIController.swift
//  Moon
//
//  Created by Evan Noble on 6/14/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import SwaggerClient
import RxSwift
import RxCocoa

protocol UserAPIType {
    func acceptFriend(userID: String, friendID: String) -> Observable<Void>
    func declineFriend(userID: String, friendID: String) -> Observable<Void>
    func requestFriend(userID: String, friendID: String) -> Observable<Void>
    func getFriendRequest(userID: String) -> Observable<[UserProfile]>
    
    func blockUser(userID: String, blockID: String) -> Observable<Void>
    func unblockUser(userID: String, blockID: String) -> Observable<Void>
    func getBlockedUserList(userID: String) -> Observable<[UserProfile]>
    
    func getFriends(userID: String) -> Observable<[UserProfile]>
    func getUserInfo(userID: String) -> Observable<UserProfile>
    func getUserActivity(userID: String) -> Observable<Activity>
    func getActivityLikes(activityID: String) -> Observable<[UserProfile]>
    
    func goToBar(userID: String, barID: String) -> Observable<Void>
    func likeActivity(userID: String, barID: String) -> Observable<Void>
    func update(profile: UserProfile) -> Observable<Void>
}

class UserAPIController {
    
}
