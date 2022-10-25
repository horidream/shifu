//
//  AppDelegate.swift
//  Shifu
//
//  Created by horidream on 03/08/2017.
//  Copyright (c) 2017 horidream. All rights reserved.
//

import UIKit
import SwiftUI
import Shifu
import Combine

//var scenePhase = CurrentValueSubject<ScenePhase, Never>(.inactive)

////@UIApplicationMain
//final class AppDelegate: UIResponder, UIApplicationDelegate {
//
//    var window: UIWindow?
//
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        clg("yes")
//        return true
//    }
//
//    func applicationWillResignActive(_ application: UIApplication) {
//        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//        scenePhase.value = .inactive
//    }
//
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//        scenePhase.value = .background
//    }
//
//    func applicationWillEnterForeground(_ application: UIApplication) {
//        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//        scenePhase.value = .active
//    }
//
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        clg("did become active")
//        scenePhase.value = .active
//    }
//
//    func applicationWillTerminate(_ application: UIApplication) {
//        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    }
//
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        let sceneConfiguration = UISceneConfiguration(name: "Quick Action Scene", sessionRole: connectingSceneSession.role)
//        sceneConfiguration.delegateClass = SceneDelegate.self
//        return sceneConfiguration
//    }
//}
//
//
//class SceneDelegate: UIResponder, UIWindowSceneDelegate{
//    var window: UIWindow?
//
//      func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//          clg("scene")
//        if let windowScene = scene as? UIWindowScene {
//            let window = UIWindow(windowScene: windowScene)
//            let vm = HomeViewModel()
//            window.rootViewController = UIHostingController(rootView: vm.view{
//                HomeView()
//            })
//            vm.initServer()
//            self.window = window
//            window.makeKeyAndVisible()
//        }
//      }
//
//    func sceneDidBecomeActive(_ scene: UIScene) {
//        scenePhase.value = .active
//    }
//    func sceneDidEnterBackground(_ scene: UIScene) {
//        scenePhase.value = .background
//    }
//    func sceneWillResignActive(_ scene: UIScene) {
//        scenePhase.value = .inactive
//    }
//    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
//        clg("short cut item 2", shortcutItem)
//    }
//}


@main
struct ShifuExampleApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    init() {
        clg("main")
    }
    var body: some Scene {
        WindowGroup {
            let vm = HomeViewModel()
            vm.view {
                HomeView()
            }
        }
    }
}
