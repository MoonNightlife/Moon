//
//  ActionButton.swift
//  Moon
//
//  Created by Evan Noble on 5/17/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import ActionButton
import UIKit

/* To be able to apply animations to the "Floating Button" the "floatingButton" property must be converted
from fileprivate to open in the podfile.
 
The super class "ActionButton" file was unlocked and edited to change the radius of the more button in moon's view.
If there ever is any erros look at the init() and look for
"self.floatButtonRadius= Int(self.parentView.frame.size.height * 0.075)"
 */

extension ActionButton {
    func fadeIn(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.floatButton.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.floatButton.alpha = 0.0
        }, completion: completion)
    }
}
