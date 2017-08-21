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
import Action
import RxSwift

class ImageCardView: UIView {
    
    enum CardType {
        case small
        case medium
        case large
    }
    
    var card: ImageCard!
    
    // Image View
    var imageView: UIImageView!
    
    // Tool Bar views.
    var toolbar: Toolbar!
    var bottomToolbar: MoonToolbar!
    
    //Content View
    var content: UILabel!
    
    func initializeImageCardViewWith(type: CardType) {
        
        switch type {
        case .small:
            self.prepareImageView()
            self.prepareBottomToolBar()
            self.preparePresenterCard()
            break
        case .medium:
            self.prepareImageView()
            self.prepareContentView(color: .lightGray)
            self.prepareBottomToolBar()
            self.preparePresenterCard()
            break
        case .large:
            self.prepareGradiendImage()
            self.prepareToolBar()
            self.prepareContentView(color: .black)
            self.prepareBottomToolBar()
            self.preparePresenterCard()
            break
        }
    }
    
    func addIconToText(image: UIImage, text: String) -> NSMutableAttributedString {
        
        let fullString = NSMutableAttributedString(string: " ")
        
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = CGRect(x: 0, y: -5, width: 16, height: 16)
        
        let attachmentString = NSAttributedString(attachment: attachment)
        
        fullString.append(attachmentString)
        fullString.append(NSAttributedString(string: " " + text))
        
        return fullString
    }
    
    func changeImageTintColor(image: UIImage, color: UIColor) -> UIImage {
        var newImage = image.withRenderingMode(.alwaysTemplate)
        newImage =  newImage.tint(with: color)!
        
        return newImage
    }
}

extension ImageCardView {
    
    fileprivate func prepareImageView() {
        imageView = UIImageView(frame:  CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height / 1.2))
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    fileprivate func prepareGradiendImage() {
        imageView = BottomGradientImageView(frame:  CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height / 1.2)) as BottomGradientImageView!
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    fileprivate func prepareToolBar() {
        toolbar = Toolbar()
        toolbar.backgroundColor = .clear
    }
    
    fileprivate func prepareBottomToolBar() {
        bottomToolbar = MoonToolbar()
        bottomToolbar.backgroundColor = .clear
        
        bottomToolbar.titleLabel.textColor = .lightGray
        bottomToolbar.titleLabel.font = UIFont(name: "Roboto", size: 12)
        
        bottomToolbar.detailLabel.textColor = .lightGray
        bottomToolbar.detailLabel.font = UIFont(name: "Roboto", size: 8)
    }
    
    fileprivate func prepareContentView(color: UIColor) {
        content = UILabel()
        content.numberOfLines = 0
        content.textAlignment = .center
        content.font = RobotoFont.regular(with: 12)
        content.textColor = color
    }
    
    fileprivate func preparePresenterCard() {
        card = ImageCard()
        
        card.imageView = imageView
        
        if content != nil {
        card.contentView = content
        card.contentViewEdgeInsetsPreset = .horizontally1
        }
        
        if toolbar != nil {
        card.toolbar = toolbar
        card.toolbarEdgeInsetsPreset = .horizontally1
        }
        
        card.bottomBar = bottomToolbar
        card.bottomBarEdgeInsetsPreset = .horizontally1
        
        self.layout(card).edges().center()
    }
}
