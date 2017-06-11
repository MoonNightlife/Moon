//
//  PeopleGoingCarouselView.swift
//  Moon
//
//  Created by Gabriel I Leyva Merino on 6/9/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import UIKit
import Material

class PeopleGoingCarouselView: ImageCardView {
    
    fileprivate var user: FakeUser!
    fileprivate var index: Int!
    fileprivate var likeButton: IconButton!
    fileprivate var numberOfLikesButton: IconButton!
    
    func initializeViewWith(user: FakeUser, index: Int) {
        self.user = user
        self.index = index
        
        self.initializeImageCardViewWith(type: .small(image: (user.pics?[0])!, text: user.firstName!))
        prepareLikeButton()
        prepareNumberOfLikesButton(likes: "19")
        prepareToolBar()
    }
    
}

extension PeopleGoingCarouselView {
    
    fileprivate func prepareLikeButton() {
        likeButton = IconButton(image: Icon.favorite, tintColor: .lightGray)
    }
    
    fileprivate func prepareNumberOfLikesButton(likes: String) {
        numberOfLikesButton = IconButton(title: likes)
        numberOfLikesButton.titleColor = .lightGray
        numberOfLikesButton.titleLabel?.font = UIFont(name: "Roboto", size: 10)
    }
    
    fileprivate func prepareToolBar() {
        self.bottomToolbar.addRightViews(view1: numberOfLikesButton, view2: likeButton)
    }
}
