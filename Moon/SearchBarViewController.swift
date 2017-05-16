//
//  SearchBarControllerViewController.swift
//  Moon
//
//  Created by Evan Noble on 5/15/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Material

class SearchBarViewController: SearchBarController {
    fileprivate var profileButton: IconButton!
    fileprivate var settingsButton: IconButton!
    
    open override func prepare() {
        super.prepare()
        prepareProfileButton()
        prepareSettingsButton()
        prepareStatusBar()
        prepareSearchBar()
    }
}

extension SearchBarViewController {
    fileprivate func prepareProfileButton() {
        
        // Resize the icon to match the icons in material design
        let sizeReference = Icon.cm.moreVertical
    
        let profileIconImage = #imageLiteral(resourceName: "ProfileIcon").withRenderingMode(.alwaysTemplate).tint(with: .lightGray)?.resize(toWidth: (sizeReference?.width)!)?.resize(toHeight: (sizeReference?.height)!)
        
        profileButton = IconButton(image: profileIconImage)
    }
    
    fileprivate func prepareSettingsButton() {
        
        settingsButton = IconButton(image: Icon.cm.settings?.tint(with: .lightGray))
    }
    
    fileprivate func prepareStatusBar() {
        statusBarStyle = .lightContent
    }
    
    fileprivate func prepareSearchBar() {
        searchBar.leftViews = [profileButton]
        searchBar.rightViews = [settingsButton]
        
    }
}
