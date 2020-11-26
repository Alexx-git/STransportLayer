//
//  AppDelegate.swift
//  ServerTarget
//
//  Created by Vlad on 26.11.2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let navCon = UINavigationController(rootViewController: ViewController())
        window?.rootViewController = navCon
        window?.makeKeyAndVisible()
        return true
    }

}

