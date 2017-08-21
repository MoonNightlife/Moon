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
    func createGroup(groupName: String, members: [String]) -> Observable<String>
    func updateGroupName(groupID: String, groupName: String) -> Observable<Void>
    func removeUserFromGroup(groupID: String, userID: String) -> Observable<Void>
    func addUserToGroup(groupID: String, userID: String) -> Observable<Void>
    func getGroup(groupID: String) -> Observable<Group>
    func getGroupMembers(groupID: String) -> Observable<[GroupMemberSnapshot]>
    func getGroupMembersWithStatus(groupID: String) -> Observable<[GroupMemberSnapshot]>
    func isMemberOfGroup(userID: String, groupID: String) -> Observable<Bool>
    func getMembersActivity(groupID: String) -> Observable<[Activity]>
    func startPlan(groupID: String, startTime: Double) -> Observable<Void>
    func addVenueToPlan(groupID: String, barID: String) -> Observable<Void>
    func placeVote(userID: String, groupID: String, barID: String) -> Observable<Void>
    func getOptionVotedFor(groupID: String, userID: String) -> Observable<String?>
    func checkGroupStatusEndpoint(userID: String, groupID: String) -> Observable<Bool>
    func getGroupsForUser(userID: String) -> Observable<[GroupSnapshot]>
    func getActivityGroupLikers(groupID: String) -> Observable<[UserSnapshot]>
}
