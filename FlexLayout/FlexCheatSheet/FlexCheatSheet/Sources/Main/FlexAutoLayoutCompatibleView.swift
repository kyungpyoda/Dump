//
//  FlexAutoLayoutCompatibleView.swift
//  FlexCheatSheet
//
//  Created by 홍경표 on 2022/08/14.
//

import UIKit
import FlexLayout
import PinLayout

final class FlexAutoLayoutCompatibleView: UIView {

    private let tempLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .title1)
        $0.numberOfLines = 0
    }

    init() {
        super.init(frame: .zero)
        setUpUI()
        defined()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpUI() {
        backgroundColor = .systemYellow
    }

    private func defined() {
        self
            .flex
            .define { flex in
                flex.addItem(tempLabel)
            }
    }

    override var intrinsicContentSize: CGSize {
        return frame.size
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        flex.layout(mode: .adjustHeight)
        invalidateIntrinsicContentSize()
    }

    func configure() {
        tempLabel.text = (0...Int.random(in: 10...50)).reduce("", { $0 + "\($1)" })
        tempLabel.flex.markDirty()
        setNeedsLayout()
    }
}
