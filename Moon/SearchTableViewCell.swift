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
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    var bag = DisposeBag()
    
    override func awakeFromNib() {
        nameLabel.font = UIFont.moonFont(size: 16)
        nameLabel.textColor = .darkGray
        
        usernameLabel.font = UIFont.moonFont(size: 14)
        usernameLabel.textColor = .lightGray
    }
    
    func initCellWith() {
        prepareImageView()
    }
    
    fileprivate func prepareImageView() {
        mainImageView.cornerRadius = mainImageView.frame.size.width / 2
        mainImageView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        bag = DisposeBag()
    }

}
