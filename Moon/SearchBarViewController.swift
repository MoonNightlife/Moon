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
    fileprivate var searchIcon: IconButton!
    
    open override func prepare() {
        super.prepare()
        prepareProfileButton()
        prepareSettingsButton()
        prepareStatusBar()
        prepapreSearchIcon()
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
        settingsButton = IconButton(image: Icon.cm.settings, tintColor: .lightGray)
    }
    
    fileprivate func prepareStatusBar() {
        statusBarStyle = .lightContent
    }
    
    fileprivate func prepapreSearchIcon() {
        searchIcon =  IconButton(image: Icon.cm.search, tintColor:
            .lightGray)
        searchIcon.isUserInteractionEnabled = false
    }
    
    fileprivate func prepareSearchBar() {
        searchBar.leftViews = [profileButton, searchIcon]
        searchBar.rightViews = [settingsButton]
    }

}
