//
//  AppDelegate.swift
//  RemoteConfigDemo
//
//  Created by Mario Ban on 13.02.2025..
//

import UIKit
import FirebaseCore
import FirebaseAnalytics
import FirebaseRemoteConfig

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //UserDefaults.standard.removeObject(forKey: "last_review_request_date")
        FirebaseApp.configure()
        setupRemoteConfig()
        trackAppOpen()
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

    private func setupRemoteConfig() {
        let remoteConfig = RemoteConfig.remoteConfig()
        
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        let defaults: [String: NSObject] = [
            "enable_review_prompt": false as NSNumber,  // Change to true for testing
            "min_sessions_before_review": 5 as NSNumber
        ]
        remoteConfig.setDefaults(defaults)
        
        remoteConfig.fetch { status, error in
            if status == .success {
                remoteConfig.activate { changed, error in
                    print("Remote config activated with changes: \(changed)")
                    DispatchQueue.main.async {
                        ReviewManager.shared.checkAndRequestReview()
                    }
                }
            }
        }
    }
    
    private func trackAppOpen() {
        let currentCount = UserDefaults.standard.integer(forKey: "app_session_count")
        UserDefaults.standard.set(currentCount + 1, forKey: "app_session_count")
        
        print("App opened \(currentCount + 1) times")
        
        Analytics.logEvent("app_open", parameters: [
            "session_count": currentCount + 1 as NSNumber
        ])
    }

}

