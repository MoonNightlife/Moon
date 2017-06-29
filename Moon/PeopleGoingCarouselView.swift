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
    
    var likeButton: IconButton!
    var numberOfLikesButton: IconButton!
    var bag = DisposeBag()
    
    var tapReconizer: UITapGestureRecognizer!
    
    func initializeView() {
        
        self.initializeImageCardViewWith(type: .small)
        prepareLikeButton()
        prepareNumberOfLikes()
        prepareToolBar()
        prepareImageViewTapReconizer()
       
    }
}

extension PeopleGoingCarouselView {
    
    fileprivate func prepareImageViewTapReconizer() {
        tapReconizer = UITapGestureRecognizer()
        imageView.addGestureRecognizer(tapReconizer)
    }
    
    fileprivate func prepareLikeButton() {
        likeButton = IconButton(image: Icon.favorite, tintColor: .lightGray)
    }
    
    fileprivate func prepareNumberOfLikes() {
        numberOfLikesButton = IconButton(title: "0", titleColor: .lightGray)
        numberOfLikesButton.titleLabel?.font = UIFont(name: "Roboto", size: 10)
    }
    
    fileprivate func prepareToolBar() {
        self.bottomToolbar.addRightViews(view1: numberOfLikesButton, view2: likeButton)
       
    }
}
