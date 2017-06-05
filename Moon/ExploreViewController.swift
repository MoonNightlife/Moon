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
import iCarousel

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

    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupPagingMenuController()
        setupCarousel()
        
        topBarPageController.superview?.bringSubview(toFront: topBarPageController)
    }
    
    private func setupCarousel() {
        topBarCarousel.isPagingEnabled = true
        topBarCarousel.type = .linear
        topBarCarousel.bounces = false
    }
    
    func bindViewModel() {
        
    }

}

extension ExploreViewController {
    fileprivate func setupPagingMenuController() {
        let beerSpecialsController = SpecialsViewController.instantiateFromStoryboard()
        beerSpecialsController.title = "Beer"
        beerSpecialsController.specialData = fakeSpecials.filter({$0.type == .beer})
        controllerArray.append(beerSpecialsController)
        
        let liquorSpecialsController = SpecialsViewController.instantiateFromStoryboard()
        liquorSpecialsController.title = "Liquor"
        liquorSpecialsController.specialData = fakeSpecials.filter({$0.type == .liquor})
        controllerArray.append(liquorSpecialsController)
        
        let wineSpecialsController = SpecialsViewController.instantiateFromStoryboard()
        wineSpecialsController.title = "Wine"
        wineSpecialsController.specialData = fakeSpecials.filter({$0.type == .wine})
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
        return fakeTopBars.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let topBarView = ImageViewCell(frame: carousel.frame)
        topBarView.initializeImageCardViewWith(data: fakeTopBars[index])
        return topBarView
    }
}
