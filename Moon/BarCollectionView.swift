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
    
    var goButton: IconButton!
    var nameLabel: UILabel!
    
    func initViewWith() {
        self.initializeImageCardViewWith(type: .small)
        prepareAddFriendButton()
        prepareNameLabel()
        prepareToolbar()
    }

}

extension BarCollectionView {
    
    fileprivate func prepareNameLabel() {
        nameLabel = UILabel()
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
