//
//  AppDelegate.swift
//  FlexCheatSheet
//
//  Created by 홍경표 on 2022/08/14.
//

import UIKit
import Then
import SnapKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        initializeWindow()

        goMain()

        return true
    }

    private func initializeWindow() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
    }

    private func goMain() {
        self.window?.rootViewController = PinSampleVC()
    }

}
