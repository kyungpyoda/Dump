//
//  MainVC.swift
//  FlexCheatSheet
//
//  Created by 홍경표 on 2022/08/14.
//

import UIKit

final class MainVC: UIViewController {

    private lazy var mainView = MainView()

    override func loadView() {
        view = mainView
    }

}
