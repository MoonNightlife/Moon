//
//  ImageViewCell.swift
//  MainMoonViewSamples
//
//  Created by Evan Noble on 5/1/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Material

class ImageViewCell: UIView {
    fileprivate var card: ImageCard!
    
    /// Content area.
    fileprivate var imageView: BottomGradientImageView!
    
    /// Toolbar views.
    fileprivate var toolbar: Toolbar!
    fileprivate var moreButton: IconButton!
    fileprivate var goButton: IconButton!
    
    func initializeImageCardViewWith(data: TopBarData) {
        
        prepareImageViewWith(imageName: data.imageName)
        prepareMoreButton()
        prepareGoButton()
        prepareToolbarWith(title: data.barName, subtitle: data.usersGoing)
        preparePresenterCard()
    }

}

extension ImageViewCell {
    fileprivate func prepareImageViewWith(imageName: String) {
        imageView = BottomGradientImageView(frame: self.frame)
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = UIViewContentMode.scaleAspectFill
    }
    
    fileprivate func prepareMoreButton() {
        moreButton = IconButton(image: Icon.cm.moreHorizontal, tintColor: .white)
    }
    
    fileprivate func prepareGoButton() {
        goButton = IconButton(image: #imageLiteral(resourceName: "goButton"))
    }
    
    fileprivate func prepareToolbarWith(title: String, subtitle: String) {
        toolbar = Toolbar(rightViews: [moreButton])
        toolbar.leftViews = [goButton]
        let view = IconButton(image: #imageLiteral(resourceName: "goingIcon"), tintColor: .white)
       // toolbar.centerViews = [view]
        toolbar.backgroundColor = nil
        
        toolbar.title = title
        toolbar.titleLabel.textColor = .white
        toolbar.titleLabel.textAlignment = .center
        
        toolbar.detail = subtitle
        toolbar.detailLabel.textColor = .white
        toolbar.detailLabel.textAlignment = .center
        
        toolbar.detailLabel.layout(view).bottomLeft(bottom: -10, left: 80)
        
    }
    
    fileprivate func preparePresenterCard() {
        card = ImageCard()
        
        card.toolbar = toolbar
        card.toolbarEdgeInsetsPreset = .square2
        
        card.imageView = imageView
        
        self.layout(card).horizontally(left: 0, right: 0).center()
    }
}
