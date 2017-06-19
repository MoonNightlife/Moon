//
//  SuggestedBarsCollectionView.swift
//  Moon
//
//  Created by Gabriel I Leyva Merino on 6/13/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import UIKit
import Material
import RxSwift
import Action

class BarCollectionView: ImageCardView {
    
    fileprivate var goButton: IconButton!
    fileprivate var nameLabel: UILabel!
    
    func initViewWith(bar: SearchSnapshot, goAction: CocoaAction, downloadImage: Action<Void, UIImage>) {
        self.initializeImageCardViewWith(type: .small(image: downloadImage, text: ""))
        prepareAddFriendButton()
        prepareNameLabel(text: bar.name)
        prepareToolbar()
        
        goButton.rx.action = goAction
    }

}

extension BarCollectionView {
    
    fileprivate func prepareNameLabel(text: String) {
        nameLabel = UILabel()
        nameLabel.text = text
        nameLabel.textColor = .lightGray
        nameLabel.numberOfLines = 1
        nameLabel.font = UIFont(name: "Roboto", size: 10)
    }
    
    fileprivate func prepareAddFriendButton() {
        goButton = IconButton(image: #imageLiteral(resourceName: "goButton"))
    }
    
    fileprivate func prepareToolbar() {
        self.bottomToolbar.rightViews = [goButton]
        self.bottomToolbar.addLeftView(view: nameLabel)
        
    }
}
