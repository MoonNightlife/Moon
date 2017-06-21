//
//  ContactTableViewCell.swift
//  Moon
//
//  Created by Evan Noble on 6/16/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Action
import RxSwift
import RxCocoa
import SwaggerClient

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var addFriendButton: UIButton!
    
    private var bag = DisposeBag()

    func initCell(user: UserSnapshot, addAction: CocoaAction, downloadAction: Action<Void, UIImage>) {
        name.text = user.fullName
        addFriendButton.rx.action = addAction
        downloadAction.elements.bind(to: profilePicture.rx.image).addDisposableTo(bag)
        downloadAction.execute()
    }
    
    override func prepareForReuse() {
        bag = DisposeBag()
    }
}
