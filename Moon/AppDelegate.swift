//
//  AppDelegate.swift
//  Moon
//
//  Created by Evan Noble on 4/16/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit
import RxSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AuthNetworkingInjected {
    
    enum LaunchScreen {
        case login
        case barProfile(id: String)
        case main
    }

    var window: UIWindow?
    var bag = DisposeBag()
    let gcmMessageIDKey = "gcm.message_id"
    

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.shared.statusBarStyle = .lightContent
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        setupPushNotifications(application: application)
        
        FirebaseApp.configure()
        
        if RxReachability.shared.startMonitor("apple.com") == false {
            print("Reachability failed!")
        }
        
        if let url = launchOptions?[.url] as? URL {
            return executeDeepLink(with: url)
        } else {
            if let userID = Auth.auth().currentUser?.uid {
                prepareEntryViewController(vc: .main)
                return true
                
                authAPI.checkForFirstTimeLogin(userId: userID).subscribe(onNext: { [unowned self] firstTime in
                    if firstTime {
                        self.prepareEntryViewController(vc: .login)
                    }
                }).addDisposableTo(bag)
                
            } else {
                prepareEntryViewController(vc: .login)
                return true
            }
        }
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let dynamicLink = DynamicLinks.dynamicLinks()?.dynamicLink(fromCustomSchemeURL: url)
        if let dynamicLink = dynamicLink, let url = dynamicLink.url {
            return executeDeepLink(with: url)
        }
        
        FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        
        return false
    }
    
    @available(iOS 8.0, *)
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        guard let dynamicLinks = DynamicLinks.dynamicLinks() else {
            return false
        }
        let handled = dynamicLinks.handleUniversalLink(userActivity.webpageURL!) { [weak self] (dynamiclink, error) in
            if let url = dynamiclink?.url {
                _ = self?.executeDeepLink(with: url)
            } else if let e = error {
                print(e)
            }
        }
        
        return handled
    }
    
}

// MARK: - Helper Fuctions
extension AppDelegate {
    fileprivate func prepareEntryViewController(vc: LaunchScreen) {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let sceneCoordinator = SceneCoordinator(window: window!)
        
        switch vc {
        case .login:
            let viewModel = LoginViewModel(coordinator: sceneCoordinator)
            let firstScene = Scene.Login.login(viewModel)
            sceneCoordinator.transition(to: firstScene, type: .root)
        case .main:
            let mainVM = MainViewModel(coordinator: sceneCoordinator)
            let searchVM = SearchBarViewModel(coordinator: sceneCoordinator)
            sceneCoordinator.transition(to: Scene.Master.searchBarWithMain(searchBar: searchVM, mainView: mainVM), type: .root)
        case .barProfile(let id):
            let mainVM = MainViewModel(coordinator: sceneCoordinator)
            let searchVM = SearchBarViewModel(coordinator: sceneCoordinator)
            sceneCoordinator.transition(to: Scene.Master.searchBarWithMain(searchBar: searchVM, mainView: mainVM), type: .root)
            let barVM = BarProfileViewModel(coordinator: sceneCoordinator, barID: id)
            sceneCoordinator.transition(to: Scene.Bar.profile(barVM), type: .modal)
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    fileprivate func setupPushNotifications(application: UIApplication) {
        
        Messaging.messaging().delegate = self
        //Messaging.messaging().shouldEstablishDirectChannel = true
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    
    // This is called when the application receievs a notification in the foregruond
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    // This is called when the application receives a notification in the background and the user
    // opens the app
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Reset the badge icon when the user views the notifcations from the background
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        completionHandler()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
}

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}

// MARK: - Deep Link
extension AppDelegate {
    fileprivate func executeDeepLink(with url: URL) -> Bool {
        // Create a recognizer with this app's custom deep link types.
        let recognizer = DeepLinkRecognizer(deepLinkTypes: [ShowEventDeepLink.self])
        
        // Try to create a deep link object based on the URL.
        guard let deepLink = recognizer.deepLink(matching: url) else {
            print("Unable to match URL: \(url.absoluteString)")
            return false
        }
        
        // Navigate to the view or content specified by the deep link.
        switch deepLink {
        case let link as ShowEventDeepLink: return showEvent(with: link)
        default: fatalError("Unsupported DeepLink: \(type(of: deepLink))")
        }
    }
    
    fileprivate func showEvent(with deepLink: ShowEventDeepLink) -> Bool {
        prepareEntryViewController(vc: .barProfile(id: deepLink.barID))
        print("Show Event")
        return true
    }
}
