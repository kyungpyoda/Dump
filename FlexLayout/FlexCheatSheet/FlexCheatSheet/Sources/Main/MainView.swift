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
    private let refreshButton: UIButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "arrow.clockwise.circle.fill"), for: .normal)
        $0.addTarget(self, action: #selector(onTapRefresh), for: .touchUpInside)
    }
    private let aaView: AaView = AaView()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUpUI()
        defined()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpUI() {
        self.backgroundColor = .systemGreen
        addSubview(flexRootView)
    }

    private func defined() {
        flexRootView
            .flex
            .backgroundColor(.systemGreen)
            .define { flex in
                flex.addItem(refreshButton)
                    .position(.absolute)
                    .top(30)
                    .right(30)

                flex.addItem(aaView)
                    .justifyContent(.center)
            }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }

    private func layout() {
        flexRootView.pin.all()
        flexRootView.flex.layout(mode: .adjustHeight)
    }

    @objc private func onTapRefresh() {
        aaView.configure()
        setNeedsLayout()
    }
}
