//
//  FloatingBottomTabBar.swift
//  Moon
//
//  Created by Evan Noble on 5/17/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Material
import MaterialComponents

@objc protocol FloatingBottomTabBarDelegate {
    @objc optional func showFeaturedView()
    @objc optional func showExploreView()
    @objc optional func showMoonsView()
}

class FloatingBottomTabBar: Bar {
    
    var featuredButton: IconButton!
    var exploreButton: IconButton!
    var moonsViewButton: IconButton!
    var floting: MDCFloatingButton!
    var size: CGFloat!
    var contentFrame: CGSize!
    
    weak var delegate: FloatingBottomTabBarDelegate!
    
    func initializeTabBar() {
        size = self.frame.size.width * 0.25
        self.contentView.frame = self.frame
        contentFrame = self.contentView.frame.size
        
        setupFeaturedButton()
        setupExploreButton()
        setupMoonsViewButton()
        setupTabBar()
    }

}

extension FloatingBottomTabBar {
    fileprivate func setupFeaturedButton() {
        featuredButton = IconButton(image: #imageLiteral(resourceName: "eventsSM"))
        featuredButton.addTarget(self, action: #selector(featuredButtonClicked), for: .touchUpInside)
        
    }
    
    fileprivate func setupExploreButton() {
        exploreButton = IconButton(image: #imageLiteral(resourceName: "searchSM"))
        exploreButton.addTarget(self, action: #selector(exploreButtonClicked), for: .touchUpInside)
    }
    
    fileprivate func setupMoonsViewButton() {
        moonsViewButton = IconButton(image: #imageLiteral(resourceName: "moonSM"))
        moonsViewButton.addTarget(self, action: #selector(moonsViewButtonClicked), for: .touchUpInside)
    }
    
    fileprivate func addRighView(view: UIView) {
        view.frame = CGRect(x: (contentFrame.width - size) - 10, y: (contentFrame.height / 2) - (size / 2) - 5, width: size, height: size)
        
        self.contentView.addSubview(view)
        self.contentView.bringSubview(toFront: view)
    }
    
    func addLeftView(view: UIView) {
        view.frame = CGRect(x: 5, y: (contentFrame.height / 2) - (size / 2) - 5, width: size, height: size)
        
        self.contentView.addSubview(view)
        self.contentView.bringSubview(toFront: view )
    }
    
    func addCenterView(view: UIView) {
        view.frame = CGRect(x: (contentFrame.width / 2) - (size / 2), y: (contentFrame.height / 2) - (size / 2) - 5, width: size, height: size)
        
        self.contentView.addSubview(view)
        self.contentView.bringSubview(toFront: view)
    }
    
    fileprivate func setupTabBar() {
        addLeftView(view: featuredButton)
        addCenterView(view: moonsViewButton)
        addRighView(view: exploreButton)
        
        backgroundColor = Color.grey.lighten4
        cornerRadius = height / 2
        
        layer.shadowOpacity = 1
        layer.shadowRadius = 2
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowColor = UIColor.gray.cgColor
    }
}

extension FloatingBottomTabBar {
    func featuredButtonClicked() {
        delegate.showFeaturedView!()
    }
    
    func exploreButtonClicked() {
        delegate.showExploreView!()
    }
    
    func moonsViewButtonClicked() {
        delegate.showMoonsView!()
    }
}
