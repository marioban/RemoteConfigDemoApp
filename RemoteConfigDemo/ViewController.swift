//
//  ViewController.swift
//  RemoteConfigDemo
//
//  Created by Mario Ban on 13.02.2025..
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let currentCount = UserDefaults.standard.integer(forKey: "app_session_count")
        print("Checking review in ViewController. Sessions: \(currentCount)")
        if currentCount >= 5 {
            let reviewController = AppReviewHostingController()
            // Postavi transition style
            reviewController.modalPresentationStyle = .overFullScreen
            reviewController.modalTransitionStyle = .crossDissolve
            present(reviewController, animated: true)
        }
    }
}
