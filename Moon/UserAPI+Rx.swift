//
//  UserAPI+Rx.swift
//  Moon
//
//  Created by Evan Noble on 6/9/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwaggerClient

extension UserAPI {
    open class func createNewUser(user: RegistrationProfile) -> Observable<Void> {
        return Observable.create({ (observer) in
            UserAPI.userRegister(body: user, completion: { (error) in
                guard let e = error else {
                    observer.onCompleted()
                    return
                }
                
                observer.onError(e)
            })
            
            return Disposables.create()
        })
    }
}
