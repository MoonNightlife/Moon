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

enum ScrollDirection {
    case right
    case left
}

enum MainView: Int {
    case specials
    case moons
    case features
}

class MasterViewController: UIViewController {

    @IBOutlet weak var masterCarousel: iCarousel!
    @IBOutlet weak var currentViewButton: MDCFloatingButton!
    @IBOutlet weak var rightViewButton: MDCFloatingButton!
    @IBOutlet weak var leftViewButton: MDCFloatingButton!
    
    let numberOfMainViews = 3
    
    @IBAction func showRightView(_ sender: Any) {
        let nextView = getNextViewForScroll(direction: .right)
        changeBottomButtonsLayoutFor(nextView: nextView)
        masterCarousel.scrollToItem(at: nextView.rawValue, animated: true)
    }
    
    @IBAction func showLeftView(_ sender: Any) {
        let nextView = getNextViewForScroll(direction: .left)
        changeBottomButtonsLayoutFor(nextView: nextView)
        masterCarousel.scrollToItem(at: nextView.rawValue, animated: true)
    }
    
    private func getNextViewForScroll(direction: ScrollDirection) -> MainView {
        var scrollToView: MainView!
        
        guard let currentView = MainView(rawValue: masterCarousel.currentItemIndex) else {
            return .specials
        }
        
        switch direction {
        case .right:
            switch currentView {
            case .specials:
                scrollToView = .moons
            case .moons:
                scrollToView = .features
            case .features:
                scrollToView = .specials
            }
        case .left:
            switch currentView {
            case .specials:
                scrollToView = .features
            case .moons:
                scrollToView = .specials
            case .features:
                scrollToView = .moons
            }
        }
        
        return scrollToView
    }
    
    private func changeBottomButtonsLayoutFor(nextView: MainView) {
        print("animate buttons moving")
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
        if option == .showBackfaces {
            // False
            return 0
        }
        
        return value
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return numberOfMainViews
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {

        var itemViewController: UIViewController
        
        guard let view = MainView(rawValue: index) else {
            return UIView()
        }
        
        switch view {
        case .specials:
            itemViewController = SearchViewController.instantiateFromStoryboard()
        case .moons:
            itemViewController = MoonsViewViewController.instantiateFromStoryboard()
        case .features:
            itemViewController = FeaturedViewController.instantiateFromStoryboard()
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
