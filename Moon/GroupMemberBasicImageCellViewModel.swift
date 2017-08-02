//
//  GroupMemberBasicImageCellViewModel.swift
//  Moon
//
//  Created by Evan Noble on 8/2/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import Material

struct GroupMemberBasicImageCellViewModel: BasicImageCellViewModelType, StorageNetworkingInjected, ImageNetworkingInjected {
    // Global
    private let groupMember: Observable<GroupMemberSnapshot>
    
    // Outputs
    var mainLabelText: Observable<String?> {
        return groupMember.map {$0.name}
    }
    
    var mainImage: Observable<UIImage> {
        return groupMember.map {$0.id}
            .errorOnNil()
            .flatMap({ id -> Observable<UIImage> in
                return self.storageAPI.getProfilePictureDownloadUrlForUser(id: id, picName: "pic1.jpg")
                    .errorOnNil()
                    .flatMap({
                        self.photoService.getImageFor(url: $0)
                    })
            })
            .catchErrorJustReturn(#imageLiteral(resourceName: "DefaultGroupPic"))

    }
    
    var accessoryButtonImage: Observable<UIImage?> {
        return groupMember.map {$0.isGoing}
            .filterNil()
            .map {
                if $0 {
                    return Icon.cm.check?.tint(with: .moonGreen)
                } else {
                    return Icon.cm.close?.tint(with: .moonRed)
                }
            }
    }
        
    var accessoryButtonEnabled: Observable<Bool> {
            return Observable.just(true)
    }
    
    init(groupMemberSnapshot: GroupMemberSnapshot) {
        self.groupMember = Observable.just(groupMemberSnapshot)
        
    }
}
