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
import Material

class SpecialTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var mainTitle: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var numLikesButton: UIButton!
    @IBOutlet weak var barNameButton: UIButton!
    
    var bag = DisposeBag()
    var heartColor: HeartColor = .gray
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
     
    func initilizeSpecialCell() {
        setupImageView()
        selectionStyle = .none
        likeButton.setImage(Icon.favorite?.tint(with: .lightGray), for: .normal)
    }
    
    func toggleColorAndNumber() {
        
        likeButton.setImage(Icon.favorite?.tint(with: heartColor == .gray ? .red : .lightGray), for: .normal)
        if let numString = numLikesButton.titleLabel?.text, let num = Int(numString) {
            print(numString)
            numLikesButton.setTitle("\(heartColor == .gray ? num + 1 : num - 1)", for: .normal)
        }
        
        heartColor = heartColor == .gray ? .red : .gray
    }
    
    func setupImageView() {
        mainImage.layer.masksToBounds = false
        mainImage.layer.cornerRadius = mainImage.height / 2
        mainImage.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        bag = DisposeBag()
    }

}
