//
//  StorageAPIType.swift
//  Moon
//
//  Created by Evan Noble on 7/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import RxSwift
import Foundation

enum StorageError: Error {
    case unknown
}

protocol StorageAPIType {
    func uploadProfilePictureFrom(data: Data, forUser id: String) -> Observable<Void>
    func getBarPictureDownloadUrlForBar(id: String, picName: String) -> Observable<URL?>
    func getProfilePictureDownloadUrlForUser(id: String) -> Observable<URL?>
}
