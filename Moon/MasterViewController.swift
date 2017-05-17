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
import Material

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
    
    class func instantiateFromStoryboard() -> MasterViewController {
        let storyboard = UIStoryboard(name: "Master", bundle: nil)
        // swiftlint:disable:next force_cast
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! MasterViewController
    }

    var masterCarousel: iCarousel!
    @IBOutlet weak var currentViewButton: MDCFloatingButton!
    @IBOutlet weak var rightViewButton: MDCFloatingButton!
    @IBOutlet weak var leftViewButton: MDCFloatingButton!
    
    let numberOfMainViews = 3
    
    @IBAction func showRightView(_ sender: Any) {
        let nextView = getNextViewForScroll(direction: .right)
        changeBottomButtonsLayoutFor(nextView: nextView)
        changeSearchBarLineColorFor(nextView: nextView)
        masterCarousel.scrollToItem(at: nextView.rawValue, animated: true)
    }
    
    @IBAction func showLeftView(_ sender: Any) {
        let nextView = getNextViewForScroll(direction: .left)
        changeBottomButtonsLayoutFor(nextView: nextView)
        changeSearchBarLineColorFor(nextView: nextView)
        masterCarousel.scrollToItem(at: nextView.rawValue, animated: true)
    }
    
    private func changeSearchBarLineColorFor(nextView: MainView) {
        guard let searchBar = searchBarController?.searchBar else {
            return
        }
        
        switch nextView {
        case .features:
            searchBar.changeIconButtonsTint(color: .white)
            searchBar.changeLineUnderSearchTextAndIcon(color: .white)
            searchBar.backgroundColor = .moonRed
        case .moons:
            searchBar.changeIconButtonsTint(color: .white)
            searchBar.changeLineUnderSearchTextAndIcon(color: .white)
            searchBar.backgroundColor = .moonPurple
        case .specials:
            searchBar.changeIconButtonsTint(color: .white)
            searchBar.changeLineUnderSearchTextAndIcon(color: .white)
            searchBar.backgroundColor = .moonBlue
        }
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
        setupNavigationButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        prepareSearchBar()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    private func setupNavigationButtons() {
        // Bring the buttons in front of carousel
        leftViewButton.superview?.bringSubview(toFront: leftViewButton)
        currentViewButton.superview?.bringSubview(toFront: currentViewButton)
        rightViewButton.superview?.bringSubview(toFront: rightViewButton)
        
        // Change button colors
        leftViewButton.backgroundColor = .white
        currentViewButton.backgroundColor = .white
        rightViewButton.backgroundColor = .white
    
    }
    
    private func setupCarousel() {
        masterCarousel = iCarousel()
        masterCarousel.type = .rotary
        masterCarousel.isPagingEnabled = true
        view.layout(masterCarousel).edges()
        masterCarousel.dataSource = self
        masterCarousel.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MasterViewController: SearchBarDelegate {
    fileprivate func prepareSearchBar() {
        guard let searchBar = searchBarController?.searchBar else {
            return
        }
        
        searchBar.delegate = self
        // Has to be called after the searchBar is loaded in view controller
        searchBar.drawLineUnderSearchTextAndIcon(color: .white)
        searchBar.backgroundColor = .moonBlue
    }
    
    func searchBar(searchBar: SearchBar, didChange textField: UITextField, with text: String?) {
        print("search database for \(text ?? "error")")
    }
    
    func searchBar(searchBar: SearchBar, willClear textField: UITextField, with text: String?) {
        print("clear")
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
