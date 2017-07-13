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
import EZSwipeController
import RxSwift
import RxCocoa

class MainViewController: EZSwipeController, BindableType {
    
    var viewModel: MainViewModel!
    private let bag = DisposeBag()

    @IBOutlet weak var tabBar: FloatingBottomTabBar!
    @IBOutlet weak var tabBarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tabBarWidthConstraint: NSLayoutConstraint!
    let numberOfMainViews = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This disables the scrolling of the EZSwipeController
        // In the future we would want to just remove the EZSwipeController
        for view in self.pageViewController.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
        
        setupTabBar()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        // Has to be called after view is showen
        if let searchBarController = searchBarController as? SearchBarViewController {
            searchBarController.prepareSearchBarForMainView()
        }
        
        // Changing the color needs to happen after the view has appeared. Once we include animations we will
        // need ot move this to another section, so it wont animate every time a modal is dismissed
        changeColorForTabBarAndSearchBar(nextView: MainView(rawValue: self.currentVCIndex) ?? .moons)
    }
    
    override func setupView() {
        datasource = self
        navigationBarShouldNotExist = true
    }
    
    private func setupTabBar() {
        // Bring tab bar to front of all other views
        tabBar.superview?.bringSubview(toFront: tabBar)
        tabBarHeightConstraint.constant = self.view.frame.size.height * 0.0899
        tabBarWidthConstraint.constant = self.view.frame.size.width * 0.533
        tabBar.frame.size.width = tabBarWidthConstraint.constant
        tabBar.frame.size.height = tabBarHeightConstraint.constant
        tabBar.initializeTabBar()
    }
    
    func bindViewModel() {

        tabBar.rx.showExploreView
            .subscribe(onNext: { [weak self] in
                self?.viewModel.onChangeView().execute(.explore)
                self?.changeColorForTabBarAndSearchBar(nextView: .explore)
            })
            .addDisposableTo(bag)
        
        tabBar.rx.showFeatured
            .subscribe(onNext: { [weak self] in
                self?.viewModel.onChangeView().execute(.featured)
                self?.changeColorForTabBarAndSearchBar(nextView: .featured)
            })
            .addDisposableTo(bag)
        
        tabBar.rx.showMoonsView
            .subscribe(onNext: { [weak self] in
                self?.viewModel.onChangeView().execute(.moons)
                self?.changeColorForTabBarAndSearchBar(nextView: .moons)
            })
            .addDisposableTo(bag)
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
        
        controller.statusBar.backgroundColor = color
        controller.searchBar.backgroundColor = color
        tabBar.backgroundColor = color
    }
    
}

extension MainViewController: EZSwipeControllerDataSource {
    func viewControllerData() -> [UIViewController] {
        // This should be done in the view model/scene coordinator
        var featuredVC = FeaturedViewController.instantiateFromStoryboard()
        let featuredVM = viewModel.viewModelForFeatured()
        featuredVC.bindViewModel(to: featuredVM)
        var exploreVC = ExploreViewController.instantiateFromStoryboard()
        exploreVC.bindViewModel(to: viewModel.viewModelForExplore())
        var moonsViewVC = MoonsViewViewController.instantiateFromStoryboard()
        moonsViewVC.bindViewModel(to: viewModel.viewModelForMoonsView())
        return [featuredVC, moonsViewVC, exploreVC]
    }
    
    func indexOfStartingPage() -> Int {
        return MainView.moons.rawValue
    }
}
