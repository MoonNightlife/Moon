//
//  ParentType.swift
//  Moon
//
//  Created by Evan Noble on 6/12/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import UIKit

protocol ParentType {
    var view1: UIView! {get set}
    var view2: UIView! {get set}
}

extension ParentType where Self: UIViewController {
    func generateChildern(child1: UIViewController, child2: UIViewController) {
        addChildViewController(child1)
        addChildViewController(child2)
        
        child1.view.frame = CGRect(x: 0, y: 0, width: view1.frame.width, height: view1.frame.height)
        child2.view.frame = CGRect(x: 0, y: 0, width: view2.frame.width, height: view2.frame.height)
        
        view1.addSubview(child1.view)
        view2.addSubview(child2.view)
        
        child1.didMove(toParentViewController: self)
        child2.didMove(toParentViewController: self)
        
        view1.isHidden = false
        view2.isHidden = true
    }
    
    func showView(view: Int) {
        switch view {
        case 1:
            view1.isHidden = false
            view2.isHidden = true
        case 2:
            view1.isHidden = true
            view2.isHidden = false
        default:
            view1.isHidden = true
            view2.isHidden = true
        }
    }
}
