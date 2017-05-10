//
//  PagingMenuControllerOptions.swift
//  PagingMenuControllerDemo
//
//  Created by Yusuke Kita on 6/9/16.
//  Copyright © 2016 kitasuke. All rights reserved.
//

import Foundation
import PagingMenuController

struct MenuItemBeerSpecials: MenuItemViewCustomizable {}
struct MenuItemWineSpecials: MenuItemViewCustomizable {}
struct MenuItemLiquorSpecials: MenuItemViewCustomizable {}

struct PagingMenuOptions1: PagingMenuControllerCustomizable {
    let beerSpecialTableViewController = SpecialsViewController.instantiateFromStoryboard()
    let wineSpecialTableViewController = SpecialsViewController.instantiateFromStoryboard()
    let liquorSpecialTableViewController = SpecialsViewController.instantiateFromStoryboard()
    
    var componentType: ComponentType {
        return .all(menuOptions: MenuOptions(), pagingControllers: [beerSpecialTableViewController,
                                                                    liquorSpecialTableViewController,
                                                                    wineSpecialTableViewController])
    }
    var lazyLoadingPage: LazyLoadingPage {
        return .all
    }
    var defaultPage: Int {
        return 1
    }
    
    struct MenuOptions: MenuViewCustomizable {
        var displayMode: MenuDisplayMode {
            return .standard(widthMode: .flexible, centerItem: true, scrollingMode: .pagingEnabled)
        }
        var focusMode: MenuFocusMode {
            return .none
        }
        var height: CGFloat {
            return 20
        }
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItemBeerSpecials(), MenuItemWineSpecials(), MenuItemLiquorSpecials()]
        }
        var backgroundColor: UIColor {
            return .clear
        }
        var selectedBackgroundColor: UIColor {
            return .clear
        }
    }
    
    struct MenuItemBeerSpecials: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: "Beer", color: .lightText, selectedColor: .white)
            return .text(title: title)
        }
    }
    struct MenuItemWineSpecials: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: "Wine", color: .lightText, selectedColor: .white)
            return .text(title: title)
        }
    }
    struct MenuItemLiquorSpecials: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: "Liquor", color: .lightText, selectedColor: .white)
            return .text(title: title)
        }
    }

}
