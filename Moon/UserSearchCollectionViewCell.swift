//
//  UserSearchCollectionViewCell.swift
//  Moon
//
//  Created by Evan Noble on 6/10/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Material

class UserSearchCollectionViewCell: ImageCardView {
    
    fileprivate var addFriendButton: IconButton!
    fileprivate var nameLabel: UILabel!
    
    func initCellWith(user: SearchSnapshot) {
        let image = UIImage(named: user.picture)
        self.initializeImageCardViewWith(type: .small(image: image!, text: ""))
        prepareAddFriendButton()
        prepareNameLabel(text: user.name)
        prepareToolbar()
    }
}

extension UserSearchCollectionViewCell {
    
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
