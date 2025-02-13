//
//  AppReviewHostingController.swift
//  RemoteConfigDemo
//
//  Created by Mario Ban on 13.02.2025..
//


import UIKit
import SwiftUI

class AppReviewHostingController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.backgroundColor = .clear
        
        let appReviewView = RatingPromptView()
        
        let hostingController = UIHostingController(rootView: appReviewView)
        hostingController.view.backgroundColor = .clear
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.frame = view.bounds
        hostingController.didMove(toParent: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
