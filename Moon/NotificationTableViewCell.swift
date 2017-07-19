//
//  NotificationTableViewCell.swift
//  Moon
//
//  Created by Evan Noble on 6/9/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NotificationTableViewCell: UITableViewCell {
    var bag = DisposeBag()
    
    @IBOutlet weak var enableSwitch: UISwitch!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        title.font = UIFont.moonFont(size: 16)
        selectionStyle = .none
    }
    
}
