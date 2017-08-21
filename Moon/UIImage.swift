//
//  UIImage.swift
//  Moon
//
//  Created by Evan Noble on 8/8/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func isEqualToImage(image: UIImage) -> Bool {
        let data1: Data = UIImagePNGRepresentation(self)!
        let data2: Data = UIImagePNGRepresentation(image)!
        return data1 == data2
    }
    
}
