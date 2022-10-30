//
//  MainView.swift
//  FlexCheatSheet
//
//  Created by 홍경표 on 2022/08/20.
//

import UIKit
import FlexLayout
import PinLayout

final class MainView: UIView {

    private let flexRootView = UIView()
    private lazy var refreshButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "arrow.clockwise.circle.fill"), for: .normal)
        $0.addTarget(self, action: #selector(onTapRefresh), for: .touchUpInside)
    }
    private let autoFlexView = FlexAutoLayoutCompatibleView()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUpUI()
        defined()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpUI() {
        backgroundColor = .systemBackground
        addSubview(flexRootView)
    }

    private func defined() {
        flexRootView
            .flex
            .justifyContent(.center)
            .define { flex in
                flex.addItem(refreshButton)
                    .position(.absolute)
                    .top(20)
                    .right(20)
                    .size(44)

                flex.addItem()
                    .padding(10)
                    .backgroundColor(.systemTeal)
                    .define { flex in
                        flex.addItem(autoFlexView)
                    }
            }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        flexRootView.pin.all(pin.safeArea)
        flexRootView.flex.layout()
    }

    @objc private func onTapRefresh() {
        autoFlexView.configure()
        setNeedsLayout()
    }
}
