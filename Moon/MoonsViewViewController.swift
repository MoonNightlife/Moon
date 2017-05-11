//
//  MoonsViewViewController.swift
//  Moon
//
//  Created by Evan Noble on 5/11/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import PageMenu

class MoonsViewViewController: UIViewController {

    class func instantiateFromStoryboard() -> MoonsViewViewController {
        let storyboard = UIStoryboard(name: "MoonsView", bundle: nil)
        // swiftlint:disable:next force_cast
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! MoonsViewViewController
    }
    
    var pageMenu: CAPSPageMenu?
    var controllerArray = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPagingMenuController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MoonsViewViewController {
    fileprivate func setupPagingMenuController() {
        let beerSpecialsController = BarActivityFeedViewController.instantiateFromStoryboard()
        beerSpecialsController.title = "Friend Feed"
        controllerArray.append(beerSpecialsController)
        
        let parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(4.3),
            .menuItemSeparatorPercentageHeight(0.1),
            .scrollMenuBackgroundColor(.clear),
            .selectionIndicatorColor(.clear),
            .addBottomMenuHairline(false),
            .selectionIndicatorColor(.white),
            .unselectedMenuItemLabelColor(.lightText)
            
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: self.view.frame, pageMenuOptions: parameters)
        pageMenu?.view.backgroundColor = .lightGray
        if let view = pageMenu?.view {
            self.view.addSubview(view)
        }
        
    }
}
