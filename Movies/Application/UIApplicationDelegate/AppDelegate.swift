//
//  AppDelegate.swift
//  Movies
//
//  Created by Владислав Баранкевич on 20.09.2023.
//

import UIKit
import SDWebImage

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
    }
}
