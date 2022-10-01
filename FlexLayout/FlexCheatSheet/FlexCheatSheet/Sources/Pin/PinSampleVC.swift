//
//  PinSampleVC.swift
//  FlexCheatSheet
//
//  Created by 홍경표 on 2022/09/28.
//

import UIKit

final class PinSampleVC: UIViewController {

    private lazy var pinSampleMainView = PinSampleMainView()

    override func loadView() {
        view = pinSampleMainView
    }

}
