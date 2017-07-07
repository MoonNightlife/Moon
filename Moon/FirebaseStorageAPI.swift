//
//  FirebaseStorageAPI.swift
//  Moon
//
//  Created by Evan Noble on 7/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import RxSwift
import Foundation
import FirebaseStorage
import FirebaseDatabase

struct FirebaseStorageAPI: StorageAPIType {
    func uploadProfilePictureFrom(data: Data, forUser id: String) -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            let ref = Storage.storage().reference().child("user").child(id).child("profilePictures").child("pic1")
            let task = ref.putData(data, metadata: nil, completion: { (_, error) in
                if let e = error {
                    observer.onError(e)
                } else {
                    observer.onNext()
                    observer.onCompleted()
                }
            })

            return Disposables.create {
                task.cancel()
            }
        })
    }
    
    func getProfilePictureDownloadUrlForUser(id: String) -> Observable<URL?> {
        return Observable.create({ (observer) -> Disposable in
            let ref = Storage.storage().reference().child(id).child("profilePictures").child("fullSize")
            ref.downloadURL(completion: { (url, error) in
                if let e = error {
                    observer.onError(e)
                }
                observer.onNext(url)
                observer.onCompleted()
            })
            
            return Disposables.create()

        })
    }
    
    func getBarPictureDownloadUrlForBar(id: String, picName: String) -> Observable<URL?> {
        return Observable.create({ (observer) -> Disposable in
            let ref = Storage.storage().reference().child("bar").child(id).child(picName)
            ref.downloadURL(completion: { (url, error) in
                if let e = error {
                    observer.onError(e)
                }
                observer.onNext(url)
                observer.onCompleted()
            })
            
            return Disposables.create()
            
        })
    }
}
