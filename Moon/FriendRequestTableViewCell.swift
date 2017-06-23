//
//  FriendRequestTableViewCell.swift
//  Moon
//
//  Created by Evan Noble on 6/21/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class FriendRequestTableViewCell: UITableViewCell {
    
    var bag = DisposeBag()
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!

    override func prepareForReuse() {
        bag = DisposeBag()
    }
}