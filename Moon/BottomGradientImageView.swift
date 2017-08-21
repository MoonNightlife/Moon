//
//  BottomGradientImageView.swift
//  Moon
//
//  Created by Evan Noble on 5/18/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit

class BottomGradientImageView: UIImageView {
    
    var gradientLayer: CAGradientLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        gradientLayer = createBlackGradient()
        self.layer.addSublayer(gradientLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func createBlackGradient() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: self.bounds.midY, width: self.bounds.width, height: self.bounds.height / 2)
        let topColor = UIColor.init(white: 0, alpha: 0).cgColor
        let bottomColor = UIColor.init(white: 0, alpha: 0.75).cgColor
        
        gradientLayer.colors = [topColor, bottomColor]
        gradientLayer.locations = [0.0, 1.0]
        
        return gradientLayer
    }

}
