//
//  UserSearchCollectionViewCell.swift
//  Moon
//
//  Created by Evan Noble on 6/10/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Material
import Action
import RxSwift
import RxCocoa

class UserCollectionView: ImageCardView {
    
    fileprivate var addFriendButton: IconButton!
    fileprivate var nameLabel: UILabel!
    fileprivate let bag = DisposeBag()
    
    func initViewWith(user: SearchSnapshot, addAction: CocoaAction, downloadImage: Action<Void, UIImage>) {
        
        self.initializeImageCardViewWith(type: .small(image: downloadImage, text: ""))
        prepareAddFriendButton()
        prepareNameLabel(text: user.name)
        prepareToolbar()
        
        addFriendButton.rx.action = addAction
    }

}

extension UserCollectionView {
    
    fileprivate func prepareNameLabel(text: String) {
        nameLabel = UILabel()
        nameLabel.text = text
        nameLabel.textColor = .lightGray
        nameLabel.font = UIFont(name: "Roboto", size: 10)
        nameLabel.sizeToFit()
    }
    
    fileprivate func prepareAddFriendButton() {
        var image = #imageLiteral(resourceName: "AddFriendIcon")
        image = image.withRenderingMode(.alwaysTemplate)
        addFriendButton = IconButton(image: image, tintColor: .lightGray)
    }
    
    fileprivate func prepareToolbar() {
        self.bottomToolbar.rightViews = [addFriendButton]
        self.bottomToolbar.leftViews = [nameLabel]
    }
}
