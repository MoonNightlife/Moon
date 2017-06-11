//
//  SearchBar.swift
//  Moon
//
//  Created by Evan Noble on 5/16/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import Material

extension SearchBar {
    
    open func createLineUnderSearchTextAndIcon(color: UIColor) {
        // The search icon is not part of the content view (text field),
        // so we need to start the line at the beginning of the search icon
        let widthOfLeftSearchIcon = leftViews[0].width
        
        // Larger the number the closer the line is to the searchBar
        let heightOffset: CGFloat = 5.0
        let sideMarginForLine: CGFloat = 10
        
        let startPoint = CGPoint(x: -widthOfLeftSearchIcon + sideMarginForLine, y: contentView.height - heightOffset)
        let endPoint = CGPoint(x: contentView.width - sideMarginForLine, y: contentView.height - heightOffset)

        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.name = "searchBarLine"

        // Remove old layer
        if let layers = contentView.layer.sublayers {
            for (index, layer) in layers.enumerated() where layer.name == "searchBarLine" {
                contentView.layer.sublayers?.remove(at: index)
            }
        }
        
        contentView.layer.addSublayer(shapeLayer)
    }
    
    open func changeLineUnderSearchTextAndIcon(color: UIColor) {
        guard let lineLayer = contentView.layer.sublayers?.last as? CAShapeLayer else {
            return
        }
        
        lineLayer.strokeColor = color.cgColor
    }
    
    open func changeIconButtonsTint(color: UIColor) {
        for icon in leftViews {
            icon.tintColor = color
        }
        
        for icon in rightViews {
            icon.tintColor = color
        }
    }
    
}
