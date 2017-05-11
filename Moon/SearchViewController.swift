//
//  SearchViewController.swift
//  Moon
//
//  Created by Evan Noble on 5/10/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import PagingMenuController
import Material
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
    var options: PagingMenuControllerCustomizable = PagingMenuOptions()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        createTempTopBarData()
        setupPagingMenuController()
        setupCarousel()
    }
    
    private func setupCarousel() {
        topBarCarousel.isPagingEnabled = true
        topBarCarousel.type = .linear
    }
    
    private func createTempTopBarData() {
        for i in 1..<7 {
            let data = TopBarData(imageName: "pic\(i).jpg", barName: "BarName\(i)", location: "Location\(i)")
            topBarData.append(data)
        }
        topBarCarousel.reloadData()
    }
    
    private func setupPagingMenuController() {
        guard let pagingMenuController = self.childViewControllers.first as? PagingMenuController else {
            return
        }
        
        pagingMenuController.setup(options)
        pagingMenuController.onMove = { state in
            switch state {
            case let .willMoveController(menuController, previousMenuController):
                print(previousMenuController)
                print(menuController)
            case let .didMoveController(menuController, previousMenuController):
                print(previousMenuController)
                print(menuController)
            case let .willMoveItem(menuItemView, previousMenuItemView):
                print(previousMenuItemView)
                print(menuItemView)
            case let .didMoveItem(menuItemView, previousMenuItemView):
                print(previousMenuItemView)
                print(menuItemView)
            case .didScrollStart:
                print("Scroll start")
            case .didScrollEnd:
                print("Scroll end")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
    }

}

extension SearchViewController: iCarouselDataSource, iCarouselDelegate {
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        return value
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        print(topBarData.count)
        return topBarData.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let topBarView = ImageCardView(frame: carousel.frame)
        topBarView.initializeCollectionViewWith(data: topBarData[index])
        return topBarView
    }
}
