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
import RxSwift
import Action

class PeopleGoingCarouselView: ImageCardView {
    
    fileprivate var user: FakeUser!
    fileprivate var index: Int!
    fileprivate var likeButton: IconButton!
    fileprivate var numberOfLikesButton: IconButton!
    fileprivate var viewProfileOverlayButton: UIButton!
    fileprivate var bag = DisposeBag()
    
    func initializeViewWith(user: FakeUser, index: Int, viewProfile: CocoaAction, likeActivity: CocoaAction, viewLikers: CocoaAction, downloadImage: Action<Void, UIImage>) {
        self.user = user
        self.index = index
        
        self.initializeImageCardViewWith(type: .small(image: downloadImage, text: user.firstName!))
        prepareLikeButton()
        prepareNumberOfLikes(likes: "19")
        prepareOverlayButton()
        prepareToolBar()
        
        viewProfileOverlayButton.rx.action = viewProfile
        likeButton.rx.action = likeActivity
        numberOfLikesButton.rx.action = viewLikers
    }
}

extension PeopleGoingCarouselView {
        
    fileprivate func prepareOverlayButton() {
        viewProfileOverlayButton = UIButton(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.imageView.frame.height))
        self.imageView.addSubview(viewProfileOverlayButton)
        print(self.imageView.subviews)
    }
    
    fileprivate func prepareLikeButton() {
        likeButton = IconButton(image: Icon.favorite, tintColor: .lightGray)
    }
    
    fileprivate func prepareNumberOfLikes(likes: String) {
        numberOfLikesButton = IconButton(title: likes, titleColor: .lightGray)
        numberOfLikesButton.titleLabel?.font = UIFont(name: "Roboto", size: 10)
    }
    
    fileprivate func prepareToolBar() {
        self.bottomToolbar.addRightViews(view1: numberOfLikesButton, view2: likeButton)
       
    }
}
