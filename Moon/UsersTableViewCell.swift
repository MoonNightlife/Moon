//
//  UsersTableViewCell.swift
//  Moon
//
//  Created by Evan Noble on 6/13/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UsersTableViewCell: UITableViewCell {
    var bag = DisposeBag()
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func prepareForReuse() {
        bag = DisposeBag()
    }

}
