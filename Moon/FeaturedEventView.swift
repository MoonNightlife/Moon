//
//  FeaturedEventCollectionViewCell.swift
//  Moon
//
//  Created by Evan Noble on 5/17/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Material
import Action
import RxSwift
import SwaggerClient

class FeaturedEventView: ImageCardView {
    
    //Main Variables
    fileprivate var event: BarEvent!
    fileprivate var index: Int?
    fileprivate var bag = DisposeBag()
    
    //Buttons
    fileprivate var favoriteButton: IconButton!
    fileprivate var numberOfLikesButton: IconButton!
    fileprivate var shareButton: IconButton!
    fileprivate var moreButton: IconButton!
    
    //Date Variables
    fileprivate var dateFormatter: DateFormatter!
    fileprivate var dateLabel: UILabel!
    
    func initializeCellWith(event: BarEvent, index: Int, likeAction: CocoaAction, shareAction: CocoaAction, downloadImage: Action<Void, UIImage>, moreInfoAction: CocoaAction) {
        self.event = event
        self.index = index
        
        self.initializeImageCardViewWith(type: .large(image: downloadImage, titleText: event.title!, detailText: event.name!, text: event.description!))
        self.imageView.frame = CGRect(x: 0, y: 0, width: self.width, height: (self.height + 200) * 0.372)
        prepareFavoriteButton()
        prepareShareButton()
        prepareMoreButton()
        prepareDateFormatter()
        prepareDateLabel()
        prepareNumberOfLikesButton(likes: "200")
        prepareToolbar()
        prepareBottomBar()
        
        favoriteButton.rx.action = likeAction
        shareButton.rx.action = shareAction
        moreButton.rx.action = moreInfoAction
    }

}

extension FeaturedEventView {
    
    fileprivate func prepareFavoriteButton() {
        favoriteButton = IconButton(image: Icon.favorite, tintColor: .lightGray)
    }
    
    fileprivate func prepareShareButton() {
        shareButton = IconButton(image: Icon.cm.share, tintColor: Color.blueGrey.base)
    }
    
    fileprivate func prepareMoreButton() {
        moreButton = IconButton(image: Icon.cm.moreHorizontal, tintColor: .white)
    }
    
    fileprivate func prepareDateFormatter() {
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
    }
    
    fileprivate func prepareDateLabel() {
        dateLabel = UILabel()
        dateLabel.font = RobotoFont.regular(with: 12)
        dateLabel.textColor = Color.blueGrey.base
        dateLabel.textAlignment = .center
        dateLabel.text = dateFormatter.string(from: Date.distantFuture)
    }
    
    fileprivate func prepareNumberOfLikesButton(likes: String) {
        numberOfLikesButton = IconButton(title: likes)
        numberOfLikesButton.titleColor = .lightGray
        numberOfLikesButton.titleLabel?.font = UIFont(name: "Roboto", size: 10)
    }
    
    fileprivate func prepareToolbar() {
        self.toolbar.titleLabel.textColor = .white
        self.toolbar.detailLabel.textColor = .white
        self.toolbar.rightViews = [moreButton]
    }
        
    fileprivate func prepareBottomBar() {
        self.bottomToolbar.centerViews = [dateLabel]
        self.bottomToolbar.addLeftView(view: shareButton)
        self.bottomToolbar.addRightViews(view1: numberOfLikesButton, view2: favoriteButton)
    }
}
