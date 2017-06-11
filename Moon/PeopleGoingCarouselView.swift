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

class PeopleGoingCarouselView: ImageCardView {
    
    fileprivate var user: BarActivity!
    fileprivate var index: Int?
    fileprivate var likeButton: IconButton!
    
    func initializeViewWith(user: BarActivity, index: Int) {
        
        self.initializeImageCardView(text: user.name!, imageName: user.profileImage!)
        prepareLikeButton()
    }
    
}

extension PeopleGoingCarouselView {
    
    fileprivate func prepareLikeButton() {
        likeButton = IconButton(image: Icon.favorite, tintColor: .lightGray)
        self.toolBar.rightViews = [likeButton]
    }
}
