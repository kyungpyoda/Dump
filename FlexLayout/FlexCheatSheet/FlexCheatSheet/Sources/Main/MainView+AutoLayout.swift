//
//  NonFlexLayoutMainView.swift
//  FlexCheatSheet
//
//  Created by 홍경표 on 2022/10/30.
//

import FlexLayout
import PinLayout
import UIKit

final class AutoLayoutMainView: UIView {

    private lazy var refreshButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "arrow.clockwise.circle.fill"), for: .normal)
        $0.addTarget(self, action: #selector(onTapRefresh), for: .touchUpInside)
    }
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill

        $0.isLayoutMarginsRelativeArrangement = true
        $0.directionalLayoutMargins = .init(top: 10, leading: 10, bottom: 10, trailing: 10)

        $0.backgroundColor = .systemTeal
    }
    private let autoFlexView = FlexAutoLayoutCompatibleView()

    init() {
        super.init(frame: .zero)
        setUpUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpUI() {
        backgroundColor = .systemBackground

        addSubview(refreshButton)
        addSubview(stackView)
        stackView.addArrangedSubview(autoFlexView)

        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            refreshButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            refreshButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            refreshButton.widthAnchor.constraint(equalToConstant: 44),
            refreshButton.heightAnchor.constraint(equalToConstant: 44),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }

    @objc private func onTapRefresh() {
        autoFlexView.configure()
    }
}
