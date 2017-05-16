//
//  MoonFont.swift
//  Moon
//
//  Created by Evan Noble on 5/16/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    static func moonFont(size: CGFloat) -> UIFont {
        guard let moonFont = UIFont(name: "Roboto", size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        
        return moonFont
    }
}
