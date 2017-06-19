//
//  PhotoService.swift
//  Moon
//
//  Created by Evan Noble on 6/19/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import Kingfisher
import RxSwift

enum PhotoServiceError: Error {
    case unknown
}

protocol PhotoService {
    func getImageFor(url: URL) -> Observable<UIImage>
}

struct KingFisherPhotoService: PhotoService {
    
    func getImageFor(url: URL) -> Observable<UIImage> {
        
        let resouce = ImageResource(downloadURL: url)
        
        return Observable.create({ (observer) -> Disposable in
            let imageTask = KingfisherManager.shared.retrieveImage(with: resouce, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
                
                print(cacheType)
                print(url ?? "King fisher photo service returned no url")
                
                if let i = image {
                    observer.onNext(i)
                } else if let e = error {
                    observer.onError(e)
                } else {
                    observer.onError(PhotoServiceError.unknown)
                }
                observer.onCompleted()
            })
            
            return Disposables.create {
                imageTask.cancel()
            }
        })
    }
}
