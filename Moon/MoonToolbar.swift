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
        let contentFrame = self.contentView.frame.size
    
        view1.frame = CGRect(x: contentFrame.width - size, y: (contentFrame.height / 2) - (size / 2), width: size, height: size)
        rightView = view1
        rightView.frame = view1.frame
        self.contentView.addSubview(rightView)
        self.contentView.bringSubview(toFront: rightView)
        
        view2.frame = CGRect(x: contentFrame.width - (view1.frame.size.width + size), y:  (contentFrame.height / 2) - (size / 2), width: size, height: size)
        rightView2 = view2
        rightView2.frame = view2.frame
        self.contentView.addSubview(rightView2)
        self.contentView.bringSubview(toFront: rightView2)
    }
    
    func addLeftViews(view1: UIView, view2: UIView) {
        let size = CGFloat(20)
        print(self.frame.size.width)
        let contentFrame = self.contentView.frame.size
        
        view1.frame = CGRect(x: 5, y: (contentFrame.height / 2) - (size / 2), width: size, height: size)
        leftView = view1
        leftView.frame = view1.frame
        self.contentView.addSubview(leftView)
        self.contentView.backgroundColor = .purple
        self.contentView.bringSubview(toFront: leftView)
        
        view2.frame = CGRect(x: view1.frame.size.width + 5, y: (contentFrame.height / 2) - (size / 2), width: size, height: size)
        leftView2 = view2
        leftView2.frame = view2.frame
        self.contentView.addSubview(leftView2)
        self.contentView.bringSubview(toFront: leftView2)
    }
    
    func addRightView(view: UIView) {
        let size = CGFloat(20)
        let contentFrame = self.contentView.frame.size

        view.frame = CGRect(x: contentFrame.width - size, y: (contentFrame.height / 2) - (size / 2), width: size, height: size)
        rightView = view
        rightView.frame = view.frame
        
        self.contentView.addSubview(rightView)
        self.contentView.bringSubview(toFront: rightView)
    }
    
    func addLeftView(view: UIView) {
        let size = CGFloat(20)
        let contentFrame = self.contentView.frame.size

        view.frame = CGRect(x: 5, y: (contentFrame.height / 2) - (size / 2), width: size, height: size)
        leftView = view
        leftView.frame = view.frame
        
        self.contentView.addSubview(leftView)
        self.contentView.bringSubview(toFront: leftView )
    }
    
    func getLeftView() -> UIView {
        return leftView
    }
    
    func getRightView() -> UIView {
        return rightView
    }
}
