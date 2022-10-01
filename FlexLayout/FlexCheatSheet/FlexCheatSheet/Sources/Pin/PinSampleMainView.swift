//
//  PinSampleMainView.swift
//  FlexCheatSheet
//
//  Created by 홍경표 on 2022/09/28.
//

import UIKit

final class PinSampleMainView: UIView {

    private let containerView = UIView()

    private let headerView = PinSampleHeaderView()

    private let greenView = UIView().then {
        $0.backgroundColor = .systemGreen
    }

    init() {
        super.init(frame: .zero)
        setUpUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpUI() {
        backgroundColor = .systemBackground
        
        addSubview(containerView)
        containerView.addSubview(headerView)
        containerView.addSubview(greenView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.pin.all(pin.safeArea)
        headerView.pin.top().horizontally().sizeToFit(.width) // headerView의 content 사이즈
        greenView.pin.below(of: headerView, aligned: .center).width(100).bottom()
    }
}

final class PinSampleHeaderView: UIView {

    private let tempLabel = UILabel().then {
        $0.text = "Hello World!"
    }

    init() {
        super.init(frame: .zero)
        setUpUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpUI() {
        backgroundColor = .systemGray5

        addSubview(tempLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        tempLabel.pin.all()
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        // 1) Set the width to the specified width
        self.pin.width(size.width)

        // 2) Layout the contentView's controls
        return layout()
    }

    private func layout() -> CGSize {
        tempLabel.pin.top().horizontally().sizeToFit(.width)
        return .init(width: frame.width, height: tempLabel.frame.height)
    }
}
