//
//  UserAPIType.swift
//  Moon
//
//  Created by Evan Noble on 7/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift

protocol UserAPIType {
    func acceptFriend(userID: String, friendID: String) -> Observable<Void>
    func declineFriend(userID: String, friendID: String) -> Observable<Void>
    func requestFriend(userID: String, friendID: String) -> Observable<Void>
    func getFriendRequest(userID: String) -> Observable<[Snapshot]>
    
    func blockUser(userID: String, blockID: String) -> Observable<Void>
    func unblockUser(userID: String, blockID: String) -> Observable<Void>
    func getBlockedUserList(userID: String) -> Observable<[Snapshot]>
    
    func getFriends(userID: String) -> Observable<[Snapshot]>
    func getUserProfile(userID: String) -> Observable<UserProfile>
    func getActivityLikes(activityID: String) -> Observable<[Snapshot]>
    func getActivityFeed(userID: String) -> Observable<[Activity]>
    
    func goToBar(userID: String, barID: String) -> Observable<Void>
    func likeActivity(userID: String, activityUserID: String) -> Observable<Void>
    func likeSpecial(userID: String, specialID: String) -> Observable<Void>
    func likeEvent(userID: String, eventID: String) -> Observable<Void>
    func update(profile: UserProfile) -> Observable<Void>
}
