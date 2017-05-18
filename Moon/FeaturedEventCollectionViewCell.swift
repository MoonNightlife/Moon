//
//  FeaturedEventCollectionViewCell.swift
//  Moon
//
//  Created by Evan Noble on 5/17/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Material

struct FeaturedEvent {
    var imageName: String
    var barName: String
    var date: String
    var description: String
}

class FeaturedEventCollectionViewCell: UICollectionViewCell {
    
    fileprivate var event: FeaturedEvent!
    fileprivate var index: Int?
    
    fileprivate var card: ImageCard!
    
    /// Conent area.
    fileprivate var imageView: UIImageView!
    fileprivate var eventContent: UILabel!
    
    /// Bottom Bar views.
    fileprivate var bottomBar: Bar!
    fileprivate var dateFormatter: DateFormatter!
    fileprivate var dateLabel: UILabel!
    fileprivate var favoriteButton: IconButton!
    fileprivate var shareButton: IconButton!
    
    /// Toolbar views.
    fileprivate var toolbar: Toolbar!
    fileprivate var moreButton: IconButton!
    
    func initializeCellWith(event: FeaturedEvent, index: Int) {
        self.event = event
        self.index = index
        
        prepareImageView()
        prepareDateFormatter()
        prepareDateLabel()
        prepareFavoriteButton()
        prepareShareButton()
        prepareMoreButton()
        prepareToolbar()
        prepareContentView()
        prepareBottomBar()
        preparePresenterCard()
    }

}

extension FeaturedEventCollectionViewCell {
    
    fileprivate func prepareImageView() {
        imageView = UIImageView()
        //imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: event.imageName)?.resize(toWidth: self.width)
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
    
    fileprivate func prepareFavoriteButton() {
        favoriteButton = IconButton(image: Icon.favorite, tintColor: Color.red.base)
    }
    
    fileprivate func prepareShareButton() {
        shareButton = IconButton(image: Icon.cm.share, tintColor: Color.blueGrey.base)
    }
    
    fileprivate func prepareMoreButton() {
        moreButton = IconButton(image: Icon.cm.moreHorizontal, tintColor: Color.blueGrey.base)
    }
    
    fileprivate func prepareToolbar() {
        toolbar = Toolbar(rightViews: [moreButton])
        toolbar.backgroundColor = nil
        
        toolbar.title = event.barName
        toolbar.titleLabel.textColor = .white
        toolbar.titleLabel.textAlignment = .center
        
        toolbar.detail = event.date
        toolbar.detailLabel.textColor = .white
        toolbar.detailLabel.textAlignment = .center
    }
    
    fileprivate func prepareContentView() {
        eventContent = UILabel()
        eventContent.numberOfLines = 0
        eventContent.text = event.description
        eventContent.font = RobotoFont.regular(with: 14)
    }
    
    fileprivate func prepareBottomBar() {
        bottomBar = Bar(leftViews: [favoriteButton], rightViews: [shareButton], centerViews: [dateLabel])
    }
    
    fileprivate func preparePresenterCard() {
        card = ImageCard()
        
        card.toolbar = toolbar
        card.toolbarEdgeInsetsPreset = .square3
        
        card.imageView = imageView
        
        card.contentView = eventContent
        card.contentViewEdgeInsetsPreset = .square3
        
        //card.bottomBar = bottomBar
        //card.bottomBarEdgeInsetsPreset = .wideRectangle2
        
        self.layout(card).edges().center()
    }
}
