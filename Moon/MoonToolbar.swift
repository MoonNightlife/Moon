//
//  MoonToolBar.swift
//  Moon
//
//  Created by Gabriel I Leyva Merino on 6/11/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import UIKit
import Material

class MoonToolbar: Toolbar {
    
    fileprivate var leftView: UIView!
    fileprivate var leftView2: UIView!
    
    fileprivate var rightView: UIView!
    fileprivate var rightView2: UIView!
    
    func addRightViews(view1: UIView, view2: UIView) {
        let size = CGFloat(self.frame.size.width * 0.117)
        
        print (size)
        
        view1.frame = CGRect(x: self.frame.size.width - size, y: self.frame.size.height / 3.5, width: size, height: size)
        rightView = view1
        self.addSubview(rightView)
        
        view2.frame = CGRect(x: self.frame.size.width - (view1.frame.size.width + size), y: self.frame.size.height / 3.5, width: size, height: size)
        rightView2 = view2
        self.addSubview(rightView2)
    }
    
    func addLeftViews(view1: UIView, view2: UIView) {
        let size = CGFloat(self.frame.size.width * 0.12)
        
        view1.frame = CGRect(x: size, y: self.frame.size.height / 3.5, width: size, height: size)
        leftView = view1
        self.addSubview(rightView)
        
        view2.frame = CGRect(x: view1.frame.size.width + 20, y: self.frame.size.height / 3.5, width: size, height: size)
        leftView2 = view2
        self.addSubview(rightView2)
    }
    
}

extension MoonToolbar {
    
}
