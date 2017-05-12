//
//  MasterViewController.swift
//  Moon
//
//  Created by Evan Noble on 5/11/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import iCarousel

class MasterViewController: UIViewController {

    @IBOutlet weak var masterCarousel: iCarousel!
    var items: [Int] = [1, 2, 3]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCarousel()
    }
    
    private func setupCarousel() {
        masterCarousel.type = .rotary
        masterCarousel.isPagingEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MasterViewController: iCarouselDelegate, iCarouselDataSource {
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == .spacing {
            return value * 1
        }
        
        if option == .showBackfaces {
            return 0
        }
        return value
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return items.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {

        var itemViewController: UIViewController
        
        switch index {
        case 0:
            itemViewController = FeaturedViewController.instantiateFromStoryboard()
        case 1:
            itemViewController = SearchViewController.instantiateFromStoryboard()
        case 2:
            itemViewController = MoonsViewViewController.instantiateFromStoryboard()
        default:
            itemViewController = UIViewController()
        }
        
        self.addChildViewController(itemViewController)
        itemViewController.didMove(toParentViewController: self)
        
        return itemViewController.view
    }
}
