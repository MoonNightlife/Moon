//
//  ManageGroupViewModel.swift
//  Moon
//
//  Created by Evan Noble on 7/23/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import Action
import RxOptional
import RxCocoa
import RxSwift

class ManageGroupViewModel: BackType, NetworkingInjected, AuthNetworkingInjected, StorageNetworkingInjected, ImageNetworkingInjected {
    // MARK: - Global
    private let groupID: String
    private let bag = DisposeBag()
    private var dateFormatter: DateFormatter! {
        let df = DateFormatter()
        df.dateFormat = "h:mm"
        return df
    }
    private var members = Variable<[GroupMemberSnapshot]>([])
    private var selectedVenueSnapshot = Variable<Snapshot?>(nil)
    private var group = Variable<Group?>(nil)
    private var hasLikedPlan = Variable<Bool>(false)
    private var optionVotedFor = Variable<String?>(nil)
    
    // MARK: - Dependencies
    var sceneCoordinator: SceneCoordinatorType
    
    // MARK: - Actions
    lazy var onViewProfile: Action<String, Void> = { this in
        return Action {
            let vm = ProfileViewModel(coordinator: this.sceneCoordinator, userID: $0)
            return self.sceneCoordinator.transition(to: Scene.User.profile(vm), type: .popover)
        }
    }(self)
    
    lazy var onViewVenue: Action<String, Void> = { this in
        return Action {
            let vm = BarProfileViewModel(coordinator: this.sceneCoordinator, barID: $0)
            return self.sceneCoordinator.transition(to: Scene.Bar.profile(vm), type: .modal)
        }
    }(self)
    
    // MARK: - Inputs
    var venueSearchText = PublishSubject<String>()
    var selectedVenue = PublishSubject<SearchSnapshotSectionModel.Item>()
    var reloadMembers = PublishSubject<Void>()
    var reloadGroup = BehaviorSubject<Void>(value: ())
    
    // MARK: - Outputs
    var showBlockingLoadingIndicator = Variable<Bool>(false)
    var showSearchLoadingIndicator = Variable<Bool>(false)
    
    var showActivityHeartAndNumber: Observable<Bool> {
        return group.asObservable().filterNil()
            .map({
                return $0.activityInfo == nil ? false : true
            })
            .startWith(false)
    }
    
