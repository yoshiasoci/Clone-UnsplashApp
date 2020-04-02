//
//  AppDelegate.swift
//  Clone-UnsplashApp
//
//  Created by admin on 3/23/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var coordinator: MainTabBarCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        UINavigationBar.appearance().barTintColor = UIColor.black
////        UINavigationBar.appearance().tintColor = UIColor.white
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
//        UINavigationBar.appearance().isOpaque = true

        // your color
        
        window = .init(frame: UIScreen.main.bounds)
        coordinator = .init(window: window)
        window?.makeKeyAndVisible()
        coordinator.start()
        
        
        return true
    }


}

