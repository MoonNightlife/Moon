//
//  UserSearchCollectionViewCell.swift
//  Moon
//
//  Created by Evan Noble on 6/10/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit

class UserSearchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    func initCellWith(user: SearchSnapshot) {
        self.imageView.image = UIImage(named: user.picture)
        self.nameLabel.text = user.name
    }
}
