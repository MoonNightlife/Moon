//
//  UIView.swift
//  Moon
//
//  Created by Evan Noble on 7/22/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
}
