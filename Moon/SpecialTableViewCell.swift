//
//  SpecialTableViewCell.swift
//  Moon
//
//  Created by Evan Noble on 5/10/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Action

class SpecialTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var secondaryImage: UIImageView!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var secondarySubtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
     
    func initilizeSpecialCellWith(data: SpecialCell, likeAction: CocoaAction) {
        setupImageView()
        
        mainImage.image = data.image
        mainTitle.text = data.description
        subTitle.text = data.barName
        secondarySubtitle.text = "\(data.likes)"
    }
    
    func setupImageView() {
        mainImage.layer.masksToBounds = false
        mainImage.layer.cornerRadius = mainImage.height / 2
        mainImage.clipsToBounds = true
    }
    
    func changeHeart(color: HeartColor) {
        switch color {
        case .red:
            subTitle.tintColor = .moonRed
        case .gray:
            subTitle.tintColor = .darkGray
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
