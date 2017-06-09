//
//  NotificationTableViewCell.swift
//  Moon
//
//  Created by Evan Noble on 6/9/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    @IBOutlet weak var enableSwitch: UISwitch!
    @IBOutlet weak var title: UILabel!
    
    
    func initCellWith(setting: NotifcationSetting) {
        title.text = setting.name
        enableSwitch.isOn = setting.enabled
    }
}
