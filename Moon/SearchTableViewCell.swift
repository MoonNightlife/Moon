//
//  SeachTableViewCell.swift
//  Moon
//
//  Created by Evan Noble on 6/12/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Action

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    func initCellWith(snapshot: SearchSnapshot) {
        mainImageView.image = UIImage(named: snapshot.picture)
        nameLabel.text = snapshot.name
        
        prepareImageView()
        prepareLabel()
    }
    
    fileprivate func prepareImageView() {
        mainImageView.cornerRadius = mainImageView.frame.size.width / 2
        mainImageView.clipsToBounds = true
    }
    
    fileprivate func prepareLabel() {
        nameLabel.textColor = .lightGray
    }

}
