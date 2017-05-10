//
//  SearchViewController.swift
//  Moon
//
//  Created by Evan Noble on 5/10/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import PagingMenuController

class SearchViewController: UIViewController {
    var options: PagingMenuControllerCustomizable = PagingMenuOptions1()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPagingMenuController()
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

extension SearchViewController {
    
}
