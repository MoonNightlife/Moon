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
    
    static let retryHandler: (Observable<Error>) -> Observable<Int> = { e in
        return e.flatMapWithIndex { (error, attempt) -> Observable<Int> in
            // If attemped to retrieve image 4 time with no success then throw error
            if attempt >= maxAttempts - 1 {
                return Observable.error(error)
            } else if (error as NSError).code == -1009 {
                return Observable.error(error)
            }
            print("== retrying after \(attempt + 1) seconds ==")
            // Increase the wait time between download attempts
            return Observable<Int>.timer(Double(attempt + 1), scheduler:
                MainScheduler.instance)
                .take(1)
        }
    }
    
    static let retryHandlerWithConnectionRestart: (Observable<Error>) -> Observable<Int> = { e in
        return e.flatMapWithIndex { (error, attempt) -> Observable<Int> in
            // If attemped to retrieve image 4 time with no success then throw error
            if attempt >= maxAttempts - 1 {
                return Observable.error(error)
            } else if (error as NSError).code == -1009 {
                // If there is an internet connection error then wait till connection reestablished
                return RxReachability.shared.status
                    .filter {
                        $0 == .online
                    }
                    .map({ _ in return 1 })
            }
            print("== retrying after \(attempt + 1) seconds ==")
            // Increase the wait time between download attempts
            return Observable<Int>.timer(Double(attempt + 1), scheduler:
                MainScheduler.instance)
                .take(1)
        }
    }
    
    static let imageRetryHandler: (Observable<Error>) -> Observable<Int> = { e in
        return e.flatMapWithIndex { (error, attempt) -> Observable<Int> in
            // If attemped to retrieve image 4 time with no success then throw error
            if attempt >= maxAttempts - 1 {
                return Observable.error(error)
            } else if (error as NSError).code == -1009 {
                // If there is an internet connection error then wait till connection reestablished
                return RxReachability.shared.status
                    .filter { $0 == .online }
                    .map({ _ in return 1 })
            }
            print("== retrying after \(attempt + 1) seconds ==")
            // Increase the wait time between download attempts
            return Observable<Int>.timer(Double(attempt + 1), scheduler:
                MainScheduler.instance)
                .take(1)
        }
    }
    
    init() {
        print("RxErrorHandlerCreated")
    }
}
