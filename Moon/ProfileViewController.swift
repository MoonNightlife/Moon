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
import Action
import RxSwift
import MIBadgeButton_Swift

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
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!

    var friendsButton: MIBadgeButton!
    
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
        setupAcceptButton()
        setUpLikeButtons()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.reload.execute()
        viewModel.reloadPhotos.onNext()
        viewModel.numberOfFriendRequest.execute()
    
    }
    
    @IBOutlet weak var exitButton: UIButton!

    func bindViewModel() {
        friendsButton.rx.action = viewModel.onShowFriends()
        dismissButton.rx.action = viewModel.onDismiss()
        planButton.rx.action = viewModel.onViewBar()
        acceptButton.rx.action = viewModel.onAcceptRequest()
        
        viewModel.actionButton.subscribe(onNext: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.acceptButton.isHidden = true
            
            var action: CocoaAction!
            var imageIcon: UIImage!
            
            switch $0 {
            case .removeFriend:
                action = strongSelf.viewModel.onRemoveFriend()
                imageIcon = #imageLiteral(resourceName: "RemoveFriend").withRenderingMode(.alwaysTemplate).tint(with: .moonRed)
            case .addFriend:
                action = strongSelf.viewModel.onAddFriend()
                imageIcon = #imageLiteral(resourceName: "AddFriend").withRenderingMode(.alwaysTemplate).tint(with: .moonGreen)
            case .acceptRequest:
                action = strongSelf.viewModel.onDeclineRequest()
                imageIcon = #imageLiteral(resourceName: "CancelFriendRequest").withRenderingMode(.alwaysTemplate).tint(with: .moonRed)
                strongSelf.acceptButton.isHidden = false
            case .cancelRequest:
                action = strongSelf.viewModel.onCancelRequest()
                imageIcon = #imageLiteral(resourceName: "CancelFriendRequest").withRenderingMode(.alwaysTemplate).tint(with: .moonRed)
            case .edit:
                action = strongSelf.viewModel.onEdit()
                imageIcon = Icon.cm.edit
            }
            
            strongSelf.editProfileButton.setBackgroundImage(imageIcon, for: .normal)
            strongSelf.editProfileButton.rx.action = action
            
        }).addDisposableTo(bag)
        viewModel.reloadActionButton.onNext()
        
        viewModel.profilePictures.asObservable().subscribe(onNext: { [weak self] images in
            self?.pageController.numberOfPages = images.count
            self?.carousel.reloadData()
        }).addDisposableTo(bag)
        
        viewModel.activityBarName.bind(to: planButton.rx.title()).addDisposableTo(bag)
        viewModel.bio.bind(to: bioLabel.rx.text).addDisposableTo(bag)
        viewModel.username.bind(to: usernameLabel.rx.text).addDisposableTo(bag)
        viewModel.fullName.subscribe(onNext: { [weak self] name in
            self?.toolBar.title = name
        }).addDisposableTo(bag)
        
        viewModel.numberOfFriendRequest.elements.subscribe(onNext: { [weak self] num in
            self?.friendsButton.badgeString = num
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
        carousel.backgroundColor = .moonGrey
        carousel.clipsToBounds = true
    }
    
    private func setUpEditProfileButton() {
        editProfileButton.tintColor = .moonGreen
    }
    
    private func setUpExitButton() {
        exitButton.setBackgroundImage(Icon.cm.close, for: .normal)
        exitButton.tintColor = .moonRed
    }
    
    private func setupAcceptButton() {
        acceptButton.setBackgroundImage(#imageLiteral(resourceName: "AcceptFriendRequest").withRenderingMode(.alwaysTemplate).tint(with: .moonGreen), for: .normal)
        acceptButton.isHidden = true
    }
    
    private func setUpFriendsButton() {
        friendsButton = MIBadgeButton()
        friendsButton.badgeEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 10)
        friendsButton.setImage(#imageLiteral(resourceName: "friendsIcon"), for: .normal)
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
    }
    
    private func setUpToolBar() {
        toolBar.backgroundColor = .clear
        toolBar.titleLabel.textColor = .white
        toolBar.detailLabel.textColor = .moonGrey
        toolBar.rightViews = [friendsButton]
    }
    
    private func setUpLikeButtons() {
        likesButton.titleLabel?.font = UIFont(name: "Roboto", size: 14)
        likesButton.tintColor = .lightGray
        likesButton.setTitle("100", for: .normal)
        
        let image =  Icon.favorite
        likeButton.setBackgroundImage(image, for: .normal)
        likeButton.tintColor = .lightGray
        
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
