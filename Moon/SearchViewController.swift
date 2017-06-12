//
//  SearchViewController.swift
//  Moon
//
//  Created by Evan Noble on 6/11/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, BindableType, ParentType {
    
    var viewModel: SearchViewModel!
    
    // Protocal Implementation
    var view1: UIView! {
        get {
            return suggestedContentView
        }
        set {
            suggestedContentView = newValue
        }
    }
    
    var view2: UIView! {
        get {
            return searchResultsView
        }
        set {
            searchResultsView = newValue
        }
    }

    @IBOutlet weak var suggestedContentView: UIView!
    @IBOutlet weak var searchResultsView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func bindViewModel() {
        
    }

}
