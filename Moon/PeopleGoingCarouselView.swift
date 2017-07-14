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
    var nameLabel: UILabel!
    var customView: UIView!
    
    var tapReconizer: UITapGestureRecognizer!
    
    func initializeView() {
        
        self.initializeImageCardViewWith(type: .small)
        prepareLikeButton()
        prepareNumberOfLikes()
        prepareNameLabel()
        prepareCustomView()
        prepareToolBar()
        prepareImageViewTapReconizer()
        
        imageView.backgroundColor = .moonGrey
    }
    
    func toggleColorAndNumber() {
        likeButton.tintColor = likeButton.tintColor == .lightGray ? .red : .lightGray
        if let numString = numberOfLikesButton.title, let num = Int(numString) {
            numberOfLikesButton.title = "\(likeButton.tintColor == .lightGray ? num - 1 : num + 1)"
        }
    }
}

extension PeopleGoingCarouselView {
    
    fileprivate func prepareImageViewTapReconizer() {
        tapReconizer = UITapGestureRecognizer()
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapReconizer)
    }
    
    fileprivate func prepareNameLabel() {
        nameLabel = UILabel()
        nameLabel.text = ""
        nameLabel.font = UIFont(name: "Roboto", size: 10)
        nameLabel.textColor = .lightGray
    }
    
    fileprivate func prepareLikeButton() {
        likeButton = IconButton(image: Icon.favorite, tintColor: .lightGray)
    }
    
    fileprivate func prepareNumberOfLikes() {
        numberOfLikesButton = IconButton(title: "0", titleColor: .lightGray)
        numberOfLikesButton.titleLabel?.font = UIFont(name: "Roboto", size: 10)
    }
    
    fileprivate func prepareCustomView() {
        customView = UIView()
        customView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    
        let size = CGFloat(20)
        print(self.frame.size.width)
        let contentFrame = customView.frame.size
    
        numberOfLikesButton.frame = CGRect(x: contentFrame.width - size, y: (contentFrame.height / 2) - (size / 2), width: size, height: size)
        customView.addSubview(numberOfLikesButton)
        customView.bringSubview(toFront: numberOfLikesButton)
    
        likeButton.frame = CGRect(x: contentFrame.width - (numberOfLikesButton.frame.size.width + size), y:  (contentFrame.height / 2) - (size / 2), width: size, height: size)
        customView.addSubview(likeButton)
        customView.bringSubview(toFront: likeButton)
    }
    
    fileprivate func prepareToolBar() {
        self.bottomToolbar.leftViews = [nameLabel]
        self.bottomToolbar.rightViews = [customView]
    }
}
