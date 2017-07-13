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

class MainViewController: UIViewController, BindableType {
    
    var viewModel: MainViewModel!
    private let bag = DisposeBag()

    @IBOutlet weak var tabBar: FloatingBottomTabBar!
    @IBOutlet weak var tabBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tabBarWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet var featuredView: UIView!
    @IBOutlet var moonsView: UIView!
    @IBOutlet var exploreView: UIView!
    
    var currentView: MainView!
    
    let numberOfMainViews = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        setupView()
    }
    
    func showView(view: MainView) {
        featuredView.isHidden = true
        moonsView.isHidden = true
        exploreView.isHidden = true
        
        currentView = view
        
        switch view {
        case .explore:
            exploreView.isHidden = false
        case .featured:
            featuredView.isHidden = false
        case .moons:
            moonsView.isHidden = false
        }
    }
    
    func setupView() {
        
        showView(view: .moons)
        
        var featuredVC = FeaturedViewController.instantiateFromStoryboard()
        let featuredVM = viewModel.viewModelForFeatured()
        featuredVC.bindViewModel(to: featuredVM)
        
        addChildViewController(featuredVC)
        featuredVC.view.frame = CGRect(x: 0, y: 0, width: featuredView.frame.width, height: featuredView.frame.height)
        featuredView.addSubview(featuredVC.view)
        featuredVC.didMove(toParentViewController: self)
        
        var exploreVC = ExploreViewController.instantiateFromStoryboard()
        exploreVC.bindViewModel(to: viewModel.viewModelForExplore())
        
        addChildViewController(exploreVC)
        exploreVC.view.frame = CGRect(x: 0, y: 0, width: exploreView.frame.width, height: exploreView.frame.height)
        exploreView.addSubview(exploreVC.view)
        exploreVC.didMove(toParentViewController: self)
        
        var moonsViewVC = MoonsViewViewController.instantiateFromStoryboard()
        moonsViewVC.bindViewModel(to: viewModel.viewModelForMoonsView())
        
        addChildViewController(moonsViewVC)
        exploreVC.view.frame = CGRect(x: 0, y: 0, width: moonsView.frame.width, height: moonsView.frame.height)
        moonsView.addSubview(moonsViewVC.view)
        moonsViewVC.didMove(toParentViewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        tabBar.superview?.bringSubview(toFront: tabBar)
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
        changeColorForTabBarAndSearchBar(nextView: currentView)
    }
    
    private func setupTabBar() {
        tabBarHeightConstraint.constant = self.view.frame.size.height * 0.0899
        tabBarWidthConstraint.constant = self.view.frame.size.width * 0.533
        tabBar.frame.size.width = tabBarWidthConstraint.constant
        tabBar.frame.size.height = tabBarHeightConstraint.constant
        tabBar.initializeTabBar()
    }
    
    func bindViewModel() {

        tabBar.rx.showExploreView
            .subscribe(onNext: { [weak self] in
                self?.showView(view: .explore)
                self?.changeColorForTabBarAndSearchBar(nextView: .explore)
            })
            .addDisposableTo(bag)
        
        tabBar.rx.showFeatured
            .subscribe(onNext: { [weak self] in
                self?.showView(view: .featured)
                self?.changeColorForTabBarAndSearchBar(nextView: .featured)
            })
            .addDisposableTo(bag)
        
        tabBar.rx.showMoonsView
            .subscribe(onNext: { [weak self] in
                self?.showView(view: .moons)
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
