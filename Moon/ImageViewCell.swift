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
    fileprivate var toolbar: Toolbar!
    var moreButton: IconButton!
    fileprivate var goButton: IconButton!
    
    func initializeImageCardViewWith(data: TopBar, downloadAction: Action<Void, UIImage>) {
        
        prepareImageView()
        prepareMoreButton()
        prepareGoButton()
        prepareToolbarWith(title: data.barName, subtitle: data.usersGoing)
        preparePresenterCard()
        
        downloadAction.elements.bind(to: imageView.rx.image).addDisposableTo(bag)
        downloadAction.execute()
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
    
    fileprivate func prepareToolbarWith(title: String, subtitle: String) {
        toolbar = Toolbar(leftViews: [moreButton])
        toolbar.rightViews = [goButton]
        toolbar.backgroundColor = nil
        
        toolbar.title = title
        toolbar.titleLabel.textColor = .white
        toolbar.titleLabel.textAlignment = .center
        
        toolbar.detailLabel.textColor = .white
        toolbar.detailLabel.textAlignment = .center
     
        let fullString = NSMutableAttributedString(string: " ")
        
        let attachment = NSTextAttachment()
        attachment.image = #imageLiteral(resourceName: "goingIcon")
        attachment.bounds = CGRect(x: 0, y: -5, width: 16, height: 16)
        
        let attachmentString = NSAttributedString(attachment: attachment)
        
        fullString.append(attachmentString)
        fullString.append(NSAttributedString(string: " " + subtitle))
        
        toolbar.detailLabel.attributedText = fullString
    }
    
    fileprivate func preparePresenterCard() {
        card = ImageCard()
        
        card.toolbar = toolbar
        card.toolbarEdgeInsetsPreset = .square2
        
        card.imageView = imageView
        
        self.layout(card).horizontally(left: 0, right: 0).center()
    }
}
