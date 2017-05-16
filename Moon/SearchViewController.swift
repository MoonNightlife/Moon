//
//  SearchViewController.swift
//  Moon
//
//  Created by Evan Noble on 5/10/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Material
import PageMenu
import iCarousel

class SearchViewController: UIViewController {
    
    class func instantiateFromStoryboard() -> SearchViewController {
        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        // swiftlint:disable:next force_cast
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! SearchViewController
    }
    
    @IBOutlet weak var topBarCarousel: iCarousel!
    fileprivate let reuseIdentifier = "TopBarCell"
    fileprivate var topBarData = [TopBarData]()
    
    @IBOutlet weak var viewForPageMenu: UIView!
    var pageMenu: CAPSPageMenu?
    var controllerArray = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        createTempTopBarData()
        setupPagingMenuController()
        setupCarousel()
    }
    
    private func setupCarousel() {
        topBarCarousel.isPagingEnabled = true
        topBarCarousel.type = .linear
        topBarCarousel.bounces = false
    }
    
    // Function can be deleted once we are aren't using fake top bar data
    private func createTempTopBarData() {
        for i in 1..<7 {
            let data = TopBarData(imageName: "pic\(i).jpg", barName: "BarName\(i)", location: "Location\(i)")
            topBarData.append(data)
        }
        topBarCarousel.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
    }

}

extension SearchViewController {
    fileprivate func setupPagingMenuController() {
        let beerSpecialsController = SpecialsViewController.instantiateFromStoryboard()
        beerSpecialsController.title = "Beer"
        beerSpecialsController.specialData = fakeSpecials.filter({$0.type == .beer})
        controllerArray.append(beerSpecialsController)
        
        let liquorSpecialsController = SpecialsViewController.instantiateFromStoryboard()
        liquorSpecialsController.title = "Liqiour"
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
            .addBottomMenuHairline(true),
            .useMenuLikeSegmentedControl(true),
            .selectionIndicatorColor(MoonColor.Blue),
            .unselectedMenuItemLabelColor(.lightGray),
            .selectedMenuItemLabelColor(.lightGray),
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

extension SearchViewController: iCarouselDataSource, iCarouselDelegate {
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        
        return value
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return topBarData.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let topBarView = ImageCardView(frame: carousel.frame)
        topBarView.initializeImageCardViewWith(data: topBarData[index])
        return topBarView
    }
}
