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

struct KingFisherPhotoService: PhotoService {
    
    private func downloadImageFor(url: URL) -> Observable<(image: UIImage, imageName: String)> {
        
        let resouce = ImageResource(downloadURL: url)
        
        return Observable.create({ (observer) -> Disposable in
            let imageTask = KingfisherManager.shared.retrieveImage(with: resouce, options: nil, progressBlock: nil, completionHandler: { (image, error, _, url) in
            
                if let i = image, let imageName = url?.lastPathComponent {
                    observer.onNext((i, imageName))
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
    
    func getImageFor(url: URL) -> Observable<UIImage> {
        return downloadImageFor(url: url)
            .map({
                return $0.image
            })
            .retryWhen(RxErrorHandlers.imageRetryHandler)
    }
    
    func getImageAndNameFor(url: URL) -> Observable<(image: UIImage, imageName: String)> {
        return downloadImageFor(url: url)
            .retryWhen(RxErrorHandlers.imageRetryHandler)
    }
    
}
