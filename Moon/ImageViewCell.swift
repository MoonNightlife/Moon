//
//  ImageViewCell.swift
//  MainMoonViewSamples
//
//  Created by Evan Noble on 5/1/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Material

struct TopBarData {
    let imageName: String
    let barName: String
    let location: String
}

class ImageViewCell: UIView {
    fileprivate var card: ImageCard!
    
    /// Content area.
    fileprivate var imageView: UIImageView!
    
    /// Toolbar views.
    fileprivate var toolbar: Toolbar!
    fileprivate var moreButton: IconButton!
    
    func initializeImageCardViewWith(data: TopBarData) {
        
        prepareImageViewWith(imageName: data.imageName)
        prepareMoreButton()
        prepareToolbarWith(title: data.barName, subtitle: data.location)
        preparePresenterCard()
    }

}

extension ImageViewCell {
    fileprivate func prepareImageViewWith(imageName: String) {
        imageView = UIImageView(frame: self.frame)
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.image = UIImage(named: imageName)
    }
    
    fileprivate func prepareMoreButton() {
        moreButton = IconButton(image: Icon.cm.moreHorizontal, tintColor: .white)
    }
    
    fileprivate func prepareToolbarWith(title: String, subtitle: String) {
        toolbar = Toolbar(rightViews: [moreButton])
        toolbar.backgroundColor = nil
        
        toolbar.title = title
        toolbar.titleLabel.textColor = .white
        toolbar.titleLabel.textAlignment = .center
        
        toolbar.detail = subtitle
        toolbar.detailLabel.textColor = .white
        toolbar.detailLabel.textAlignment = .center
    }
    
    fileprivate func preparePresenterCard() {
        card = ImageCard()
        
        card.toolbar = toolbar
        card.toolbarEdgeInsetsPreset = .square2
        
        card.imageView = imageView
        
        self.layout(card).horizontally(left: 0, right: 0).center()
    }
}
