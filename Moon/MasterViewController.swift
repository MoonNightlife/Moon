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
import Spring

enum MainView: Int {
    case featured
    case moons
    case explore
}

class MasterViewController: UIViewController {
    
    class func instantiateFromStoryboard() -> MasterViewController {
        let storyboard = UIStoryboard(name: "Master", bundle: nil)
        // swiftlint:disable:next force_cast
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! MasterViewController
    }

    var masterCarousel: iCarousel!

    @IBOutlet weak var exploreButton: UIButton!
    @IBOutlet weak var featuedButton: SpringButton!
    @IBOutlet weak var moonsViewButton: SpringButton!
    @IBOutlet weak var tabBar: FloatingBottomTabBar!
    
    let numberOfMainViews = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCarousel()
        setupTabBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        prepareSearchBar()
        changeColorForTabBarAndSearchBar(nextView: .moons)
        masterCarousel.scrollToItem(at: 1, animated: false)
    }
    
    private func setupTabBar() {
        // Bring tab bar to front of all other views
        tabBar.superview?.bringSubview(toFront: tabBar)
        tabBar.initializeTabBar()
        tabBar.delegate = self
    }
    
    private func setupCarousel() {
        masterCarousel = iCarousel()
        masterCarousel.type = .rotary
        masterCarousel.isPagingEnabled = true
        view.layout(masterCarousel).edges()
        masterCarousel.dataSource = self
        masterCarousel.delegate = self
    }
    
}

extension MasterViewController: FloatingBottomTabBarDelegate {
    func showMoonsView() {
        show(view: .moons)
    }
    
    func showExploreView() {
        show(view: .explore)
    }
    
    func showFeaturedView() {
        show(view: .featured)
    }
    
    private func show(view: MainView) {
        changeColorForTabBarAndSearchBar(nextView: view)
        masterCarousel.scrollToItem(at: view.rawValue, animated: true)
    }
    
    fileprivate func changeColorForTabBarAndSearchBar(nextView: MainView) {
        guard let controller = searchBarController else {
            return
        }
        
        var color: UIColor!
        
        switch nextView {
        case .featured:
            color = .moonRed
        case .moons:
            color = .moonPurple
        case .explore:
            color = .moonBlue
        }
        
        controller .statusBar.backgroundColor = color
        controller.searchBar.backgroundColor = color
        tabBar.backgroundColor = color
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
        
        if option == .wrap {
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
        case .featured:
            itemViewController = FeaturedViewController.instantiateFromStoryboard()
        case .explore:
            itemViewController = ExploreViewController.instantiateFromStoryboard()
        case .moons:
            itemViewController = MoonsViewViewController.instantiateFromStoryboard()
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
