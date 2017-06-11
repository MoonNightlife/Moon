//
//  SearchViewController.swift
//  Moon
//
//  Created by Evan Noble on 6/11/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, BindableType {
    
    var viewModel: SearchViewModel!

    @IBOutlet weak var suggestedContentView: UIView!
    @IBOutlet weak var searchResultsView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        createViewsForContainers()
    }
    
    func bindViewModel() {
        
    }
    
    func createViewsForContainers() {
        
        // Search Results
        let searchResults = Scene.Master.searchResults(viewModel.createSearchResultsViewModel()).viewController()
        
        addChildViewController(searchResults)
        
        searchResults.view.frame = CGRect(x: 0, y: 0, width: searchResultsView.frame.width, height: searchResultsView.frame.height)
        searchResultsView.addSubview(searchResults.view)
        searchResults.didMove(toParentViewController: self)
        
        // Map Overview
        let suggestedVC = Scene.Master.contentSuggestions(viewModel.createContentSuggestedViewModel()).viewController()
        
        addChildViewController(suggestedVC)
        suggestedVC.view.frame = CGRect(x: 0, y: 0, width: suggestedContentView.frame.width, height: suggestedContentView.frame.height)
        suggestedContentView.addSubview(suggestedVC.view)
        suggestedVC.didMove(toParentViewController: self)
        
        searchResultsView.isHidden = true
        suggestedContentView.isHidden = false
    }

}
