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
import SwaggerClient

class SpecialTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var secondaryImage: UIImageView!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var secondarySubtitle: UILabel!
    
    private var bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
     
    func initilizeSpecialCellWith(data: Special, likeAction: CocoaAction, downloadImage: Action<Void, UIImage>) {
        setupImageView()
        
        downloadImage.elements.bind(to: mainImage.rx.image).addDisposableTo(bag)
        downloadImage.execute()
        
        mainTitle.text = data.description
        subTitle.text = data.name
        secondarySubtitle.text = "\(data.numLikes!)"
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
    
    override func prepareForReuse() {
        bag = DisposeBag()
    }

}
