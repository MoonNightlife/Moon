//
//  MainViewController.swift
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
import EZSwipeController

enum MainView: Int {
    case featured
    case moons
    case explore
}

class MainViewController: EZSwipeController, BindableType {
    
    var viewModel: MainViewModel!

    @IBOutlet weak var tabBar: FloatingBottomTabBar!
    
    let numberOfMainViews = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        // Has to be called after view is showen
        prepareSearchBar()
        // Has to be called after view is showen
        setFrameForCurrentOrientation()
        
        changeColorForTabBarAndSearchBar(nextView: .moons)
    }
    
    override func setupView() {
        datasource = self
        navigationBarShouldNotExist = true
    }
    
    private func setupTabBar() {
        // Bring tab bar to front of all other views
        tabBar.superview?.bringSubview(toFront: tabBar)
        tabBar.initializeTabBar()
        tabBar.delegate = self
    }
    
    func bindViewModel() {
        
    }
    
}

extension MainViewController: FloatingBottomTabBarDelegate {
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

extension MainViewController: EZSwipeControllerDataSource {
    func viewControllerData() -> [UIViewController] {
        let featuredVC = FeaturedViewController.instantiateFromStoryboard()
        let exploreVC = ExploreViewController.instantiateFromStoryboard()
        let moonsViewVC = MoonsViewViewController.instantiateFromStoryboard()
        return [featuredVC, moonsViewVC, exploreVC]
    }
    
    func indexOfStartingPage() -> Int {
        return MainView.moons.rawValue
    }
}

extension MainViewController: SearchBarDelegate {
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
