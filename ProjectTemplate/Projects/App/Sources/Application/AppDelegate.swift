//
//  AppDelegate.swift
//  Template
//
//  Created by 홍경표 on 2022/09/18.
//  Copyright © 2022 pio. All rights reserved.
//

import UIKit
import Then

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        initializeWindow()

        start()

        return true
    }

    private func initializeWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
    }

    private func start() {
        let vc = UIViewController()
        window?.rootViewController = vc
        vc.view.backgroundColor = .systemGreen
    }
}
