//
//  SpecialCell.swift
//  Moon
//
//  Created by Evan Noble on 6/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import UIKit
import RxDataSources
import SwaggerClient
import Action

struct SpecialCell {
    let description: String
    let likes: String
    let barName: String
    let id: String
    let barID: String
    let imageURL: URL
    
    init(from special: Specials) {
        self.description = special.description ?? ""
        self.likes = "\(special.numLikes ?? 0)"
        self.barName = special.name ?? ""
        self.id = special.id ?? ""
        self.barID = special.barID ?? ""
        self.imageURL = baseURL.appendingPathComponent(special.pic ?? "")
        
    }
}

extension SpecialCell: Equatable {
    static func == (lhs: SpecialCell, rhs: SpecialCell) -> Bool {
        return lhs.id == rhs.id && lhs.likes == rhs.likes
    }
}

extension SpecialCell: IdentifiableType {
    var identity: String {
        return id 
    }
}
