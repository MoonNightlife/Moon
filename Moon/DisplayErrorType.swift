//
//  DisplayErrorType.swift
//  Moon
//
//  Created by Evan Noble on 6/26/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import Whisper
import Action

protocol DisplayErrorType {
    func dispayErrorMessage(error: ActionError)
}

extension DisplayErrorType {
    func dispayErrorMessage(error: ActionError) {
        
        var message = Murmur(title: "Couldn't load data", backgroundColor: .white, titleColor: .darkGray, font: UIFont.moonFont(size: 12), action: nil)
        
        guard case let ActionError.underlyingError(e) = error else {
            return
        }
        
        switch (e as NSError).code {
        case -1009:
            message.title = "No internet connection"
        default:
            message.title = "Couldn't load data"
        }
        
        Whisper.show(whistle: message)
    }
}
