//
//  ExploreViewController.swift
//  Moon
//
//  Created by Evan Noble on 5/10/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Material
import PageMenu
import RxSwift
import RxCocoa
import iCarousel
import SwaggerClient

class ExploreViewController: UIViewController, BindableType {
    
    var viewModel: ExploreViewModel!
    
    class func instantiateFromStoryboard() -> ExploreViewController {
        let storyboard = UIStoryboard(name: "Explore", bundle: nil)
        // swiftlint:disable:next force_cast
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! ExploreViewController
    }
    
    @IBOutlet weak var topBarPageController: UIPageControl!
    @IBOutlet weak var topBarCarousel: iCarousel!
    fileprivate let reuseIdentifier = "TopBarCell"
    
    @IBOutlet weak var viewForPageMenu: UIView!
    var pageMenu: CAPSPageMenu?
    var controllerArray = [UIViewController]()
    
    var topBars = [TopBar]()
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPagingMenuController()
        setupCarousel()
        
        topBarPageController.superview?.bringSubview(toFront: topBarPageController)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.topBars.execute()
    }
    
    private func setupCarousel() {
        topBarCarousel.isPagingEnabled = true
        topBarCarousel.type = .linear
        topBarCarousel.bounces = false
    }
    
    func bindViewModel() {
        viewModel.topBars.elements.subscribe(onNext: { [weak self] topBars in
            self?.topBars = topBars
            self?.topBarCarousel.reloadData()
        })
        .addDisposableTo(bag)
    }

}

extension ExploreViewController {
    fileprivate func setupPagingMenuController() {
        var beerSpecialsController = SpecialsViewController.instantiateFromStoryboard()
        beerSpecialsController.bindViewModel(to: viewModel.createSpecialViewModel())
        beerSpecialsController.title = "Beer"
        controllerArray.append(beerSpecialsController)
        
        var liquorSpecialsController = SpecialsViewController.instantiateFromStoryboard()
        liquorSpecialsController.bindViewModel(to: viewModel.createSpecialViewModel())
        liquorSpecialsController.title = "Liquor"
        controllerArray.append(liquorSpecialsController)
        
        var wineSpecialsController = SpecialsViewController.instantiateFromStoryboard()
        wineSpecialsController.bindViewModel(to: viewModel.createSpecialViewModel())
        wineSpecialsController.title = "Wine"
        controllerArray.append(wineSpecialsController)
        
        let parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(4.3),
            .menuItemSeparatorPercentageHeight(0.1),
            .scrollMenuBackgroundColor(.white),
            .selectionIndicatorColor(.clear),
            .addBottomMenuHairline(false),
            .useMenuLikeSegmentedControl(true),
            .selectionIndicatorColor(.moonBlue),
            .unselectedMenuItemLabelColor(.lightGray),
            .selectedMenuItemLabelColor(.darkGray),
            .enableHorizontalBounce(false),
            .menuItemSeparatorColor(.clear)
        ]
        
        let sizeOfFrame = CGRect(x: 0, y: 0, width: viewForPageMenu.frame.width, height: viewForPageMenu.frame.height)
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: sizeOfFrame, pageMenuOptions: parameters)
        pageMenu?.view.backgroundColor = .lightGray
        if let view = pageMenu?.view {
            viewForPageMenu.addSubview(view)
        }
        
    }
}

extension ExploreViewController: iCarouselDataSource, iCarouselDelegate {
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        
        return value
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return topBars.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let topBarView = ImageViewCell(frame: carousel.frame)
        topBarView.initializeImageCardViewWith(data: topBars[index], downloadAction: viewModel.downloadImage(url: topBars[index].imageURL))
        //TODO: enter real bar id once api returns bar snapshot and i can get rid of the top bar model
        topBarView.moreButton.rx.action = viewModel.showBar(barID: "123123")
        return topBarView
    }
}
