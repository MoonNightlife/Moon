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

struct SpecialCell {
    let description: String
    let likes: String
    let image: UIImage
    let barName: String
    let id: String
    let barID: String
    
    init(from special: Specials) {
        self.description = special.description ?? ""
        self.likes = "\(special.numLikes ?? 0)"
        self.barName = special.name ?? ""
        self.id = special.id ?? ""
        self.barID = special.barID ?? ""
        self.image = #imageLiteral(resourceName: "s10.jpg")
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
