//
//  AppDelegate.swift
//  Instagram-Clone
//
//  Created by Catherine Shing on 3/1/23.
//

import UIKit
import Parse

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        var keys: NSDictionary?

        guard Bundle.main.path(forResource: "ParseCreds", ofType: "plist") != nil else {
              fatalError("Couldn't find file 'ParseCreds.plist'.")
            }
        if let dict = keys {
            let applicationId = dict["parseAppId"] as? String
            let clientKey = dict["clientKey"] as? String

            // Initialize Parse.
            Parse.setApplicationId(applicationId!, clientKey: clientKey!)
        }
        
        let configuration = ParseClientConfiguration {
            $0.applicationId = "DZ65ZXZQ1hUdqH65COYuKOE3iapDBiCMY4rydRGf"
            $0.clientKey = "YiEfdLFSXFRpW2z0enXmHkGA8NbqKzYm77u8jmOh"
            $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: configuration)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

