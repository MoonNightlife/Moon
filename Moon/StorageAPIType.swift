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
    
    func uploadProfilePictureFrom(data: Data, forUser id: String, imageName: String) -> Observable<Void>
    func uploadGroupPictureFrom(data: Data, forGroup id: String) -> Observable<Void>
    
    func getBarPictureDownloadUrlForBar(id: String, picName: String) -> Observable<URL?>
    func getProfilePictureDownloadUrlForUser(id: String, picName: String) -> Observable<URL?>
    func getSpecialPictureDownloadUrlForSpecial(name: String, type: AlcoholType) -> Observable<URL?>
    func getEventPictureDownloadUrlForEvent(id: String) -> Observable<URL?>
    func getGroupPictureDownloadURLForGroup(id: String) -> Observable<URL?>
}
