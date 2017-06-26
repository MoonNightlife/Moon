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
    
    var bag = DisposeBag()
    
    override func prepareForReuse() {
        // Create new dispose bag and remove action from button before resuse
        bag = DisposeBag()
        addFriendButton.rx.action = nil
    }
}
