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
        let size = CGFloat(20)
        print(self.frame.size.width)
    
        view1.frame = CGRect(x: self.frame.size.width - size, y: (self.frame.size.height / 2) - (size / 2), width: size, height: size)
        rightView = view1
        rightView.frame = view1.frame
        self.addSubview(rightView)
        
        view2.frame = CGRect(x: self.frame.size.width - (view1.frame.size.width + size), y:  (self.frame.size.height / 2) - (size / 2), width: size, height: size)
        rightView2 = view2
        rightView2.frame = view2.frame
        self.addSubview(rightView2)
    }
    
    func addLeftViews(view1: UIView, view2: UIView) {
        let size = CGFloat(20)
        
        view1.frame = CGRect(x: 5, y: (self.frame.size.height / 2) - (size / 2), width: size, height: size)
        leftView = view1
        leftView.frame = view1.frame
        self.addSubview(leftView)
        
        view2.frame = CGRect(x: view1.frame.size.width + 5, y: (self.frame.size.height / 2) - (size / 2), width: size, height: size)
        leftView2 = view2
        leftView2.frame = view2.frame
        self.addSubview(leftView2)
    }
    
    func addRightView(view: UIView) {
        let size = CGFloat(20)
        
        view.frame = CGRect(x: self.frame.size.width - size, y: (self.frame.size.height / 2) - (size / 2), width: self.frame.size.width / 2, height: size)
        rightView = view
        rightView.frame = view.frame
        
        self.addSubview(rightView)
    }
    
    func addLeftView(view: UIView) {
        let size = CGFloat(20)
        
        view.frame = CGRect(x: 5, y: (self.frame.size.height / 2) - (size / 2), width: self.frame.size.width / 2, height: size)
        leftView = view
        leftView.frame = view.frame
        
        self.addSubview(leftView)
    }
    
}
