//
//  TutorialViewController.swift
//  Moon
//
//  Created by Evan Noble on 7/18/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import iCarousel
import Material

class TutorialViewController: UIViewController, BindableType {

    @IBOutlet weak var tutorialCarousel: iCarousel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var pageController: UIPageControl!
    
    var viewModel: TutorialViewModel!
    enum TutorialViews: Int {
        case search, feature, moon, explore
        
        static let count = 4
        
        func image() -> UIImage {
            switch self {
            case .search: return #imageLiteral(resourceName: "SearchTutorial")
            case .feature: return #imageLiteral(resourceName: "FeaturedEventsTutorial")
            case .moon: return #imageLiteral(resourceName: "MoonsViewTutorial")
            case .explore: return #imageLiteral(resourceName: "ExploreTutorial")
            }
        }
    }
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCancelButton()
        setupTutorialCarousel()
        setupPageController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tutorialCarousel.reloadData()
    }
    
    // MARK: - Setup View
    private func setupTutorialCarousel() {
        tutorialCarousel.isPagingEnabled = true
        tutorialCarousel.clipsToBounds = true
        tutorialCarousel.dataSource = self
        tutorialCarousel.delegate = self
        tutorialCarousel.bounces = false
    }
    
    private func setupCancelButton() {
        cancelButton.setImage(Icon.cm.close?.tint(with: .moonRed), for: .normal)
        cancelButton.rx.action = viewModel.onBack()
    }
    
    private func setupPageController() {
        pageController.numberOfPages = TutorialViews.count
        pageController.pageIndicatorTintColor = .lightGray
        pageController.currentPageIndicatorTintColor = .darkGray
    }
    
    func bindViewModel() {
        
    }

}

// MARK: - iCarousel Delegate and Datasource
extension TutorialViewController: iCarouselDelegate, iCarouselDataSource {

    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        pageController.currentPage = carousel.currentItemIndex
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return TutorialViews.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        let imageForIndex = TutorialViews.init(rawValue: index)?.image()
        
        if let view = view as? UIImageView {
            view.image = imageForIndex
            return view
        } else {
            let imageView = UIImageView(frame: carousel.bounds)
            imageView.image = imageForIndex
            return imageView
        }
    }
}
