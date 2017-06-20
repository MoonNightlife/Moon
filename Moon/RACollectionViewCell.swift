//
//  RACollectionViewCell.swift
//  Moon
//
//  Created by Gabriel I Leyva Merino on 6/20/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import UIKit

class RACollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView!
    var gradientLayer: CAGradientLayer?
    var hilightedCover: UIView!
    override var isHighlighted: Bool {
        didSet {
            hilightedCover.isHidden = !isHighlighted
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        hilightedCover.frame = bounds
        applyGradation(imageView)
    }
    
    private func configure() {
        imageView = UIImageView()
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        addSubview(imageView)
        
        hilightedCover = UIView()
        hilightedCover.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hilightedCover.backgroundColor = UIColor(white: 0, alpha: 0.5)
        hilightedCover.isHidden = true
        addSubview(hilightedCover)
    }
    
    private func applyGradation(_ gradientView: UIView!) {
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = nil
        
        gradientLayer = CAGradientLayer()
        gradientLayer!.frame = gradientView.bounds
        
        let mainColor = UIColor(white: 0, alpha: 0.3).cgColor
        let subColor = UIColor.clear.cgColor
        gradientLayer!.colors = [subColor, mainColor]
        gradientLayer!.locations = [0, 1]
        
        gradientView.layer.addSublayer(gradientLayer!)
    }

}
