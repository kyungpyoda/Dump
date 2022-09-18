//
//  MainView.swift
//  AaView
//
//  Created by 홍경표 on 2022/08/14.
//

import UIKit
import FlexLayout
import PinLayout

final class AaView: UIView {

    private let flexRootView = UIView()

    private let tempLabel = UILabel()

    init() {
        super.init(frame: .zero)
        setUpUI()
        defined()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpUI() {
        addSubview(flexRootView)
    }

    private func defined() {
        flexRootView
            .flex
            .backgroundColor(.systemTeal)
            .define { flex in
                flex.addItem(tempLabel)
//                    .grow(1)
//                    .padding(10)
            }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }

    fileprivate func layout(_ size: CGSize) {
//        flexRootView.pin.width(size.width)
        flexRootView.pin.size(size)
//        flexRootView.flex.layout(mode: .adjustHeight)
    }

//    override func sizeThatFits(_ size: CGSize) -> CGSize {
//        layout(size)
//        return flexRootView.frame.size
//    }

    private func layout() {
        flexRootView.pin.all()
        flexRootView.flex.layout()
    }

    func configure() {
        tempLabel.text = (0...Int.random(in: 1...30)).reduce("", { $0 + "\($1)" })
        tempLabel.flex.markDirty()
        setNeedsLayout()
    }
}
