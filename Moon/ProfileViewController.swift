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

class ProfileViewController: UIViewController, BindableType {
    
    var viewModel: ProfileViewModel!

    @IBOutlet weak var carousel: iCarousel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var toolBar: Toolbar!
    @IBOutlet weak var planLabel: TextField!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var pageController: UIPageControl!
    
    var friendsButton: IconButton!
    
    //fake variables
    var fakeUser: FakeUser!
    var pics = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pics = [#imageLiteral(resourceName: "pp1.jpg"), #imageLiteral(resourceName: "pp2.jpg"), #imageLiteral(resourceName: "pp3.jpg"), #imageLiteral(resourceName: "pp4.jpg"), #imageLiteral(resourceName: "pp5.jpg")]
        fakeUser = FakeUser(firstName: "Marisol", lastName: "Leiva", city: "Dallas", username: "marisolleiva", pics: pics, bio:"Mexico -> SMU 2018 | KKG | Tequila Lover", plan: "The Standard Pour", id: "")
        
        setupCarousel()
        setUpPageController()
        setUpEditProfileButton()
        setUpExitButton()
        setUpFriendsButton()
        setUpBioLabel()
        setUpPlanLabel()
        setUpToolBar()
        setUpUsernameLabel()
        
    }
    
    @IBOutlet weak var exitButton: UIButton!

    func bindViewModel() {
        friendsButton.rx.action = viewModel.onShowFriends()
        dismissButton.rx.action = viewModel.onDismiss()
        editProfileButton.rx.action = viewModel.onEdit()
    }
    
    private func setUpPageController() {
        pageController.numberOfPages = pics.count
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
        bioLabel.text = fakeUser.bio
    }
    
    private func setUpUsernameLabel() {
        usernameLabel.text = fakeUser.username
        usernameLabel.textColor = .lightGray
    }
    
    private func setUpPlanLabel() {
        planLabel.placeholder = fakeUser.plan
        planLabel.isUserInteractionEnabled = false
        planLabel.placeholderNormalColor = .lightGray
        planLabel.dividerNormalColor = .clear

        let leftView = UIImageView()
        leftView.image = #imageLiteral(resourceName: "LocationIcon")
        leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
        planLabel.leftView = leftView
        planLabel.leftViewNormalColor = .moonPurple
       
    }
    
    private func setUpToolBar() {
        toolBar.title = fakeUser.firstName! + " " + fakeUser.lastName!
        toolBar.detail = fakeUser.city!
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
        return pics.count
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        pageController.currentPage = carousel.currentItemIndex
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let profilePic = BottomGradientImageView(frame: carousel.frame)
        profilePic.image = pics[index]
        //profilePic.contentMode = UIViewContentMode.scaleAspectFill
        print(index)
   
        return profilePic
    }
}
