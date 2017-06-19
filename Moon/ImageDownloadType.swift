//
//  ImageDownloadType.swift
//  Moon
//
//  Created by Evan Noble on 6/19/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import Action

protocol ImageDownloadType {
    var photoService: PhotoService { get }
}

extension ImageDownloadType {
    func downloadImage(url: URL) -> Action<Void, UIImage> {
        return Action(workFactory: {
            return self.photoService.getImageFor(url: url)
        })
    }
}
