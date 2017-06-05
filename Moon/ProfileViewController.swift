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
    var fakeUser: FakeUser!
    var pics = [String]()

    @IBOutlet weak var carousel: iCarousel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var planLabel: UILabel!
    @IBOutlet weak var toolBar: Toolbar!
    
    var friendsButton: IconButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pics = ["pp1.jpg", "pp2.jpg", "pp3.jpg", "pp4.jpg", "pp5.jpg"]
        fakeUser = FakeUser(firstName: "Marisol", lastName: "Leiva", city: "Dallas", username: "marisolleiva95", pics: pics, bio:"SMU 2018 | Kappa | Mexico", plan: "The Standard Pour")
        
        setupCarousel()
        setUpEditProfileButton()
        setUpExitButton()
        setUpFriendsButton()
        setUpToolBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    @IBOutlet weak var exitButton: UIButton!

    func bindViewModel() {
        dismissButton.rx.action = viewModel.onDismiss()
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
        exitButton.tintColor = .moonRed
    }
    
    private func setUpFriendsButton() {
        friendsButton = IconButton(image: #imageLiteral(resourceName: "friendsIcon"))
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
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let profilePic = BottomGradientImageView(frame: carousel.frame)
        profilePic.image = UIImage(named: pics[index])
        //profilePic.contentMode = UIViewContentMode.scaleAspectFill
        
        return profilePic
    }
}
