//
//  FloatingTabBar+Rx.swift
//  Moon
//
//  Created by Evan Noble on 6/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

//swiftlint:disable force_cast
class RxFloatingBottomTabBarDelegateProxy: DelegateProxy, DelegateProxyType, FloatingBottomTabBarDelegate {
    class func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
        let tabBar = object as! FloatingBottomTabBar
        tabBar.delegate = delegate as? FloatingBottomTabBarDelegate
    }
    
    class func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        let tabBar = object as! FloatingBottomTabBar
        return tabBar.delegate
    }
}

extension Reactive where Base: FloatingBottomTabBar {
    var delegate: DelegateProxy {
        return RxFloatingBottomTabBarDelegateProxy.proxyForObject(base)
    }
    
    var showFeatured: Observable<Void> {
        return delegate.methodInvoked(#selector(FloatingBottomTabBarDelegate.showFeaturedView)).map {_ in
            return
        }
    }
    
    var showMoonsView: Observable<Void> {
        return delegate.methodInvoked(#selector(FloatingBottomTabBarDelegate.showMoonsView)).map {_ in
            return
        }
    }

    var showExploreView: Observable<Void> {
        return delegate.methodInvoked(#selector(FloatingBottomTabBarDelegate.showExploreView)).map {_ in
            return
        }
    }
    
}
