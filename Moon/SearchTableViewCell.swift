//
//  SearchTableViewCell.swift
//  Moon
//
//  Created by Evan Noble on 6/10/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit

class BarSnapshotTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func initCellWith(snapshot: SearchSnapshot) {
        mainImageView.image = UIImage(named: snapshot.picture)
        nameLabel.text = snapshot.name
    }
}
