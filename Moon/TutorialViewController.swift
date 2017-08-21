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
        pageController.numberOfPages = viewModel.tutorialViews.count
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
        return viewModel.tutorialViews.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        let imageForIndex = viewModel.tutorialViews.images[index]
        
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
