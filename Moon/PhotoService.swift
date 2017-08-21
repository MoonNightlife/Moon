//
//  PhotoService.swift
//  Moon
//
//  Created by Evan Noble on 7/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import RxSwift
import Foundation

enum PhotoServiceError: Error {
    case unknown
}

protocol PhotoService {
    func getImageFor(url: URL) -> Observable<UIImage>
    func getImageAndNameFor(url: URL) -> Observable<(image: UIImage, imageName: String)>
}
