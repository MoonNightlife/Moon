//
//  MoonsViewViewController.swift
//  Moon
//
//  Created by Evan Noble on 5/11/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import ActionButton
import Material

class MoonsViewViewController: UIViewController, BindableType {
    
    var viewModel: MoonsViewViewModel!

    class func instantiateFromStoryboard() -> MoonsViewViewController {
        let storyboard = UIStoryboard(name: "MoonsView", bundle: nil)
        // swiftlint:disable:next force_cast
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! MoonsViewViewController
    }
    
    @IBOutlet weak var mapViewContainerView: UIView!
    @IBOutlet weak var friendFeedContainer: UIView!
    
    var changeViewActionButton: ActionButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapViewContainerView.isHidden = true
        friendFeedContainer.isHidden = false
        
        let items = setupActionButtonItems()
        setupActionButton(items: items)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //changeViewActionButton.fadeIn()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //changeViewActionButton.fadeOut()
    }
    
    func bindViewModel() {
        
    }
}

extension MoonsViewViewController {
    
    fileprivate func setupActionButtonItems() -> [ActionButtonItem] {
        let friendFeedAction = ActionButtonItem(title: "Feed", image: Icon.cm.moreVertical)
        friendFeedAction.action = { item in
            self.friendFeedContainer.isHidden = false
            self.mapViewContainerView.isHidden = true
            self.changeViewActionButton.toggleMenu()
        }
        
        let mapViewAction = ActionButtonItem(title: "Map", image: Icon.cm.photoCamera)
        mapViewAction.action = { item in
            self.mapViewContainerView.isHidden = false
            self.friendFeedContainer.isHidden = true
            self.changeViewActionButton.toggleMenu()
        }
        
        return [friendFeedAction, mapViewAction]

    }
    
    fileprivate func setupActionButton(items: [ActionButtonItem]) {
        changeViewActionButton = ActionButton(attachedToView: self.view, items: items)
        changeViewActionButton.backgroundColor = .moonPurple
        
        changeViewActionButton.setTitle(nil, forState: .normal)
        changeViewActionButton.setImage(Icon.cm.moreHorizontal?.tint(with: .white), forState: .normal)
        changeViewActionButton.action = { button in button.toggleMenu() }
    }
    
}
