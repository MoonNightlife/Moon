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

protocol FloatingBottomTabBarDelegate: class {
    func showFeaturedView()
    func showExploreView()
    func showMoonsView()
}

class FloatingBottomTabBar: Bar {
    
    var featuredButton: IconButton!
    var exploreButton: IconButton!
    var moonsViewButton: IconButton!
    var floting: MDCFloatingButton!
    
    weak var delegate: FloatingBottomTabBarDelegate!
    
    func initializeTabBar() {
        setupFeaturedButton()
        setupExploreButton()
        setupMoonsViewButton()
        setupTabBar()
    }

}

extension FloatingBottomTabBar {
    fileprivate func setupFeaturedButton() {
       // let featuredImage = #imageLiteral(resourceName: "eventsSM").withRenderingMode(.alwaysTemplate)
 
        featuredButton = IconButton(image: #imageLiteral(resourceName: "eventsSM"))
        featuredButton.addTarget(self, action: #selector(featuredButtonClicked), for: .touchUpInside)
        
    }
    
    fileprivate func setupExploreButton() {
        //let exploreImage = #imageLiteral(resourceName: "searchLG").withRenderingMode(.alwaysTemplate)
        
        exploreButton = IconButton(image: #imageLiteral(resourceName: "searchSM"))
        exploreButton.addTarget(self, action: #selector(exploreButtonClicked), for: .touchUpInside)
    }
    
    fileprivate func setupMoonsViewButton() {
        //let moonImage = #imageLiteral(resourceName: "moonSM").withRenderingMode(.alwaysTemplate)
        //moonsViewButton = IconButton(image: moonImage, tintColor: .moonPurple)
        moonsViewButton = IconButton(image: #imageLiteral(resourceName: "moonSM"))
        
        moonsViewButton.addTarget(self, action: #selector(moonsViewButtonClicked), for: .touchUpInside)
    }
    
    fileprivate func setupTabBar() {
        leftViews = [featuredButton]
        centerViews = [exploreButton]
        rightViews = [moonsViewButton]
        
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
        delegate.showFeaturedView()
    }
    
    func exploreButtonClicked() {
        delegate.showExploreView()
    }
    
    func moonsViewButtonClicked() {
        delegate.showMoonsView()
    }
}
