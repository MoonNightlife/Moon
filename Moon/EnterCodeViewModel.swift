//
//  EnterCodeViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/15/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import Action
import RxSwift
import RxCocoa

struct EnterCodeViewModel: BackType {
    // Private
    
    // Dependencies
    let sceneCoordinator: SceneCoordinatorType
    
    // Inputs
    var code = BehaviorSubject<String>(value: "")
    
    // Actions
    
    // Outputs
    var enableCheckCodeButton: Observable<Bool>
    var codeText: Observable<String>
    
    init(coordinator: SceneCoordinatorType) {
        self.sceneCoordinator = coordinator
        
        let formattedText = code.map({ code -> String in
            if code.characters.count > 4 {
                return code.substring(to: code.index(code.startIndex, offsetBy: 4))
            } else {
                return code
            }
        })
        
        codeText = formattedText
        
        enableCheckCodeButton = formattedText.map({
            print($0)
            return $0.characters.count == 4
        })
    }
}
