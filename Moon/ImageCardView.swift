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
        case small(image: Action<Void, UIImage>, text: String)
        case medium(image: Action<Void, UIImage>, text: String)
        case large(image: Action<Void, UIImage>, titleText: String, detailText: String, text: String)
    }
    
    fileprivate var index: Int?
    fileprivate var card: ImageCard!
    fileprivate var bag = DisposeBag()
    
    // Image View
    var imageView: UIImageView!
    
    // Tool Bar views.
    var toolbar: Toolbar!
    var bottomToolbar: MoonToolbar!
    
    //Content View
    var content: UILabel!
    
    func initializeImageCardViewWith(type: CardType) {
        
        switch type {
        case .small(let image, let text):
            self.prepareImageView(image: image)
            self.prepareBottomToolBar(text: text)
            self.preparePresenterCard()
            break
        case .medium(let image, let text):
            self.prepareImageView(image: image)
            self.prepareContentView(text: text, color: .lightGray)
            self.prepareBottomToolBar(text: "")
            self.preparePresenterCard()
            break
        case .large(let image, let titleText, let detailText, let text):
            self.prepareGradiendImage(image: image)
            self.prepareToolBar(text: titleText, detailText: detailText)
            self.prepareContentView(text: text, color: .black)
            self.prepareBottomToolBar(text: "")
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
    
    fileprivate func prepareImageView(image: Action<Void, UIImage>) {
        imageView = UIImageView(frame:  CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height / 1.2))
        image.elements.bind(to: imageView.rx.image).addDisposableTo(bag)
        image.execute()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    fileprivate func prepareGradiendImage(image: Action<Void, UIImage>) {
        imageView = BottomGradientImageView(frame:  CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height / 1.2)) as BottomGradientImageView!
        image.elements.bind(to: imageView.rx.image).addDisposableTo(bag)
        image.execute()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    fileprivate func prepareToolBar(text: String, detailText: String) {
        toolbar = Toolbar()
        toolbar.backgroundColor = .clear
        
        toolbar.title = text
        toolbar.detail = detailText
    }
    
    fileprivate func prepareBottomToolBar(text: String) {
        bottomToolbar = MoonToolbar()
        bottomToolbar.backgroundColor = .clear
        
        bottomToolbar.title = text
        bottomToolbar.titleLabel.textColor = .lightGray
        bottomToolbar.titleLabel.font = UIFont(name: "Roboto", size: 12)
        
        bottomToolbar.detail = ""
        bottomToolbar.detailLabel.textColor = .lightGray
        bottomToolbar.detailLabel.font = UIFont(name: "Roboto", size: 8)
    }
    
    fileprivate func prepareContentView(text: String, color: UIColor) {
        content = UILabel()
        content.numberOfLines = 0
        content.textAlignment = .center
        content.text = text
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
