//
//  GroupAPIType.swift
//  Moon
//
//  Created by Evan Noble on 7/26/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift

protocol GroupAPIType {
    func createGroup(groupName: String, memebers: [String]) -> Observable<Void>
    func updateGroupName(groupName: String) -> Observable<Void>
    func removeUserFromGroup(groupID: String, userID: String) -> Observable<Void>
    func addUserToGroup(groupID: String, userID: String) -> Observable<Void>
    func getGroup(groupID: String) -> Observable<Group>
    func getGroupMembers(groupID: String) -> Observable<[GroupMemberSnapshot]>
    func getGroupMembersWithStatus(groupID: String) -> Observable<[GroupMemberSnapshot]>
    func startPlan(groupID: String, endTime: Double) -> Observable<Void>
    func addVenueToPlan(groupID: String, barID: String) -> Observable<Void>
    func placeVote(userID: String, groupID: String, barID: String) -> Observable<Void>
    func checkGroupStatusEndpoint(userID: String, groupID: String) -> Observable<Bool>
}
