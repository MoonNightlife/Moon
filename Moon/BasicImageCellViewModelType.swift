//
//  BasicImageCellViewModelType.swift
//  Moon
//
//  Created by Evan Noble on 8/2/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import Action

protocol BasicImageCellViewModelType {
    // Outputs
    var mainLabelText: Observable<String?> { get }
    var mainImage: Observable<UIImage> { get }
    var accessoryButtonImage: Observable<UIImage> { get }
    var accessoryButtonEnabled: Observable<Bool> { get }
}

extension BasicImageCellViewModelType {
    var accessoryButtonEnabled: Observable<Bool> {
        return Observable.just(false)
    }
}
