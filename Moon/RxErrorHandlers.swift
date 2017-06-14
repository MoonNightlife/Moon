//
//  RxErrorHandlers.swift
//  Moon
//
//  Created by Evan Noble on 6/14/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift

class RxErrorHandlers {
    
    enum APIError {
        case userNotFound
        case barNotFound
    }
    
    static let maxAttempts = 4
    
    let retryHandler: (Observable<Error>) -> Observable<Int> = { e in
        return e.flatMapWithIndex { (error, attempt) -> Observable<Int> in
            if attempt >= maxAttempts - 1 {
                return Observable.error(error)
            } else if let casted = error as? APIError, casted
                == .userNotFound {
//                return ApiController.shared.apiKey
//                    .filter {$0 != ""}
//                    .map { _ in return 1 }
            } else if let casted = error as? NSError, casted.code == -1009 {
                return RxReachability.shared.status
                    .filter { $0 == .online }
                    .map({ _ in return 1 })
            }
            print("== retrying after \(attempt + 1) seconds ==")
            return Observable<Int>.timer(Double(attempt + 1), scheduler:
                MainScheduler.instance)
                .take(1)
        }
    }
    
    init() {
        print("RxErrorHandlerCreated")
    }
}
