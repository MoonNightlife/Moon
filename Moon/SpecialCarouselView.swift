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
   
    fileprivate var likeButton: IconButton!
    fileprivate var index: Int!
    fileprivate var special: SpecialCell!
    fileprivate var numberOfLikesButton: IconButton!
    fileprivate let bag = DisposeBag()
        
    func initializeViewWith(special: SpecialCell, index: Int, likeAction: Action<String, Void>) {
        self.special = special
        self.index = index
        self.initializeImageCardViewWith(type: .medium(image: special.image, text: special.description))
        prepareLikeButton()
        prepareNumberOfLikesButton(likes: "100")
        prepareToolBar()
        
        bindAction(likeAction: likeAction)
    }

}

extension SpecialCarouselView {
    
    fileprivate func bindAction(likeAction: Action<String, Void>) {
        likeButton.rx.controlEvent(UIControlEvents.touchUpInside)
            .map({ [weak self] in
                self?.special.id ?? ""
            })
            .subscribe(likeAction.inputs)
            .addDisposableTo(bag)
    }
    
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
