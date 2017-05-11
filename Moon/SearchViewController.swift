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

class SearchViewController: UIViewController {
    
    fileprivate let reuseIdentifier = "TopBarCell"
    fileprivate var topBarData = [TopBarData]()
    var options: PagingMenuControllerCustomizable = PagingMenuOptions()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        createTempTopBarData()
        setupPagingMenuController()
    }
    
    private func createTempTopBarData() {
        for i in 1..<7 {
            let data = TopBarData(imageName: "pic\(i).jpg", barName: "BarName\(i)", location: "Location\(i)")
            topBarData.append(data)
        }
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

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topBarData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ImageCardCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.initializeCollectionViewWith(data: topBarData[indexPath.row])
        // Configure the cell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.bounds.width
        let itemHeight = collectionView.bounds.height
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}
