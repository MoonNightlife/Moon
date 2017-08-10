//
//  TopErrorMessage.swift
//  Moon
//
//  Created by Evan Noble on 8/9/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit

class TopErrorMessage: UIView {
    
    class func instanceFromNib() -> TopErrorMessage {
        //swiftlint:disable:next force_cast
        return UINib(nibName: "TopErrorMessageView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TopErrorMessage
    }

    var displayMessage: String? {
        didSet {
            messageLabel.text = displayMessage
        }
    }
    
    @IBOutlet weak private var messageLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        self.backgroundColor = .moonRed
        messageLabel.font = .moonFont(size: 16)
    }
}
