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
    
    var addFriendButton: IconButton!
    var nameLabel: UILabel!
    let bag = DisposeBag()
    
    var tapReconizer: UITapGestureRecognizer!
    
    func initViewWith() {
        
        self.initializeImageCardViewWith(type: .small)
        prepareAddFriendButton()
        prepareNameLabel()
        prepareToolbar()
        prepareImageViewTapReconizer()
    }

}

extension UserCollectionView {
    
    fileprivate func prepareImageViewTapReconizer() {
        tapReconizer = UITapGestureRecognizer()
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapReconizer)
    }
    
    fileprivate func prepareNameLabel() {
        nameLabel = UILabel()
        nameLabel.textColor = .lightGray
        nameLabel.font = UIFont(name: "Roboto", size: 10)
        nameLabel.text = ""
        nameLabel.sizeToFit()
        nameLabel.lineBreakMode = .byTruncatingTail
    }
    
    fileprivate func prepareAddFriendButton() {
        var image = #imageLiteral(resourceName: "AddFriend")
        image = image.withRenderingMode(.alwaysTemplate)
        addFriendButton = IconButton(image: image, tintColor: .lightGray)
    }
    
    fileprivate func prepareToolbar() {
        self.bottomToolbar.rightViews = [addFriendButton]
        self.bottomToolbar.leftViews = [nameLabel]
    }
}
