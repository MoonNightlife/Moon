//
//  StorageAPIType.swift
//  Moon
//
//  Created by Evan Noble on 7/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import RxSwift
import Foundation

protocol StorageAPIType {
    func uploadProfilePictureFrom(data: Data, forUser id: String) -> Observable<Void>
}
