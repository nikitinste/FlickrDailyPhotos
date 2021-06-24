//
//  AppDelegate.swift
//  Flickr Daily Photos
//
//  Created by Степан Никитин on 21.06.2021.
//

import UIKit

let key = "1b94d18c639e8a1dfa52855ca21ef65f"

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        
        let navigationController = UINavigationController(rootViewController: DailyListTableViewController())
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }

}

