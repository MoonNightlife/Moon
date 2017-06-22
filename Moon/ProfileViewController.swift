//
//  ProfileViewController.swift
//  Moon
//
//  Created by Evan Noble on 6/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import iCarousel
import Material
import RxCocoa
import RxSwift

class ProfileViewController: UIViewController, BindableType {
    
    var viewModel: ProfileViewModel!
    private let bag = DisposeBag()

    @IBOutlet weak var carousel: iCarousel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var toolBar: Toolbar!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var planButton: UIButton!
    
    var friendsButton: IconButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCarousel()
        setUpPageController()
        setUpEditProfileButton()
        setUpExitButton()
        setUpFriendsButton()
        setUpBioLabel()
        setUpPlanButton()
        setUpToolBar()
        setUpUsernameLabel()
        
    }
    
    @IBOutlet weak var exitButton: UIButton!

    func bindViewModel() {
        friendsButton.rx.action = viewModel.onShowFriends()
        dismissButton.rx.action = viewModel.onDismiss()
        editProfileButton.rx.action = viewModel.onEdit()
        
        viewModel.profilePictures.asObservable().subscribe(onNext: { [weak self] images in
            self?.pageController.numberOfPages = images.count
            self?.carousel.reloadData()
        }).addDisposableTo(bag)
        
        //viewModel.activityBarName.bind(to: planButton.titleLabel?.rx.text).addDisposableTo(bag)
        viewModel.bio.bind(to: bioLabel.rx.text).addDisposableTo(bag)
        viewModel.username.bind(to: usernameLabel.rx.text).addDisposableTo(bag)
        viewModel.fullName.subscribe(onNext: { [weak self] name in
            self?.toolBar.title = name
        }).addDisposableTo(bag)
    }
    
    private func setUpPageController() {
        pageController.currentPageIndicatorTintColor = .white
        pageController.pageIndicatorTintColor = .lightGray
        pageController.currentPage = 0
    }
    
    private func setupCarousel() {
        carousel.isPagingEnabled = true
        carousel.type = .linear
        carousel.bounces = false
        carousel.bringSubview(toFront: toolBar)
        carousel.reloadData()
    }
    
    private func setUpEditProfileButton() {
        editProfileButton.setBackgroundImage(Icon.cm.edit, for: .normal)
        editProfileButton.tintColor = .moonGreen
    }
    
    private func setUpExitButton() {
        exitButton.setBackgroundImage(Icon.cm.close, for: .normal)
        exitButton.tintColor = .moonRed
    }
    
    private func setUpFriendsButton() {
        friendsButton = IconButton(image: #imageLiteral(resourceName: "friendsIcon"))
    }
    
    private func setUpBioLabel() {
        bioLabel.textColor = .lightGray
    }
    
    private func setUpUsernameLabel() {
        usernameLabel.textColor = .lightGray
    }
    
    private func setUpPlanButton() {
        planButton.tintColor = .lightGray
        planButton.titleLabel?.font = UIFont(name: "Roboto", size: 15)
        planButton.setTitle("The Standard Pour", for: .normal)
    }
    
    private func setUpToolBar() {
        toolBar.backgroundColor = .clear
        toolBar.titleLabel.textColor = .white
        toolBar.detailLabel.textColor = .moonGrey
        toolBar.rightViews = [friendsButton]
    }

}

extension ProfileViewController: iCarouselDataSource, iCarouselDelegate {
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        
        return value
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return viewModel.profilePictures.value.count
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        pageController.currentPage = carousel.currentItemIndex
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let profilePic = BottomGradientImageView(frame: carousel.frame)
        profilePic.image = viewModel.profilePictures.value[index]
        profilePic.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        profilePic.contentMode = UIViewContentMode.scaleAspectFill
        profilePic.clipsToBounds = true
        return profilePic
    }
}