    var groupImage: Observable<UIImage> {
        return reloadGroup.flatMap({
            return self.storageAPI.getGroupPictureDownloadURLForGroup(id: self.groupID)
                .errorOnNil()
                .flatMap({
                    self.photoService.getImageFor(url: $0)
                })
                .catchErrorJustReturn(#imageLiteral(resourceName: "DefaultGroupPic"))
        })
    }
    
    var planInProcess: Observable<Bool> {
        return group.asObservable()
            .map({
                return $0?.plan?.startTime == nil ? false : true
            })
    }
    
    var displayMembers: Observable<[GroupMemberSectionModel]> {
        return members.asObservable()
            .map({
                [GroupMemberSectionModel(header: "Members", items: $0)]
            })
    }
    
    var displayOptions: Observable<[PlanOptionSectionModel]> {
        return Observable.zip(group.asObservable(), optionVotedFor.asObservable())
            .map({
                $0.0?.plan?.options?.map({
                    var temp = $0

                    if $0.barID == self.optionVotedFor.value {
                        temp.userVoted = true
                    } else {
                        temp.userVoted = false
                    }
                    return temp
                })
            })
            .filterNil()
            .map({
                [PlanOptionSectionModel(header: "Options", items: $0)]
            })
    }
    
    var venueSearchResults: Observable<[SearchSnapshotSectionModel]> {
        return venueSearchText
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest({ [unowned self] searchText -> Observable<[BarSnapshot]> in
                if searchText.isEmpty {
                    return Observable.just([])
                } else {
                    return self.barAPI.searchForBar(searchText: searchText)
                        .do(onSubscribed: {
                            self.showSearchLoadingIndicator.value = true
                        }, onDispose: {
                            self.showSearchLoadingIndicator.value = false
                        })
                }
            })
            .map({
                return [SearchSnapshotSectionModel.snapshotsToSnapshotSectionModel(withTitle: "Venues", snapshots: $0), SearchSnapshotSectionModel.loadingSectionModel()]
            })
    }
    
    var currentPlanBarName: Observable<String?> {
        return group.asObservable().filterNil()
            .map({
                $0.activityInfo?.barName
            })
            .startWith("No Plan")
    }
    
    var currentPlanNumberOfLikes: Observable<String?> {
        return group.asObservable()
            .map({
                $0?.activityInfo?.numberOfLikes
            })
            .filterNil()
            .map({
                "\($0)"
            })
            .startWith("0")
    }
    
    var groupName: Observable<String?> {
        return group.asObservable().filterNil()
            .map({
                $0.name
            })
    }
    
    var selectedVenueText: Observable<String?> {
        return selectedVenueSnapshot.asObservable()
            .map({
                $0?.name
            })
    }
    
    var hasLikedGroupPlan: Observable<Bool> {
        return hasLikedPlan.asObservable()
    }
    
    init(sceneCoordinator: SceneCoordinatorType, groupID: String) {
        self.sceneCoordinator = sceneCoordinator
        self.groupID = groupID
        
        reloadGroup
            .flatMap({
                return self.groupAPI.getGroup(groupID: groupID)
                    .do(onSubscribe: { [unowned self] in
                        self.showBlockingLoadingIndicator.value = true
                    }, onDispose: {
                        self.showBlockingLoadingIndicator.value = false
                    })
            })
            .bind(to: group).addDisposableTo(bag)
        
        self.userAPI.hasLikedGroupActivity(userID: self.authAPI.SignedInUserID, groupID: self.groupID).bind(to: hasLikedPlan).addDisposableTo(bag)
        
        Observable.combineLatest(group.asObservable(), reloadMembers)
            .flatMap({ [unowned self] group, _ -> Observable<[GroupMemberSnapshot]> in
                
                guard group != nil else {
                    return Observable.empty()
                }
                
                if group?.activityInfo == nil {
                    return self.groupAPI.getGroupMembers(groupID: self.groupID)
                } else {
                    return self.groupAPI.getGroupMembersWithStatus(groupID: self.groupID)
                }
            })
            .bind(to: members)
            .addDisposableTo(bag)
        
        selectedVenue
            .map({ searchResult -> Snapshot? in
                if case let .searchResult(snapshot) = searchResult {
                    return snapshot
                } else {
                    return nil
                }
            })
            .bind(to: selectedVenueSnapshot)
            .addDisposableTo(bag)
        
        reloadGroup
            .flatMap({
                return self.groupAPI.getOptionVotedFor(groupID: self.groupID, userID: self.authAPI.SignedInUserID)
            })
            .bind(to: optionVotedFor)
            .addDisposableTo(bag)
    }
    
    func onEdit() -> CocoaAction {
        return CocoaAction { [unowned self] in
            let vm = CreateEditGroupViewModel(sceneCoordinator: self.sceneCoordinator, groupID: self.groupID)
            return self.sceneCoordinator.transition(to: Scene.Group.editGroup(vm), type: .push)
        }
    }
    
    func onChangeAttendance() -> CocoaAction {
        return CocoaAction { [unowned self] in
            return self.userAPI.goWithGroup(userID: self.authAPI.SignedInUserID, groupID: self.groupID, timeStamp: Date().timeIntervalSince1970)
        }
    }
    
    func onStartPlan() -> CocoaAction {
        return CocoaAction { [unowned self] in
            return self.groupAPI.startPlan(groupID: self.groupID, startTime: Date().timeIntervalSince1970)
        }
    }
    
    func onAddVenue() -> CocoaAction {
        return CocoaAction { [unowned self] in
            guard let snapshot = self.selectedVenueSnapshot.value, let selectedBarID = snapshot.id else {
                return Observable.just()
            }
            
            return self.groupAPI.addVenueToPlan(groupID: self.groupID, barID: selectedBarID, userID: self.authAPI.SignedInUserID)
                .do(onNext: { [unowned self] in
                    self.venueSearchText.onNext("")
                    self.selectedVenueSnapshot.value = nil
                    self.reloadGroup.onNext()
                })
        }
    }
    
    func onVote(barID: String) -> CocoaAction {
        return CocoaAction { [unowned self] in
            return self.groupAPI.placeVote(userID: self.authAPI.SignedInUserID, groupID: self.groupID, barID: barID)
                .do(onNext: { [unowned self] in
                    self.reloadGroup.onNext()
                })
        }
    }
    
    func onLikePlan() -> CocoaAction {
        return CocoaAction { [unowned self] in
            return self.userAPI.likeGroupActivity(userID: self.authAPI.SignedInUserID, groupID: self.groupID)
                .do(onSubscribe: {
                    guard let numLikes = self.group.value?.activityInfo?.numberOfLikes else {
                        return
                    }
                    let newNum = self.hasLikedPlan.value ? numLikes - 1 : numLikes + 1
                    self.group.value?.activityInfo?.numberOfLikes = newNum
                    self.hasLikedPlan.value = !self.hasLikedPlan.value
                })
        }
    }
    
    func onViewPlanBar() -> CocoaAction {
        return CocoaAction { [unowned self] in
            guard let barID = self.group.value?.activityInfo?.barID else {
                return Observable.just()
            }
            let vm = BarProfileViewModel(coordinator: self.sceneCoordinator, barID: barID)
            return self.sceneCoordinator.transition(to: Scene.Bar.profile(vm), type: .modal)
        }
    }
    
    func onViewLikers() -> CocoaAction {
        return CocoaAction {
            let vm = UsersTableViewModel(coordinator: self.sceneCoordinator, sourceID: .group(id: self.groupID))
            return self.sceneCoordinator.transition(to: Scene.User.usersTable(vm), type: .modal)
        }
    }
    
    func viewModelForCell(groupMemberSnapshot: GroupMemberSnapshot) -> BasicImageCellViewModelType {
        return GroupMemberBasicImageCellViewModel(groupMemberSnapshot: groupMemberSnapshot)
    }
    
    func onShowTutorial() -> CocoaAction {
        return CocoaAction { _ in
            let vm = TutorialViewModel(sceneCoordinator: self.sceneCoordinator, type: .group)
            return self.sceneCoordinator.transition(to: Scene.Master.tutorial(vm), type: .popover)
        }
    }

}
