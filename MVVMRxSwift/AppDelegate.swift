//
//  AppDelegate.swift
//  MVVMRxSwift
//
//  Created by Ahmed Khalaf on 10/01/2022.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = .init(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewController(viewModel: .init())
        window?.makeKeyAndVisible()
        return true
    }
}

