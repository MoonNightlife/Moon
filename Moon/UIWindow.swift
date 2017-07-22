//
//  UIWindow.swift
//  Moon
//
//  Created by Evan Noble on 7/22/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import UIKit

/*
 If there is a modal view controller presented over old rootViewController, the rootViewController is replaced, but the old view still remains hanging below the new rootViewController's view (and can be seen for example during Flip Horizontal or Cross Dissolve transition animations) and the old view controller hierarchy remains allocated (which may cause severe memory problems if replacement happens multiple times).
 
 So the only solution is to dismiss all modal view controllers and then replace the rootViewController. A snapshot of the screen is placed over the window during dismissal and replacement to hide the ugly flashing process.
*/
extension UIWindow {
    func replaceRootViewControllerWith(_ replacementController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        let snapshotImageView = UIImageView(image: self.snapshot())
        self.addSubview(snapshotImageView)
        
        let dismissCompletion = { () -> Void in // dismiss all modal view controllers
            self.rootViewController = replacementController
            self.bringSubview(toFront: snapshotImageView)
            if animated {
                UIView.animate(withDuration: 0.4, animations: { () -> Void in
                    snapshotImageView.alpha = 0
                }, completion: { (success) -> Void in
                    snapshotImageView.removeFromSuperview()
                    completion?()
                })
            }
            else {
                snapshotImageView.removeFromSuperview()
                completion?()
            }
        }
        if self.rootViewController?.presentedViewController != nil {
            self.rootViewController!.dismiss(animated: false, completion: dismissCompletion)
        }
        else {
            dismissCompletion()
        }
    }
}
