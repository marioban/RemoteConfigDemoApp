//
//  ReviewManager.swift
//  RemoteConfigDemo
//
//  Created by Mario Ban on 13.02.2025..
//


import UIKit
import Firebase
import FirebaseAnalytics
import StoreKit

class ReviewManager {
    static let shared = ReviewManager()
    
    private let lastReviewRequestKey = "last_review_request_date"
    private let minimumDaysBetweenRequests = 90
    
    func checkAndRequestReview() {
        let remoteConfig = RemoteConfig.remoteConfig()
        
        let shouldShowReview = remoteConfig.configValue(forKey: "enable_review_prompt").boolValue
        let minSessionsBeforeReview = remoteConfig.configValue(forKey: "min_sessions_before_review").numberValue.intValue
        
        print("Should show review: \(shouldShowReview)")
        print("Min sessions needed: \(minSessionsBeforeReview)")
        print("Current session count: \(UserDefaults.standard.integer(forKey: "app_session_count"))")
        
        if let lastRequest = UserDefaults.standard.object(forKey: lastReviewRequestKey) as? Date {
            let daysSinceLastRequest = Calendar.current.dateComponents([.day], from: lastRequest, to: Date()).day ?? 0
            print("Days since last request: \(daysSinceLastRequest)")
            if daysSinceLastRequest < minimumDaysBetweenRequests {
                print("Not enough days passed since last request")
                return
            }
        }
        
        let sessionCount = UserDefaults.standard.integer(forKey: "app_session_count")
        
        if shouldShowReview && sessionCount >= minSessionsBeforeReview {
            print("Showing review prompt")
            requestReview()
            UserDefaults.standard.set(Date(), forKey: lastReviewRequestKey)
        } else {
            print("Conditions not met for review")
        }
    }
    
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
            
            Analytics.logEvent("review_prompt_shown", parameters: [
                "session_count": UserDefaults.standard.integer(forKey: "app_session_count") as NSNumber
            ])
        }
    }
}
