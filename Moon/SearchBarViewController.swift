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
    fileprivate var cancelButton: IconButton!
    fileprivate var searchBarButton: UIButton!
    
    open override func prepare() {
        super.prepare()
        prepareProfileButton()
        prepareSettingsButton()
        prepareStatusBar()
        prepapreSearchIcon()
        prepareCancelButton()
        prepareSearchBar()
        prepareSearchBarButtonOverlay()
        
        listenToSearchBarButton()
    }
    
    open func prepareSearchBarForSearch() {
        searchBar.rightViews = [cancelButton]
        searchBar.createLineUnderSearchTextAndIcon(color: .white)
        searchBarButton.removeFromSuperview()
    }
    
    open func prepareSearchBarForMainView() {
        searchBar.rightViews = [profileButton, settingsButton]
        searchBar.createLineUnderSearchTextAndIcon(color: .white)
        searchBarButton.frame = searchBar.textField.frame
        searchBar.textField.addSubview(searchBarButton)
    }
    
    func bindViewModel() {
        profileButton.rx.action = viewModel.onShowProfile()
        settingsButton.rx.action = viewModel.onShowSettings()
        
        let textedEnteredInSearchBar = searchBar.textField.rx.text.orEmpty.map({ $0.characters.count > 0 }).share()
        textedEnteredInSearchBar.skip(2).subscribe(onNext: { [weak self] in
            if $0 {
                self?.viewModel.onShow(view: .results).execute()
            } else {
                self?.viewModel.onShow(view: .suggestions).execute()
            }
        }).addDisposableTo(bag)
        textedEnteredInSearchBar.subscribe(onNext: { [weak self] isTextEntered in
            self?.searchBar.clearButton.isHidden = !isTextEntered
        }).addDisposableTo(bag)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {

        return UIModalPresentationStyle.none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return false
    }
    
    func listenToSearchBarButton() {
        searchBarButton.rx.controlEvent(UIControlEvents.touchUpInside).subscribe(onNext: { [weak self] in
            self?.prepareSearchBarForSearch()
            self?.viewModel.onShowSearch().execute()
        })
        .addDisposableTo(bag)
        
        cancelButton.rx.controlEvent(UIControlEvents.touchUpInside).subscribe(onNext: { [weak self] in
            self?.searchBar.textField.text = ""
            self?.searchBar.textField.endEditing(true)
            self?.viewModel.onShowMainController().execute()
        })
        .addDisposableTo(bag)
        
        searchBar.clearButton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] in
                self?.searchBar.clearButton.isHidden = true
                self?.viewModel?.onShow(view: .suggestions).execute()
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
    
    fileprivate func prepareCancelButton() {
        cancelButton = IconButton(image: Icon.cm.close, tintColor: .white)
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
    
    fileprivate func prepareSearchBarButtonOverlay() {
        searchBarButton = UIButton()
        searchBarButton.frame = searchBar.textField.frame
    }
    
    fileprivate func prepareSearchBar() {
        searchBar.leftViews = [searchIcon]
        searchBar.placeholderColor = .white
        searchBar.textColor = .white
    }

}
