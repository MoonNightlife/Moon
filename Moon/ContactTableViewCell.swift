//
//  ContactTableViewCell.swift
//  Moon
//
//  Created by Evan Noble on 6/16/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Action
import RxCocoa

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var addFriendButton: UIButton!

    func initCell(user: UserSnapshot, addAction: CocoaAction) {
        name.text = user.name
        profilePicture.image = user.picture
        addFriendButton.rx.action = addAction
    }
}
