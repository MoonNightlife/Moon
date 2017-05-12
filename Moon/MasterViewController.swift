//
//  MasterViewController.swift
//  Moon
//
//  Created by Evan Noble on 5/11/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import iCarousel
import MaterialComponents

class MasterViewController: UIViewController {

    @IBOutlet weak var masterCarousel: iCarousel!
    @IBOutlet weak var currentViewButton: MDCFloatingButton!
    @IBOutlet weak var rightViewButton: MDCFloatingButton!
    @IBOutlet weak var leftViewButton: MDCFloatingButton!
    
    var items: [Int] = [1, 2, 3]
    
    @IBAction func showRightView(_ sender: Any) {
        scrollToNextRightView()
    }
    @IBAction func showLeftView(_ sender: Any) {
        scrollToNextLeftView()
    }
    
    private func scrollToNextRightView() {
        let currentIndex = masterCarousel.currentItemIndex
        var scrollToIndex: Int!
        
        switch currentIndex {
        case 0:
            scrollToIndex = 1
        case 1:
            scrollToIndex = 2
        case 2:
            scrollToIndex = 0
        default:
            scrollToIndex = 1
        }
        
        masterCarousel.scrollToItem(at: scrollToIndex, animated: true)
    }
    
    private func scrollToNextLeftView() {
        let currentIndex = masterCarousel.currentItemIndex
        var scrollToIndex: Int!
        
        switch currentIndex {
        case 0:
            scrollToIndex = 2
        case 1:
            scrollToIndex = 0
        case 2:
            scrollToIndex = 1
        default:
            scrollToIndex = 1
        }
        
        masterCarousel.scrollToItem(at: scrollToIndex, animated: true)
    }
    
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
        
        // These couple method calls are needed so there is a parent child relationship between the
        // new VC and the Master VC. We also have to resize the view of the created VC, so it will fit
        // in the carousel frame.
        self.addChildViewController(itemViewController)
        itemViewController.didMove(toParentViewController: self)
        itemViewController.view.frame = CGRect(x: 0, y: 0, width: carousel.frame.width, height: carousel.frame.height)
        
        return itemViewController.view
    }
}
