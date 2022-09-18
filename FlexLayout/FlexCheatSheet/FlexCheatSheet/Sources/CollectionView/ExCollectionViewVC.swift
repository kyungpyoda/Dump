//
//  ExCollectionViewVC.swift
//  FlexCheatSheet
//
//  Created by 홍경표 on 2022/09/07.
//

import UIKit

final class ExCollectionViewVC: UIViewController {

    private lazy var exCollectionViewMainView = ExCollectionViewMainView()

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = exCollectionViewMainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        exCollectionViewMainView.viewDidLoad()
    }

}
