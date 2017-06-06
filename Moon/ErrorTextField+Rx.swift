//
//  TextField+Rx.swift
//  Moon
//
//  Created by Evan Noble on 6/2/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Material

extension Reactive where Base: ErrorTextField {
    
    var isErrorRevealed: UIBindingObserver<Base, Bool> {
        return UIBindingObserver(UIElement: self.base, binding: { (textField, visable) in
            textField.isErrorRevealed = visable
        })
    }
}
