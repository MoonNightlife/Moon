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
import MIBadgeButton_Swift

class SearchBarViewController: SearchBarController, BindableType, UIPopoverPresentationControllerDelegate {
    
    var viewModel: SearchBarViewModel!
    
    private let bag = DisposeBag()
    
    fileprivate var profileButton: MIBadgeButton!
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
        searchBar.textField.rx.textInput.text.orEmpty.bind(to: viewModel.searchText).addDisposableTo(bag)
        
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
        
        let textedEnteredInSearchBar = searchBar.textField.rx.text.orEmpty.share()
        
        textedEnteredInSearchBar.filter({ $0.characters.count > 0 }).subscribe(onNext: { [weak self] _ in
                self?.viewModel.onShow(view: .results).execute()
        }).addDisposableTo(bag)
        
        textedEnteredInSearchBar.map({ $0.characters.count == 0 }).subscribe(onNext: { [weak self] noTextEntered in
            self?.searchBar.clearButton.isHidden = noTextEntered
        }).addDisposableTo(bag)
        
        viewModel.numberOfFriendRequest.subscribe(onNext: { [weak self] num in
            //self?.profileButton.badgeString = num
        }).addDisposableTo(bag)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {

        return UIModalPresentationStyle.none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        viewModel.onPopProfile().execute()
        return false
    }

}

extension SearchBarViewController {
    fileprivate func prepareProfileButton() {
        // Resize the icon to match the icons in material design
        let sizeReference = Icon.cm.moreVertical
        
        let profileIconImage = #imageLiteral(resourceName: "ProfileIcon").resize(toWidth: (sizeReference?.width)!)?.resize(toHeight: (sizeReference?.height)!)
        
        profileButton = MIBadgeButton()
        profileButton.badgeEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 0)
        profileButton.setImage(profileIconImage, for: .normal)
        
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
        searchBar.clearButton.tintColor = .white
        searchBar.leftViews = [searchIcon]
        searchBar.placeholderColor = .white
        searchBar.textColor = .white
    }

}
