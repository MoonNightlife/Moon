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
    
    override func awakeFromNib() {
        name.font = UIFont.moonFont(size: 17)
    }

    override func prepareForReuse() {
        bag = DisposeBag()
        acceptButton.rx.action = nil
        declineButton.rx.action = nil
    }
}
