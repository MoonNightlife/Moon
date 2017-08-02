//
//  SnapshotBasicImageCellViewModel.swift
//  Moon
//
//  Created by Evan Noble on 8/1/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift

struct SnapshotBasicImageCellViewModel: BasicImageCellViewModelType, StorageNetworkingInjected, ImageNetworkingInjected {

    // Globals
    private let snapshot: Observable<Snapshot>
    
    // Inputs
    
    // Outputs
    var mainLabelText: Observable<String?> {
        return snapshot.asObservable().map {$0.name}
    }
    
    var mainImage: Observable<UIImage> {
        return snapshot.asObservable().map {$0.id}
            .errorOnNil()
            .flatMap({
                return self.storageAPI.getGroupPictureDownloadURLForGroup(id: $0)
                    .errorOnNil()
                    .flatMap({
                        self.photoService.getImageFor(url: $0)
                    })
            })
            .catchErrorJustReturn(#imageLiteral(resourceName: "DefaultGroupPic"))
    }
    
    init(snapshot: Snapshot) {
        self.snapshot = Observable.just(snapshot)
    }
}
