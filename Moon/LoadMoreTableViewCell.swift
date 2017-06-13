//
//  LoadMoreTableViewCell.swift
//  Moon
//
//  Created by Evan Noble on 6/12/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Action
import RxSwift

class LoadMoreTableViewCell: UITableViewCell {

    @IBOutlet weak var loadMore: UIButton!
    
    func initCell(loadAction: CocoaAction) {
        self.selectionStyle = UITableViewCellSelectionStyle.none
        loadMore.rx.action = loadAction
    }
    
    deinit {
        loadMore.rx.action = nil
    }

}
