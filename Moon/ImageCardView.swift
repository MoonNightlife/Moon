//
//  ImageCardView.swift
//  Moon
//
//  Created by Gabriel I Leyva Merino on 6/10/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import UIKit
import Material

class ImageCardView: UIView {
    
    fileprivate var index: Int?
    
    fileprivate var card: ImageCard!
    
    // Image
    var imageView: UIImageView!
    
    // Tool Bar views.
    var toolBar: Bar!
    var label: UILabel!
    
    func initializeImageCardView(text: String, imageName: String) {
        
        self.prepareImageView(imageName: imageName)
        self.prepareNameLabel(text: text)
        self.prepareBottomBar()
        self.preparePresenterCard()
    }
}

extension ImageCardView {
    
    fileprivate func prepareImageView(imageName: String) {
        imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height / 1.2)
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    fileprivate func prepareNameLabel(text: String) {
        label = UILabel()
        label.font = RobotoFont.regular(with: 10)
        label.textColor = .lightGray
        label.text = text
        label.textAlignment = .center
    }
    
    fileprivate func prepareBottomBar() {
        toolBar = Bar(centerViews: [label])
    }
    
    fileprivate func preparePresenterCard() {
        card = ImageCard()
        
        card.imageView = imageView
        
        card.bottomBar = toolBar
        card.bottomBarEdgeInsetsPreset = .wideRectangle2
        
        self.layout(card).edges().center()
    }
}
