//
//  SpecialCarouselView.swift
//  Moon
//
//  Created by Gabriel I Leyva Merino on 6/9/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import Material
import UIKit
import Action
import RxSwift
import SwaggerClient

class SpecialCarouselView: ImageCardView {
   
    var likeButton: IconButton!
    var numberOfLikesButton: IconButton!
    let bag = DisposeBag()
        
    func initializeView() {
        self.initializeImageCardViewWith(type: .medium)
        prepareLikeButton()
        prepareNumberOfLikesButton()
        prepareToolBar()
    }
}

extension SpecialCarouselView {
    
    fileprivate func prepareLikeButton() {
        likeButton = IconButton(image: Icon.favorite, tintColor: .lightGray)
    }
    
    fileprivate func prepareNumberOfLikesButton() {
        numberOfLikesButton = IconButton()
        numberOfLikesButton.titleColor = .lightGray
        numberOfLikesButton.titleLabel?.font = UIFont(name: "Roboto", size: 10)
    }
    
    fileprivate func prepareToolBar() {
        self.bottomToolbar.addRightViews(view1: numberOfLikesButton, view2: likeButton)
    }

}
