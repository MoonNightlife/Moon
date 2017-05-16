//
//  SearchBar.swift
//  Moon
//
//  Created by Evan Noble on 5/16/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import Material

extension Bar {
    open func drawLineUnderSearchTextAndIcon(color: UIColor) {
        
        // The search icon is not part of the content view (text field),
        // so we need to start the line at the beginning of the search icon
        let widthOfLeftSearchIcon = leftViews[1].width
        
        // Larger the number the closer the line is to the searchBar
        let heightOffset: CGFloat = 5.0
        
        let startPoint = CGPoint(x: -widthOfLeftSearchIcon, y: contentView.height - heightOffset)
        let endPoint = CGPoint(x: contentView.width, y: contentView.height - heightOffset)
        print(startPoint)
        print(endPoint)
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 2
        
        contentView.layer.addSublayer(shapeLayer)
        
    }
}
