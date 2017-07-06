//
//  ImageViewCell.swift
//  MainMoonViewSamples
//
//  Created by Evan Noble on 5/1/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Material
import Action
import RxCocoa
import RxSwift

class ImageViewCell: UIView {
    fileprivate var bag = DisposeBag()
    fileprivate var card: ImageCard!
    
    /// Content area.
    fileprivate var imageView: BottomGradientImageView!
    
    /// Toolbar views.
    var toolbar: Toolbar!
    var moreButton: IconButton!
    var goButton: IconButton!
    
    func initializeImageCardView() {
        
        prepareImageView()
        prepareMoreButton()
        prepareGoButton()
        prepareToolbarWith()
        preparePresenterCard()
    
    }

}

extension ImageViewCell {
    fileprivate func prepareImageView() {
        imageView = BottomGradientImageView(frame: self.frame)
        imageView.contentMode = UIViewContentMode.scaleAspectFill
    }
    
    fileprivate func prepareMoreButton() {
        moreButton = IconButton(image: Icon.cm.moreHorizontal, tintColor: .white)
    }
    
    fileprivate func prepareGoButton() {
        goButton = IconButton(image: #imageLiteral(resourceName: "goButton"))
    }
    
    fileprivate func prepareToolbarWith() {
        toolbar = Toolbar(leftViews: [moreButton])
        toolbar.rightViews = [goButton]
        toolbar.backgroundColor = nil
        
        
        toolbar.titleLabel.textColor = .white
        toolbar.titleLabel.textAlignment = .center
        
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
