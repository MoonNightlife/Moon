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
    
    func toggleColorAndNumber() {
        likeButton.tintColor = likeButton.tintColor == .lightGray ? .red : .lightGray
        if let numString = numberOfLikesButton.title, let num = Int(numString) {
            numberOfLikesButton.title = "\(likeButton.tintColor == .lightGray ? num - 1 : num + 1)"
        }
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
