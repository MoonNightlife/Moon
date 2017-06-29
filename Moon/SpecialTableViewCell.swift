//
//  SpecialTableViewCell.swift
//  Moon
//
//  Created by Evan Noble on 5/10/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Action
import RxCocoa
import RxSwift

class SpecialTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var mainTitle: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var numLikesButton: UIButton!
    @IBOutlet weak var barNameButton: UIButton!
    
    var bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
     
    func initilizeSpecialCell() {
        setupImageView()
        selectionStyle = .none
    }
    
    func setupImageView() {
        mainImage.layer.masksToBounds = false
        mainImage.layer.cornerRadius = mainImage.height / 2
        mainImage.clipsToBounds = true
    }
    
    func changeHeart(color: HeartColor) {
        switch color {
        case .red:
            likeButton.tintColor = .moonRed
        case .gray:
            likeButton.tintColor = .darkGray
        }
    }
    
    override func prepareForReuse() {
        bag = DisposeBag()
    }

}
