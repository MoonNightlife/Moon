//
//  SeachTableViewCell.swift
//  Moon
//
//  Created by Evan Noble on 6/12/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Action
import RxSwift

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var bag = DisposeBag()
    
    override func awakeFromNib() {
        nameLabel.font = UIFont.moonFont(size: 16)
        nameLabel.textColor = .darkGray
    }
    
    func initCellWith() {
        prepareImageView()
        prepareLabel()
    }
    
    fileprivate func prepareImageView() {
        mainImageView.cornerRadius = mainImageView.frame.size.width / 2
        mainImageView.clipsToBounds = true
    }
    
    fileprivate func prepareLabel() {
        
    }
    
    override func prepareForReuse() {
        bag = DisposeBag()
    }

}
