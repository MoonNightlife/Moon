//
//  PeopleGoingCarouselView.swift
//  Moon
//
//  Created by Gabriel I Leyva Merino on 6/9/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import UIKit
import Material

class PeopleGoingCarouselView: UIView {
    
    fileprivate var view: UIView!
    
    /// Content area.
    fileprivate var imageView: UIImageView!
    fileprivate var label: UILabel!
    
    func initializeViewWith(imageName: String, name: String, frame: CGRect) {
        self.frame = frame
        prepareView()
        prepareImageView(imageName: imageName)
        prepareNameLable(name: name)
        prepareToPresentView()
    }

}

extension PeopleGoingCarouselView {
    
    fileprivate func prepareImageView(imageName: String) {
        let image = UIImage(named: imageName)
        imageView = UIImageView(image: image)
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height / 1.2)
    }
    
    fileprivate func prepareNameLable(name: String) {
        label = UILabel()
        label.text =  name
        label.textColor = .lightGray
        label.textAlignment = .center
        label.font = UIFont(name: "Roboto", size: 15)
        label.frame = CGRect(x: 0, y: self.frame.size.height - 26, width: self.frame.size.width, height: 21)
    }
    
    fileprivate func prepareView() {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 1
    }
    
    fileprivate func prepareToPresentView() {
        self.addSubview(imageView)
        self.addSubview(label)
        self.backgroundColor = .white
    }
}
