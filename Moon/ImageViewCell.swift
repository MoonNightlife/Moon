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
    var bag = DisposeBag()
    var usersGoingCount = 0
    fileprivate var card: ImageCard!
    
    /// Content area.
    var imageView: BottomGradientImageView!
    
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
    
    func createUsersGoingString(usersGoing: Int) -> NSAttributedString {
        let fullString = NSMutableAttributedString(string: " ")
        
        let attachment = NSTextAttachment()
        attachment.image = #imageLiteral(resourceName: "goingIcon")
        attachment.bounds = CGRect(x: 0, y: -5, width: 16, height: 16)
        
        let attachmentString = NSAttributedString(attachment: attachment)
        
        fullString.append(attachmentString)
        fullString.append(NSAttributedString(string: " " + "\(usersGoing)"))
        
        return fullString
    }
    
    func toggleGoButtonAndCount() {
        if goButton.image == #imageLiteral(resourceName: "goButton") {
            goButton.image = #imageLiteral(resourceName: "thereIcon")
            usersGoingCount += 1
        } else if goButton.image == #imageLiteral(resourceName: "thereIcon") {
            goButton.image = #imageLiteral(resourceName: "goButton")
            usersGoingCount -= 1
        }
        toolbar.detailLabel.attributedText = createUsersGoingString(usersGoing: usersGoingCount)
    }

}

extension ImageViewCell {
    fileprivate func prepareImageView() {
        imageView = BottomGradientImageView(frame: self.frame)
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
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
