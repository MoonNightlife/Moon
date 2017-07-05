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

struct FirebaseStorageAPI: StorageAPIType {
    func uploadProfilePictureFrom(data: Data, forUser id: String) -> Observable<Void> {
        return Observable.create({ (observer) -> Disposable in
            let ref = Storage.storage().reference().child(id).child("profilePictures").child("fullSize")
            let task = ref.putData(data, metadata: nil, completion: { (_, error) in
                if let e = error {
                    observer.onError(e)
                }
                observer.onCompleted()
            })

            return Disposables.create {
                task.cancel()
            }
        })
    }
}
