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
    private let imageSource: SnapshotImageSource
    
    // Inputs
    
    // Outputs
    var mainLabelText: Observable<String?> {
        return snapshot.map {$0.name}
    }
    
    var mainImage: Observable<UIImage> {
        return snapshot.map {$0.id}
            .errorOnNil()
            .flatMap({ id -> Observable<UIImage> in
                switch self.imageSource {
                case .group:
                    return self.storageAPI.getGroupPictureDownloadURLForGroup(id: id)
                        .errorOnNil()
                        .flatMap({
                            self.photoService.getImageFor(url: $0)
                        })
                default:
                    fatalError("Not Implemented")
                }
                
            })
            .catchErrorJustReturn(#imageLiteral(resourceName: "DefaultGroupPic"))
    }
    
    init(snapshot: Snapshot, imageSource: SnapshotImageSource) {
        self.snapshot = Observable.just(snapshot)
        self.imageSource = imageSource
    }
}
