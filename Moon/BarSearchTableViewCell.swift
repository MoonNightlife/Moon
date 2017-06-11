//
//  BarSearchTableViewCell.swift
//  Moon
//
//  Created by Evan Noble on 6/10/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit

class BarSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var barImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func initCellWith(bar: BarCell) {
        barImageView.image = UIImage(named: bar.picture)
        nameLabel.text = bar.name
    }
}
