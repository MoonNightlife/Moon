//
//  CountryCodeViewController.swift
//  Moon
//
//  Created by Evan Noble on 6/15/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Material

class CountryCodeViewController: UIViewController, BindableType {

    var viewModel: CountryCodeViewModel!
    var bag = DisposeBag()
    
    @IBOutlet weak var countryCodeTableView: UITableView!
    var navBackButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareNavigationBackButton()
    }

    func bindViewModel() {
        
        viewModel.countryCodes.bind(to: countryCodeTableView.rx.items(cellIdentifier: "CountryCodeCell", cellType: UITableViewCell.self)) { (_, element, cell) in
            cell.textLabel?.text = element
        }.addDisposableTo(bag)
        
        let selectedIndex = countryCodeTableView.rx.itemSelected
        selectedIndex.map({ $0.row }).map({ CountryCode(rawValue: $0) ?? CountryCode.US }).subscribe(viewModel.updateCode.inputs).addDisposableTo(bag)
    }
    
    fileprivate func prepareNavigationBackButton() {
        navBackButton = UIBarButtonItem()
        navBackButton.image = Icon.cm.arrowDownward
        navBackButton.tintColor = .white
        self.navigationItem.leftBarButtonItem = navBackButton
    }
}
