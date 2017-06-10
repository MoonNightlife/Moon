//
//  SearchBarControllerViewController.swift
//  Moon
//
//  Created by Evan Noble on 5/15/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Material
import Action
import RxSwift
import RxCocoa

class SearchBarViewController: SearchBarController, BindableType, UIPopoverPresentationControllerDelegate {
    
    var viewModel: SearchBarViewModel!
    
    private let bag = DisposeBag()
    
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
        
        listenToSearchBar()
    }
    
    func bindViewModel() {
        profileButton.rx.action = viewModel.onShowProfile()
        settingsButton.rx.action = viewModel.onShowSettings()
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {

        return UIModalPresentationStyle.none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return false
    }
    
    func listenToSearchBar() {
        searchBar.textField.rx.controlEvent(.editingDidBegin).subscribe(onNext: { [weak self] in
            self?.viewModel.onShowSearchResults().execute()
        })
        .addDisposableTo(bag)
        
        searchBar.textField.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: {
            self.viewModel.onShowMainController().execute()
        })
        .addDisposableTo(bag)
    }
}

extension SearchBarViewController {
    fileprivate func prepareProfileButton() {
        // Resize the icon to match the icons in material design
        let sizeReference = Icon.cm.moreVertical
        
        let profileIconImage = #imageLiteral(resourceName: "ProfileIcon").resize(toWidth: (sizeReference?.width)!)?.resize(toHeight: (sizeReference?.height)!)?.withRenderingMode(.alwaysTemplate)
        
        profileButton = IconButton(image: profileIconImage, tintColor: .white)
    }
    
    fileprivate func prepareSettingsButton() {
        settingsButton = IconButton(image: Icon.cm.settings, tintColor: .white)
    }
    
    fileprivate func prepareStatusBar() {
        statusBarStyle = .lightContent
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func prepapreSearchIcon() {
        searchIcon =  IconButton(image: Icon.cm.search, tintColor:
            .white)
        searchIcon.isUserInteractionEnabled = false
    }
    
    fileprivate func prepareSearchBar() {
        searchBar.leftViews = [searchIcon]
        searchBar.rightViews = [profileButton, settingsButton]
        searchBar.placeholderColor = .white
    }

}
